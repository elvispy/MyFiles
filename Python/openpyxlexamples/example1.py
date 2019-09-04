import openpyxl

wb = openpyxl.load_workbook('AIGA_Resumen Contratos FONACIDE (Hernandarias)_Planilla_20190831.xlsx')

print(wb.sheetnames)

sheet = wb['SoloContratos']

print(sheet['A1'].value)#will print the value of the cell

sheet['B3'].value = 'lol'

wb.save('name.xlsx')

def lol():

    print(n)

def hola():
    n =1
    lol()
