import os

import json

from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

import xlwt
import xlrd
from xlutils.copy import copy
import glob
import datetime

encabezado = {
    0 :'id_licitacion',
    1 :'nro_contrato',
    2 :'fecha_firma',
    3 :'nombre_empresa',
    4 :'nombre_licitacion',
    5 :'monto_adjudicado',
    8 :'periodo',
    9 :'plurianual',
    10:'categoria'
    }

def overwrite(w_sheet, r_sheet, contratos):
    '''This function will overwrite the columns that
    are already in the excel file
    '''

    copy_contratos = contratos

    for contrato in copy_contratos:
        if contrato['nro_contrato'] in [cell.value for cell in r_sheet.col(1)]:
            row = [cell.value for cell in r_sheet.col(1)].index(contrato['nro_contrato'])

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
    error = False
    while True:
        #print(n)
        try:
            condition = all([not bool(sheet.cell(i,0).value) for i in range(n, m+n)])

        except:
            #print("inside")
            #print(n)
            #print("------")
            error = True
            break
        n += 1
        
    #print("New!")
    if error:
        n = m+n-2

        while not bool(sheet.cell(n,0).value):
            n -=1
        n += 1
        
    return n


def checkcredentials():
    #Check credentials. If an error is raised, run gencredentials.py
    try:
        gauth = GoogleAuth()
        gauth.LoadCredentialsFile('mycreds.txt')
        gauth.Authorize()
        
    except Exception as e:
        
        import credentialsgen
        
    finally:
        drive = GoogleDrive(gauth)
        
    return drive

def format_headers(w_sheet, r_sheet):
    #Set the cell style
    style = xlwt.easyxf('pattern: pattern solid, fore_color light_blue;\
                    font: color white, name Arial, height 210, bold 1;\
                    align: wrap on,vert centre, horiz center;')

    # Copying format to Headers
    for i, cell in enumerate(r_sheet.row(0)):
        w_sheet.write(0, i, cell.value, style)
        
    
    
    


def main(contratos = [], year = datetime.datetime.now().year):

    drive = checkcredentials()
    

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

    #Format the Headers
    format_headers(w_sheet, r_sheet)

    #Update the file
    wb.save(xlsxData['title'][:-1])

    #Upload to Drive
    #file.SetContentFile(xlsxData['title'][:-2])
    #file.Upload()
    

    #Now Upload The Append Files, if neccesary
    
    contratos_id = '14Ab05yUVz0-VH8vU83G0cIVfIgsgvUSa'
    years_id = {2014: '11k3wyoWUn19kKsF4HjTvY1klpBFoDNTH',
                2019: '1GPJwZsigvVV1rMuKWohFrXN8sgzDykIP',
                2018: '1nOiDDtSTXpvXfVFIIWjosnfEzLBhGExh',
                2017: '1aq4CglVACVgU67pAY1q31F9NWFLQzxxp',
                2016: '1uynLY219y3Zj9BY1Q3pYLJWGBfjcdXgx',
                2015: '1EQHzifuBGjH4hIkDwApiOm7vAGaB1OPb'}

    year_id = years_id[year]

    
    if os.path.isdir("./"+str(year)):
        os.chdir("./"+str(year))

    #List all folders inside the year
    drive_folders = drive.ListFile({'q':"'{}' in parents and trashed=false".format(year_id)}).GetList()

    #List all remote folders
    name_folders = [fold['title'] for fold in drive_folders]
    #Splitting the characteristics of the folders
    name_folders_spplited = [fold.split(" ") for fold in name_folders]
    name_folders_id = [fold['id'] for fold in drive_folders]

    #List all local folders
    local_folders = os.listdir()
    #Fixing Windows protocol
    local_folders = [fold.replace("-", "/") for fold in local_folders]

    cwd = os.getcwd()
    #Try to match local and
    for folder in local_folders:
        #Reset Current Working directory
        os.chdir(cwd)
        #This variable will check whether the folder was found on the could or not
        found = False
        #Getting the characteristics of both folders, to compare them
        char_local = folder.split(" ")

        #Try to find corresponding folder in drive
        for chars in name_folders_spplited:
            if chars[0] == char_local[0] and chars[1] == char_local[1]:
                
                #Store matching id of the drive folder
                match_id = name_folders_id[name_folders_spplited.index(chars)]
                '''
                Debugging
                print(name_folders_id)
                print(name_folders_spplited)
                print(match_id)
                print(chars)
                print(char_local)
                '''
                #Delete already charged values for optimization (could be discarded
                name_folders_spplited.remove(chars)
                name_folders_id.remove(match_id)
                found = True
                break
        print(match_id)
        #If not found, create a folder
        if not found:
            new_folder = drive.CreateFile({'title':folder,
                                           'parents':[{'id':year_id}],
                                           'mimeType': 'application/vnd.google-apps.folder'})
            new_folder.Upload()
            
            match_id = new_folder['id']
            
        #Enter to the folder and update the files if they are not in drive
        os.chdir("./"+folder.replace("/", "-"))

        #List year folder's elements
        year_folder = drive.ListFile({'q':"'{}' in parents and trashed=false".format(match_id)}).GetList()

        elements = [element['title'].lower() for element in year_folder]

        #elements_id = [element['id'] for element in year_folder]

        #Is codigo de contratacion in the folder?
        is_cc = False
        for  title in elements:
            if "codigo" in title:
                is_cc = True
        #If not, upload it
        if not is_cc:
            file = drive.CreateFile({'title':'Codigo de Contratacion',
                                    'parents':[{'id':match_id}],
                                    'mimeType':'application/pdf'})

            file.SetContentFile("Codigo de Contratacion.pdf")
            file.Upload()

        #Is the contract in the folder?
        is_con = False
        for  title in elements:
            if "contrato" in title:
                is_con = True

        #If not, upload it
        if not is_con:
            
            contract = os.listdir()
            contract = [pdf for pdf in contract if "contrato" in pdf.lower()][0]

            file = drive.CreateFile({'title':contract[:-4],
                                    'parents':[{'id':match_id}],
                                    'mimeType':'application/pdf'})
            file.SetContentFile(contract)
            file.Upload()

    #Now let's send the file to the cloud
    excel_fold_id = '0B2nk5yneb6l3X2R6TGU1cHBzOUk' #To the moon folder for now

    


    
if __name__ == '__main__':

    pass
