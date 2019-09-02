import os

import json

from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

import xlwt
import xlrd
from xlutils.copy import copy
import glob

encabezado = {
    0 :'id_licitacion',
    1 :'nro_contrato',
    2 :'fecha_firma',
    3 :'proveedor',
    4 :'nombre_licitacion',
    5 :'monto_adjudicado',
    8 :'periodo',
    9 :'tags',
    10:'categoria'
    }

def write(w_sheet, r_sheet, contrato, row):
    '''This function will write into the excel file, for every contract and in column col'''
    for i in list(encabezado.keys()):
        for rows in range(100):
            try:
                if r_sheet.cell(rows, 0).value == contrato['id_licitacion']:
                    row = rows
        w_sheet.write(, , contrato[encabezado[i]])
        
    
def find_min(sheet, m):
    '''This function will try to find the earliest place in the sheet to write the data'''
    if m == 0:
        m = 1
    n = -1
    condition = False
    list2 = [0]
    while not condition:
        try:
            condition = all([not bool(sheet.cell(i,0).value) for i in range(n, m+n+1)])
            a = list2[0]
        except:
            list2 = []
            n -= 1

            if bool(sheet.cell(n, 0).value):
                condition = True
                n = n+1
        else:
            n += 1
        print(n)
    return n


    

    


def main(datos = []):

    print(os.getcwd())
    #Check credentials. If an error is raised, run gencredentials
    g_login = GoogleAuth()
    g_login.LoadCredentialsFile('mycreds.txt')
    g_login.Authorize()
    drive = GoogleDrive(g_login)
    

    hern_id = '1B3-A1aznOtuSijnf-OCvZDXPKBxYEgVr' #this is the id of the folder

    #Check if there is an excel file in path destination, if so, remove it.
    if len(glob.glob(os.getcwd() + "\\Temps\\*.xlsx")) > 0:
        for file in glob.glob(os.getcwd() + "\\Temps\\*.xlsx"):
            os.remove(file)

    #Download the file
    list2 = drive.ListFile(
        {'q':"'%s' in parents and trashed=false" % hern_id}).GetList()
    xlsxData = [a for a in list2 if "Resumen Contratos" in a['title']][0]

    file = drive.CreateFile({'id':xlsxData['id']})

    os.chdir(os.getcwd() + "\\Temps")

    file.GetContentFile(xlsxData['title'] + ".xlsx")

    #Open the file on both reading and writing mode
    book = xlrd.open_workbook(xlsxData['title'] + ".xlsx")
    r_sheet = book.sheet_by_index(0)

    #Find a place to write data without overwriting
    n = find_min(r_sheet, len(datos))
    
    #Copy the book in writing mode
    wb = copy(book)
    w_sheet = wb.get_sheet(0)
    
    #Save the file
    for row, contrato in enumerate(datos, start = n):
        write(w_sheet, r_sheet, contrato, row)

    #Update the file
    wb.save(xlsxData['title'] + ".xlsx")


    #file.SetContentFile(xlsxData['title'] + ".xlsx")
    #file.Upload()
    #return sheet

    
if __name__ == '__main__':

    sheet = main()
