import json

people_string = '''
{
    "people": [
      {
        "name": "John Smith",
        "phone": "615-555-7164",
        "emails": ["example@gmail.com", "elvis@hotmail.com"],
        "has_license": false
      },
      {
        "name": "Jane Doe",
        "phone": "5605555153",
        "emails": null,
        "has_license": true
      }
    ]
}

'''

data = json.loads(people_string) #this will load the json file as a dictionary

print(data)

for person in data['people']:
    print(person['name'])
    del person['phone']

new_string = json.dumps(data, indent = 2,
                        sort_keys = True) #this will save the file into
#a json object

print(new_string)
