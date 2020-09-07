import requests
import pathlib
import json

def reqAccess(urlbase, RT):
    '''This function returns a valid access token to ask for data to DNCP.
    Then it will store the access token in a file for later use and to save time'''
    
    file_path = pathlib.Path(__file__).parent / "access.bin"
    if pathlib.Path.exists(file_path):
        with open(file_path, "r") as f:
            acc = f.read()

        
        if acc and test_access(acc):
            return acc
        else:
            pathlib.Path.unlink(file_path)     

    payload = {'request_token':RT}

    urlauth = '/oauth/token'
    x = requests.post(urlbase + urlauth, json = payload)

    if x.ok == False:
        raise Exception("Something went wrong when trying to request Access token: {0}".format(x.reason))
    else:
        lol = x.json()
        with open(file_path, "w") as fp:
            json.dump(lol, fp, indent = 4, sort_keys = True)
        return lol['access_token']


def test_access(acc: str) -> bool:
    '''Tests whether the access token is still valid'''

    acc = 'Bearer ' + acc
    
    urlbase = 'https://www.contrataciones.gov.py/datos/api/v3/doc/contracts/LC-12006-19-170106'
    headers = {'accept':'application/json',
               'Authorization':acc}
    try:
        y = requests.get(urlbase, headers = headers)
    except Exception as e:
        print(e)
        return False

    return y.ok
