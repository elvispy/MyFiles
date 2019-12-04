import spotipy
import spotipy.util as util
from spotipy.oauth2 import SpotifyClientCredentials
client_id = "e73f1a9b161b44e1aebc1a4a78601694"
client_secret = "ce5e021c520340e5910d3956c6659bfa"

client_credentials_manager = SpotifyClientCredentials(client_id = client_id, client_secret = client_secret)

sp = spotipy.Spotify(client_credentials_manager = client_credentials_manager)

results = sp.search(q = 'artist:' + 'Muse', type = 'artist')
print(results)

