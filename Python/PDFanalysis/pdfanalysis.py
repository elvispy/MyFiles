import os
import csv

import PyPDF2
import gender_guesser.detector as gender
d = gender.Detector(case_sensitive = False)

forb = ['Nº', 'NOMBRES Y APELLIDOS', 'INSTITUCIÓN', 'NIVEL',
        'DPTO', 'CIUDAD', 'DISTINCIÓN', 'MEDALLERO NACIONAL 2.019',
        'OLIMPIADA NACIONAL JUVENIL DE MATEMÁTICA', '']

pdffile = open(os.getcwd() + "\\MEDALLERO 2019.pdf", "rb")

pdfObject = PyPDF2.PdfFileReader(pdffile)

alumnos = []
i = 0
while True:
    try:
        pdfPage = pdfObject.getPage(i).extractText()

    except Exception as e:
        print(e)
        break
    
    pdfPage = pdfPage.split("\n")
    for lol in forb:
        pdfPage.remove(lol)

    if len(pdfPage)%7 != 0:
        raise Exception

    aux = int(len(pdfPage)/7)
    for i2 in range(aux):
        index = 7 * i2
        if pdfPage[index + 2].lower() == "alumna independiente":
            pdfPage[index + 2] = "Alumno Independiente"
        sex = d.get_gender(pdfPage[index + 1].split(" ", maxsplit = 1)[0])
        sex = "F" if sex == "female" else "M"
        alumnos.append([pdfPage[index + 1],
                        sex,
                        pdfPage[index + 2],
                        pdfPage[index + 4],
                        pdfPage[index + 6]])
        


    i = i+1    


with open('medallas.csv', 'w') as ncsv:
    csv_file = csv.writer(ncsv)
    csv_file.writerow(['ALUMNO', 'SEXO', 'INSTITUCION', 'DEPARTAMENTO', 'MEDALLA'])
    
    for alumno in alumnos:
        csv_file.writerow(alumno)
