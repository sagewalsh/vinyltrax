import spotipy
import discogs_client
from spotipy.oauth2 import SpotifyClientCredentials

#authentication for discogs
d = discogs_client.Client('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36',
                          user_token='mprTxFYYqnLRMbqzCcsfQTgyACNYbqtxXtNWRKRq')

#authentication for spotify
sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id="205c62460a52498d96b6ee29fb16c93b",
                                                           client_secret="2b330e386eb348ba984e4a956657cd75"))

def scanBarcode(num):
    results = d.search(barcode=num)
    album = results[0]
    for artist in album.artists:
        print("Artist: " + artist.name)
    print("Album: " + album.title)
    print()
    for x in album.tracklist:
       print(x.position + " " + x.title)
    print(album.images[0])

def spotifyTest():
    results = sp.search(q='Graduation', limit=20, type='album')
    print(results)

#spotifyTest()
scanBarcode(602517412200)