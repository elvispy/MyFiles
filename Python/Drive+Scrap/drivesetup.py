from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
import os

#Steps to do the login, and authentification.

g_login = GoogleAuth()
g_login('mycreds.txt')
g_login.Authorize()
drive = GoogleDrive(g_login)
#See https://medium.com/@annissouames99/how-to-upload-files-automatically-to-drive-with-python-ee19bb13dda
#For more information

mefin_id = '1EvJjxH9j-efk8MpS1Nfa5O6hP4IVaSwy' #this is the id of the folder

folders = ['1GPJwZsigvVV1rMuKWohFrXN8sgzDykIP',#2019
           '1nOiDDtSTXpvXfVFIIWjosnfEzLBhGExh',#2018
           '1aq4CglVACVgU67pAY1q31F9NWFLQzxxp',#2017
           '1uynLY219y3Zj9BY1Q3pYLJWGBfjcdXgx',#2016
           '1EQHzifuBGjH4hIkDwApiOm7vAGaB1OPb',#2015
           '11k3wyoWUn19kKsF4HjTvY1klpBFoDNTH']#2014

ttm_id = '0B2nk5yneb6l3X2R6TGU1cHBzOUk' #id para pruebas, to the moon

id2 = '18l4f5DNXMhHBuHKiIsUaC04Vevrg8CC1' #id de ttm\Setup\2

set1 = drive.CreateFile({'title':'Este es un folder de prueba',
                         "parents":[{"id":id2}],
                         "mimeType" : "application/vnd.google-apps.folder"})
#this will create a folder called Este es un folder de prueba


#to list all elements in a folder
list2 = drive.ListFile({'q':"'%s' in parents and trashed=false" % id2}).GetList()

#if you want to download an element, you must declate that as a file.
a = list2[0] #first element of the list
file = drive.CreateFile({'id':a['id']})
file.GetContentFile('prueba.xlsx') #name of the file, will download in os.getcwd()

file.SetContentFile('123.xlsx') #Will overwrite the content
file.Upload() #will update the content of the file
    
