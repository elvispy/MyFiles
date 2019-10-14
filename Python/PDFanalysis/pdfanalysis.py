import PyPDF2

import os

pdffile = open(os.getcwd() + "\\MEDALLERO 2019.pdf", "rb")

pdfObject = PyPDF2.PdfFileReader(pdffile)

pdfPage = pdfObject.getPage(0)

noerror = True
i = 0
while noerror:
    pdfPage = pdfObject.getpage(i).extractText()
