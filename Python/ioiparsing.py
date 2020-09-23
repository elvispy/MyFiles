import requests
import os
from bs4 import BeautifulSoup
from tkinter import Tk
from tkinter.filedialog import askdirectory
import urllib.request as obtener
from tkinter import messagebox


source = requests.get('https://ioinformatics.org/page/contests/10').text

soup = BeautifulSoup(source, 'lxml')

'''
with open('htmlfile.html', 'w') as file:
    file.write(str(soup.prettify()))
'''

link = soup.find('tbody')#, class_ = 'table-responsive')

links = link.find_all('a')

links = ['https://ioinformatics.org' + var['href'] for var in links]

win = Tk()

win.withdraw()

Msgbox = messagebox.askquestion('Elija una opcion',
                                'Desea descargar los archivos adicionales? (Las soluciones pesan 1GB)')

path = askdirectory(title = 'Select where to download the files')
try:
    new_path = path + '\\IOIExamenes'
    os.chdir(path)

    os.makedirs('IOIExamenes')
    
    os.chdir(new_path)
    
    for url in links:
        
        source = requests.get(url).text

        soup = BeautifulSoup(source, 'lxml')

        year = soup.find('h2').text


        archives = soup.find('div', class_ = 'page-post')

        

        #print(archives.prettify())

        archives = archives.find_all('a')

        archiveurl = ['https://ioinformatics.org' + pdf['href'] for pdf in archives]

        names = [name.text + url[-4:] for name, url in zip(archives, archiveurl)]

        os.chdir(new_path)
        
        os.makedirs(year)
        
        os.chdir('.\\' + year)

        print('Espere... descargando el año {}'.format(year))
        for urls, name in zip(archiveurl, names):
            if Msgbox == 'yes':
                obtener.urlretrieve(urls, str(name))
            else:
                if urls[-4:] == '.pdf':
                    obtener.urlretrieve(urls, str(name))
                    
        print('Descarga del año {} completa.'.format(year))
except Exception as lolazo:

    messagebox.showerror("Ha ocurrido un error",
                                 "Escoja un directorio valido")
    print(lolazo)
else:
    messagebox.showinfo('Info', 'Descarga completada')
win.destroy()
#print(link)


