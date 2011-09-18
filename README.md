digidj.us
=========

Setup
-----

* Check out [How to Build a Website](http://www.mattdipasquale.com/blog/2011/07/02/how-to-build-a-website/) for instructions on how install Homebrew, RVM, & Sinatra.

* Install [libspotify](http://developer.spotify.com/en/libspotify/overview/).

    brew install libspotify

* 

Get the spotify server. Our Sinatra app (coming soon) will make
REST requests to this server.

Put these files (attached) in the same folder.

Install libspotify:
http://developer.spotify.com/en/libspotify/overview/
On Mac it's just brew install libspotify

Install the python bindings for it:
git clone https://github.com/mopidy/pyspotify
cd pyspotify
python setup.py build
sudo python setup.py install

Run the server:
chmod 700 hackathon.py
./hackathon.py -u brianyang -p REDACTED

To Kill:
ps -a
kill PID # where PID is the one that looks like:
31569 ttys009    0:01.63 python ./hackathon.py -u brianyang -p REDACTED 

To Test:
List tracks on playlist:
curl http://localhost:8081/list/spotify:user:brianyang:playlist:7Bdmon1qvlkMQjIIkMKdeC

Optional: To view the tracks updating in the Spotify Mac app, log in
with username: brianyang password: REDACTED and click on General
Assembly playlist

Add track to playlist:
curl http://localhost:8081/add/spotify:user:brianyang:playlist:7Bdmon1qvlkMQjIIkMKdeC/spotify:track:6ux0YZaTijSxfNLgmL27rV/2
# 2 is the position

Delete track from playlist:
curl http://localhost:8081/delete/spotify:user:brianyang:playlist:7Bdmon1qvlkMQjIIkMKdeC/spotify:track:6ux0YZaTijSxfNLgmL27rV

