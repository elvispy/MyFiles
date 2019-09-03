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

def overwrite(w_sheet, r_sheet, contratos):
    '''This function will overwrite the columns that are already in the excel file'''

    copy_contratos = contratos

    for contrato in copy_contratos:
        if contrato['nro_contrato'] in [cell.value for cell in r_sheet.row(0)]:
            row = [cell.value for cell in r_sheet.row(0)].index(contrato['nro_contrato'])

            for i in list(encabezado.keys()):
                w_sheet.write(row, i, contrato[encabezado[i]])

            copy_contratos.remove(contrato)

    return copy_contratos

def writehere(w_sheet, contratos, n):
    if len(contratos) == 0:
        return None
    for contrato in contratos:
        for i in list(encabezado.keys()):
            w_sheet.write(n, i, contrato[encabezado[i]])

        n+=1
    
    
        
def find_min(sheet, m):
    '''This function will try to find the earliest place in the sheet to write the data'''
    if m == 0:
        #if nothing to add
        return None
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

    return n


    

    


def main(contratos = []):

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

    file.GetContentFile(xlsxData['title'])
    print(xlsxData['title'])

    #Open the file on both reading and writing mode
    book = xlrd.open_workbook(xlsxData['title'])
    r_sheet = book.sheet_by_index(0)

    
    
    #Copy the book in writing mode
    wb = copy(book)
    w_sheet = wb.get_sheet(0)
    
  
    #Update the data
    remaining_contratos = overwrite(w_sheet, r_sheet, contratos)

    #See how much space do we need to store the data:
    n = find_min(r_sheet, len(remaining_contratos))

    #Write the remaining contratos
    writehere(w_sheet, remaining_contratos, n)

    #Update the file
    wb.save(xlsxData['title'])


    #file.SetContentFile(xlsxData['title'] + ".xlsx")
    #file.Upload()
    #return sheet

    
if __name__ == '__main__':

    pass
