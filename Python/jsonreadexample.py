import json

with open('states.json') as f:
    
    data = json.load(f) #to read


for state in data['states']:
    print(state)
    break

with open('new_states.json', 'w') as f:
    json.dump(data, f, indent = 2) #to write


#obs: json.load to load json files and json.loads to read strings in json
#format. Same with dump and dumps
