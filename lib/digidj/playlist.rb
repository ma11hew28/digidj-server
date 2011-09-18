require "net/http"

module DigiDJ
  class Playlist
    PLAYLISTS_KEY = "playlists"
    SPOTIFY_HOST = "localhost"
    SPOTIFY_PORT = "8081"

    attr_accessor :playlist_id

    def initialize(playlist_id)
      @playlist_id = playlist_id
    end

    def self.uri_root
      "spotify:user:brianyang:playlist:"
    end

    def self.all_hard_coded
      [
        {
          playlist_id: "7Bdmon1qvlkMQjIIkMKdeC",
          foursquare_venue: { id: "4c5c076c7735c9b6af0e8b72", name: "General Assembly" },
          venmo_user: { username: "bysoft", name: "Brian Yang" }
        },
        {
          playlist_id: "4EfV9dsnmmu6Uj6EDm5kMS",
          foursquare_venue: { id: "4e345b98d22d86185a608ab8", name: "Venmo" },
          venmo_user: { username: "iqram", name: "Iqram Magdon-Ismail" }
        },
        {
          playlist_id: "0rioY4gwnhneL3aoQkdMUT",
          foursquare_venue: { id: "4accdf38f964a520d2c920e3", name: "The Pump Energy Food" },
          venmo_user: { username: "matthew-hamilton", name: "Matthew Hamilton" }
        },
        {
          playlist_id: "5KSQIqdWahTPDa8TSDyOUD",
          foursquare_venue: { id: "460d4b66f964a52005451fe3", name: "Whole Foods" },
          venmo_user: { username: "mattdipasquale", name: "Matt Di Pasquale" }
        },
        {
          playlist_id: "45GxxjuyZK4YZ1HOsHm6ZO",
          foursquare_venue: { id: "40b68100f964a5207d001fe3", name: "Madison Square Park" },
          venmo_user: { username: "christineh", name: "Christine Horvat" }
        },
        {
          playlist_id: "3gkcyUIufrvvmOQRE53zYK",
          foursquare_venue: { id: "42911d00f964a520f5231fe3", name: "New York Penn Station" },
          venmo_user: { username: "graham", name: "John Graham" }
        },
        {
          playlist_id: "387MZDFI0hDL7si1Dy5zBQ",
          foursquare_venue: { id: "4ac7c7a3f964a520b9b920e3", name: "Victoria's Secret" },
          venmo_user: { username: "jesse-bentert", name: "Jesse Bentert" }
        },
        {
          playlist_id: "1bSK76btfpfZDkTK6VHcYx",
          foursquare_venue: { id: "4bc8903115a7ef3bc2507bda", name: "Spotify" },
          venmo_user: { username: "gandalf@spotify.com", name: "Gandalf Hernandez" }
        }
      ]
    end

    def self.all
      DigiDJ.redis.smembers(PLAYLISTS_KEY)
    end

    def valid?
      return !@playlist_id.blank?
    end

    def save
      DigiDJ.redis.sadd(PLAYLISTS_KEY, @playlist_id)
    end

    def tracks
      tracks = []
      self.track_ids.each_slice(2) do |t|
        tracks << Track.new(t[0], ("%.2f" % (t[1].to_i/100.0)))
      end
      tracks
    end

    def update_track_everywhere(track_id, dollar_amount)
      position_before = self.track_position(track_id)
      return false unless self.update_track(track_id, dollar_amount)
      position_after = self.track_position(track_id)

      if position_before.nil?
        self.spotify_insert_track(track_id, position_after)
      elsif position_after != position_before
        self.spotify_delete_track(track_id)
        self.spotify_insert_track(track_id, position_after)
      end

      true
    end

    def track_position(track_id)
      DigiDJ.redis.zrevrank(tracks_key, track_id)
    end
      
    def update_track(track_id, dollar_amount)
      dollar_amount = dollar_amount.to_f
      return false if !self.valid? or dollar_amount <= 0.0 or track_id.blank?
      current_cents = self.track_cents(track_id).to_i
      new_cents = current_cents + (dollar_amount*100).to_i
      self.add_track(track_id, new_cents.to_s)
      true
    end

    def spotify_delete_track(track_id)
      path = "/delete/spotify:user:brianyang:playlist:#{@playlist_id}/spotify:track:#{track_id}"
      self.get_path path # make synchronous to make sure delete finishes before we insert
    end

    def spotify_insert_track(track_id, position)
      path = "/add/spotify:user:brianyang:playlist:#{@playlist_id}/spotify:track:#{track_id}/#{position}"
      Thread.new { self.get_path path }
    end

    def spotify_list_tracks
      path = "/list/spotify:user:brianyang:playlist:#{@playlist_id}"
      self.get_path path
    end

# private # this breaks tests...

    def tracks_key
      "playlists:#{@playlist_id}:tracks"
    end

    def track_ids(options={with_scores: true})
      DigiDJ.redis.zrevrange(tracks_key, 0, -1, with_scores: options[:with_scores])
    end

    def track_cents(track_id)
      DigiDJ.redis.zscore(tracks_key, track_id)
    end

    def add_track(track_id, cents)
      DigiDJ.redis.zadd(tracks_key, cents, track_id)
    end
    
    def get_path(path)
      Net::HTTP.get_print SPOTIFY_HOST, path, SPOTIFY_PORT
    end
  end
end