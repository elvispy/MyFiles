import json

def main(data):

    data = {dato['nro_contrato']:dato for dato in data}


    try:
        with open("data.json") as f:
            already_charged = json.load(f)
        
        data.update(already_charged)
    except:
        print("Just in case")

    with open("data.json", "w") as json_file:
        
        json.dump(data, json_file, indent = 4, sort_keys = True)


