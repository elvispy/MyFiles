'''
This script looks for the folder id's
to be used
'''
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

def main():
    
    g_login = GoogleAuth()
    g_login.LoadCredentialsFile('mycreds.txt')
    g_login.Authorize()
    drive = GoogleDrive(g_login)

    folders = drive.ListFile({'q':"sharedWithMe"}).GetList()
    mefin = [a for a in folders if a['title'] == 'MEFIN'][0] #MEFIN folder

    folders = drive.ListFile({'q':"'%s' in parents and trashed=false"%
                              mefin['id']}).GetList() #folders inside MEFIN

    hern = [a for a in folders if a['title'] == 'Hernandarias'][0]

    folders = drive.ListFile({'q':"'%s' in parents and trashed=false"%
                              hern['id']}).GetList() #folders inside hernandarias

    cont = [a for a in folders if a['title'] == 'Contratos'][0]

    folders = drive.ListFile({'q':"'%s' in parents and trashed=false"%
                              cont['id']}).GetList() #folders inside contratos

    #now i collect the id of the dictionaries
    ids = dict(zip([a['title'] for a in folders],[a['id'] for a in folders]))
    return ids

if __name__ == '__main__':
    
    main()
    
    
