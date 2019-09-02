from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
'''This scripts generates the credentials for the project'''
gauth = GoogleAuth()

#tries to open credentials
gauth.LoadCredentialsFile("mycreds.txt")

if gauth.credentials is None:
    #if no credentials, manually charges
    gauth.LocalWebserverAuth()

elif gauth.access_token_expired:
    
    gauth.Refresh()
else:
    #is credentials are ok, authorize.
    gauth.Authorize()


gauth.SaveCredentialsFile("mycreds.txt")
