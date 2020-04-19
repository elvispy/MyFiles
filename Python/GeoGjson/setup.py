from io import BytesIO
import os
import pandas as pd
import json

from functions2 import *

import requests

def google_sheets_to_df(key):
    """To open a spreadsheet given its key"""
    r = requests.get(f'https://docs.google.com/spreadsheet/ccc?key={key}&output=csv')
    return pd.read_csv(BytesIO(r.content))

#Importing all four spreadsheets
techo_df = google_sheets_to_df("11jSqn_p_uXK3xHntUmjws_Eaka1ei3CNyhZ9VRpKJ-w")
tekopora_df = google_sheets_to_df("1C4YS7tiQxAZ8vH4A46HpSc03xR0PVRA74itIcUdjYjQ")
fundacion_df = google_sheets_to_df("1TnF5CaBj8EQLa8JbNMVnxYMP6W2YGG56mVDg6PeabLo")
almuerzo_df = google_sheets_to_df("18NgsyLY-BVR9lQ48oDs-2tf3QeQYxSGF0ywf1aW661c")
try:
    with open("paraguay_2012_barrrios_y_localidades.geojson", mode = "r", encoding = "utf8") as f:
        shape = json.load(f)
        feature_dict = {f["properties"]["objectid"]:f for f in shape["features"] if f["properties"]["dpto"] == "10" } #ALTO PARANA
    features = add_properties_tekopora(feature_dict, tekopora_df)
    features = add_properties_techo(features, techo_df)
    features = add_properties_fundacion(features, fundacion_df)
    features = add_properties_almuerzo(features, almuerzo_df)
    
    shape["features"] = features

    #Now we store the results in a new geoJson
    with open("alto_parana_2012_barrrios_y_localidades.geojson", mode = "w", encoding = "utf8") as out:
        json.dump(shape, out)
    os.replace("alto_parana_2012_barrrios_y_localidades.geojson", "D:\\GITRepos\\priorizador-develop\\public\\alto_parana_2012_barrrios_y_localidades.geojson")
except FileNotFoundError:
    print("Archivo no encontrado")