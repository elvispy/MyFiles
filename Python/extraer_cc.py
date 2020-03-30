#This function recieves as arguments:
#path= string containin the path of the central folder
#datos, is a dictionary contaning AT LEAST the contract number, licitacion id and provider name.

#This function will return
#error, a boolean that states if the reading of the PDF wasn't succesful.
#monto_fonacide, a string that is equal to the fonacide's contribution to the contract.

def main(path, datos):
    import PyPDF2
    error = False
    monto_fonacide = "-1"
    nomenclatura = "{nro} {id_c} {name}".format(
        nro = datos['nro_contrato'].replace("/", "-"),
        id_c = datos['id_licitacion'],
        name = datos['nombre_empresa']
        )
    try:
        pdfFile = open(path + "\\" + nomenclatura + "\\Codigo de Contratacion.pdf", 'rb')

        pdfObject = PyPDF2.PdfFileReader(pdfFile)

        pdfPage = pdfObject.getPage(0)

        monto_fonacide = pdfPage.extractText().split("TOTAL:")[1]
        
        if pdfPage.extractText().split("TOTAL:")[0][-len(monto_fonacide):] != monto_fonacide:
            print("Warning: Check Possible Error in Monto Fonacide (PDF) didn't match")
            print(datos['id_licitacion'])
            print(datos['nro_contrato'])
            print("--------------------")
            monto_fonacide = '-1'
        elif pdfPage.extractText().split("TOTAL:")[0][-len(monto_fonacide)-3] != '3':
            monto_fonacide = '0'
    except:

        error = True

    return [error, monto_fonacide]

if __name__ == '__main__':
    main()
