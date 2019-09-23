import xlrd
import smtplib
from cryptography.fernet import Fernet
import os

try:
    with open("E:\\.Trashes\\hola\\key.bin", "rb") as f:
        F = Fernet(f.read())
        
        
        
    if True:
        with open("email.key", "rb") as f:
            correo = F.decrypt(f.read()).decode()
        with open("masterkey.key", "rb") as f:
            passs = F.decrypt(f.read()).decode()
        #
        #print(correo, passs)
        del passs, correo

    correo = "elvisavfc65@gmail.com"
    passs = r"6uVfVlpSV5_avfcE"

    with open("msgs.txt", "r") as f:
        msg = f.read()

    wb = xlrd.open_workbook(os.getcwd()+"\\correos.xlsx") #change it later on

    sheet = wb.sheet_by_index(0)

    from email.mime.multipart import MIMEMultipart as mimu
    from email.mime.text import MIMEText as mimtxt
    from email.header import Header
    from email import encoders

    msg = mimtxt("Buenas Noches!", "plain", "utf-8")
    msg['From'] = "Team Mathura"
    msg['To'] = "Voluntariado"
    msg['Subject'] = Header('Favor confirmar participacion MATHURA', 'utf-8').encode()
    
    s = smtplib.SMTP_SSL(host = "smtp.gmail.com", port = 587)
    s.ehlo()
    s.starttls()
    s.ehlo()

    s.login(correo, passs)
    s.sendmail(correo, "elvisavfc65@gmail.com", msg.as_string())
    s.quit()
except FileNotFoundError as e:
    print("Hubo un error con el archivo decodificador")
'''
if __name__ == "__main__":
    main()
'''
