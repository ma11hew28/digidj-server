require "spec_helper"
require "rack/test"

module DigiDJ
  describe Application do
    include Rack::Test::Methods

    def app
      DigiDJ::Application
    end

    it "shows playlists" do
      get "/playlists"
      last_response.should be_ok
      last_response.body.should eq(Playlist.all_hard_coded.to_json)
    end
    
    it "shows tracks for a playlist" do
      get "/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks/new?track_id=123&dollar_amount=0.99"
      get "/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks/new?track_id=345&dollar_amount=2.00"
      get "/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks"
      last_response.should be_ok
      last_response.body.should eq('[{"track_id":"345","dollar_amount":"2.00"},{"track_id":"123","dollar_amount":"0.99"}]')
    end

    describe "POST /playlists/:playlist_id/tracks" do
      it "adds a track for a playlist" do
        get "/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks/new?track_id=123&dollar_amount=0.99"
        last_response.should be_ok
        last_response.body.should eq('{"success":1}')
      end

      it "errors out if track_id is missing" do
        get "/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks/new?dollar_amound=0.99"
        last_response.should be_ok
        last_response.body.should eq('{"error":{"message":"(#200) This API call requires a valid track_id & dollar_amount.","type":"ArgumentException"}}')
      end

      it "errors out if dollar_amount is missing" do
        get "/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks/new?track_id=123"
        last_response.should be_ok
        last_response.body.should eq('{"error":{"message":"(#200) This API call requires a valid track_id & dollar_amount.","type":"ArgumentException"}}')
      end

      it "errors out if track_id & dollar_ammount are missing" do
        get "/playlists/7Bdmon1qvlkMQjIIkMKdeC/tracks/new"
        last_response.should be_ok
        last_response.body.should eq('{"error":{"message":"(#200) This API call requires a valid track_id & dollar_amount.","type":"ArgumentException"}}')
      end
    end
  end
end
