
import os
import smtplib
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from time import sleep


scope = ["https://spreadsheets.google.com/feeds",
         'https://www.googleapis.com/auth/spreadsheets',
         "https://www.googleapis.com/auth/drive.file",
         "https://www.googleapis.com/auth/drive"]

creds = ServiceAccountCredentials.from_json_keyfile_name("Rmaps-9d0ceb5975c7.json", scope)


client = gspread.authorize(creds)

sheet = client.open("Distribucion de clases Mathura 2020").worksheets()

alumnitos = {}
for ss in sheet:
    alumnitos[ss.title] = ss.col_values(2)

#alumnitos = {"Sala Olimpia Campeon":["luisfervillaalta@gmail.com",
#                             "elvisavfc65@gmail.com"]}

#alumnitos = {"Prueba": "elvisavfc65@gmail.com"}                            



correo = "mathura3.py@gmail.com"

passs = "mathurax100pre"

#authentification steps
s = smtplib.SMTP(host = "smtp.gmail.com", port = 587)
s.ehlo()
s.starttls()
s.ehlo()
s.login(correo, passs)




for sala in alumnitos.keys():
    senders = alumnitos[sala]

    try:
        from email.mime.multipart import MIMEMultipart as mimu
        from email.mime.text import MIMEText as mimtxt
        from email.mime.base import MIMEBase as mimbase
        from email.header import Header
        from email import encoders

        msg = mimu()
        msg['From'] = "Team Mathura"
        #msg['To'] = "Voluntariado"
        msg['Subject'] = 'Mathura Edicion 2020'

        with open("msgs2020.html") as f:
            body = f.read()

        
        body = body.format(sala)
        teext = mimtxt(body, 'html', 'utf-8')

        msg.attach(teext)


        s.sendmail(correo, senders, msg.as_string())

        sleep(2)
        #here the email has been already sent

    except:
        print("Hubo un error")

s.quit()


del passs, correo, s
'''
if __name__ == "__main__":
    main()
'''
