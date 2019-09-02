import scrap

import xlstodrive

import formatt

year = 2019

municipio = 'Hernandarias'

def main():

    datos = scrap.main(municipio, year)

    datos = formatt.main(datos)
    
    xlstodrive.main(datos)

if __name__ == '__main__':

    main()
