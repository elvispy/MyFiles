import xlrd
import smtplib
from cryptography.fernet import Fernet
import os

senders = []
wb = xlrd.open_workbook(os.getcwd()+"\\correos brofes.xlsx") #change it later on

sheet = wb.sheet_by_index(0)

for i in range(sheet.nrows):
    senders.append(sheet.cell(i, 0).value)

try:

    from email.mime.multipart import MIMEMultipart as mimu
    from email.mime.text import MIMEText as mimtxt
    from email.mime.base import MIMEBase as mimbase
    from email.header import Header
    from email import encoders

    msg = mimu()
    msg['From'] = "Team Mathura"
    #msg['To'] = "Voluntariado"
    msg['Subject'] = 'Favor confirmar participacion MATHURA'
    with open('attatch.jpeg', 'rb') as f:
        base = mimbase('image', 'jpeg', filename = 'attatch.jpeg')
        base.add_header('Content-Dispotition', 'attatchment', filename = 'attatch.jpeg')
        base.add_header('X-Attachment-Id', '0')
        base.add_header('Content-ID', '<0>')
        base.set_payload(f.read())
        encoders.encode_base64(base)
        msg.attach(base)
        
    teext = mimtxt('<html><body><h1>¡Hola Voluntarios!</h1>' +
    '<p><img src="cid:0" style="width:550px;height:600px;"></p>' +
    '</body></html>', 'html', 'utf-8')

    msg.attach(teext)
    
    s = smtplib.SMTP(host = "smtp.gmail.com", port = 587)
    s.ehlo()
    s.starttls()
    s.ehlo()

    with open("E:\\.Trashes\\hola\\key.bin", "rb") as f:
        F = Fernet(f.read())
        
        
        
    if True:
        with open("email.key", "rb") as f:
            correo = F.decrypt(f.read()).decode()
        with open("masterkey.key", "rb") as f:
            passs = F.decrypt(f.read()).decode()
 
    s.login(correo, passs)
    s.sendmail(correo, senders, msg.as_string())
    s.quit()
    del passs, correo, s
    
    
except FileNotFoundError as e:
    print("Hubo un error con el archivo decodificador")
'''
if __name__ == "__main__":
    main()
'''
