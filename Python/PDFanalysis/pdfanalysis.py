import PyPDF2

import os

pdffile = open(os.getcwd() + "\\MEDALLERO 2019.pdf", "rb")

pdfObject = PyPDF2.PdfFileReader(pdffile)


count = 1
i = 0
mydict = dict()
while (count%34 and count < 371):
    try:
        pdfPage = pdfObject.getPage(i).extractText()

    except Exception as e:
        print(e)
        break
    content = [pdfPage.split("\n{}".format(count), maxsplit = 1)[-1]]
    break
    if i == 0 and count == 1:
        content = content[:-2] + content[-1].split("PLATA", maxsplit = 1)
        count + = 1
        #trabajarle al primero
    print(content)
    while True:
        count += 1
        content = content[:-2] + content[-1].split("\n{}".format(count), maxsplit = 1)
        

    i = i+1    

pdffile.close()
