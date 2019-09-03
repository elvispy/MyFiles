import scrap

import xlstodrive

import formatt

import savetojson

year = 2018

municipio = 'Hernandarias'

def main():

    #The check if there is an error here first (It's likely that that's the case)
    xlstodrive.checkcredentials()

    datos = scrap.main(municipio, year)

    savetojson.main(datos)
    
    xlstodrive.main(datos, year)

if __name__ == '__main__':

    main()
