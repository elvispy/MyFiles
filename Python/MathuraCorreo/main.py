import xlrd
import smtplib
from cryptography.fernet import Fernet
import os
try:
    with open("E:\\.Trashes\\hola\\key.bin", "rb") as f:
        F = Fernet(f.read())
        
        '''
        s = smtplib.SMTP(host = "smtp.gmail.com", port = 587)
        s.ehlo()
        s.starttls()
        s.ehlo()
        '''
        
    if True:
        with open("email.key", "rb") as f:
            correo = F.decrypt(f.read()).decode()
        with open("masterkey.key", "rb") as f:
            passs = F.decrypt(f.read()).decode()
        #s.login(correo, passs)
        #print(correo, passs)
        del passs, correo

    from email.mime.multipart import MIMEMultipart as mimu
    from email.mime.text import MIMEText as mimtxt

    with open("msgs.txt", "r") as f:
        msg = f.read()

    wb = xlrd.open_workbook(os.getcwd()+"\\correos.xlsx") #change it later on

    sheet = wb.sheet_by_index(0)
except FileNotFoundError as e:
    print("Hubo un error con el archivo decodificador")


