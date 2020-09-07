import requests
import requestAccessToken as rq
import CleanRecords as CR

print("lol")

url = 'https://www.contrataciones.gov.py/datos/api/v3/doc'
RT = 'ZTNmNDMwZjktNWQyNi00MmY4LThjYWMtODJiNWZhZjliYmI4OmFiMGI3NGE1LTEzOTQtNGUzZi04MDlhLThjNTczMDhiZTRiZA=='



urlsearch = '/search/processes?{}={}' #search for proccesses.




#Dict data type to save all filters
filters = { 0: {'ID':'fecha_desde',           'value': '2020-03-01'}, #format aaaa-mm-dd
            1: {'ID':'fecha_hasta',           'value': '2020-12-31'},
            2: {'ID':'parties.identifier.id', 'value': 306},
            3: {'ID':'items_per_page',        'value': 1000},
            4: {'ID':'page',                  'value': 1},
            5: {'ID':'tender.statusDetails',  'value': 'Adjudicada'},
            6: {'ID':'tipo_fecha',            'value':'firma_contrato'}
           }

#Format the url
urlsearch = urlsearch.format(filters[0]['ID'], filters[0]['value'])
for i in range(1, len(filters)):
    urlsearch = urlsearch + '&{}={}'
    urlsearch = urlsearch.format(filters[i]['ID'], filters[i]['value'])
    


#Access token
acc = rq.reqAccess(url, RT)

#Header
headers = {'accept':'application/json',
            'Authorization':acc}

#Get request
records = requests.get(url + urlsearch, headers = headers)
res = records.json()
