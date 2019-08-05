from __future__ import print_function
import datetime
import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import tkinter as tk
from tkinter import messagebox

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/calendar']
def next_sunday():
	'''
		This function calculates the first sunday in three months
	'''
	mes = int(datetime.datetime.now().strftime("%m"))
	year = datetime.datetime.now().strftime("%Y")
	day = int(datetime.datetime(int(year), ((mes + 2) % 12) + 1, 1).strftime('%w'))

	final_month = '0' + str(((mes + 2) % 12) + 1) if not( mes in [7, 8, 9]) else str(((mes + 2) % 12) + 1)
	final_day = '0' + str((7-day)%7 + 1)

	first_sunday = "-".join([year,final_month, final_day])

	return first_sunday

def is_sunday():
    """Checks whether today is sunday"""
    if datetime.datetime.now().strftime("%w") == '0':
        return True
    else:
        return False
    
def main():
    """Shows basic usage of the Google Calendar API.
    It'll create events to organize the bath's cleanup.
    """
    with open('bath.txt', 'r+') as days:
        
        three_days = days.readlines(25)
        bath_cleaned = three_days[2][:-1]
        lolazo = '0' + str(int(bath_cleaned[-2:])+7) if len(str(int(bath_cleaned[-2:])+7)) == 1 else str(int(bath_cleaned[-2:])+7)
        due = bath_cleaned[:-2]+str(int(bath_cleaned[-2:])+14)
        semi_due = bath_cleaned[:-2]+lolazo
        today1 = str(datetime.datetime.now().date())
        if today1 < bath_cleaned and False:
            return None
        elif today1 > due:
            
            lo_hice = True

        elif today1 in [bath_cleaned, semi_due, due] or True:
            #informar que es el dia de limpiar el baño, y preguntar si lo ha hecho
            lo_hice = False
            root = tk.Tk()
            root.withdraw()
            Msgbox = tk.messagebox.askquestion('Confirmando trabajo','Has limpiado el baño hoy?')
            if Msgbox == 'yes':
                lo_hice = True
            if lo_hice:
                days.seek(0)
                info = days.read()
                agregar = next_sunday()
                info = agregar + '\n' + info
                days.write(info)
                
                    
    if not lo_hice:
        pass
    else:
        creds = None
        # The file token.pickle stores the user's access and refresh tokens, and is
        # created automatically when the authorization flow completes for the first
        # time.
        if os.path.exists('token.pickle'):
            with open('token.pickle', 'rb') as token:
                creds = pickle.load(token)
        # If there are no (valid) credentials available, let the user log in.
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file(
                    'credentials.json', SCOPES)
                creds = flow.run_local_server()
            # Save the credentials for the next run
            with open('token.pickle', 'wb') as token:
                pickle.dump(creds, token)

        service = build('calendar', 'v3', credentials=creds)

        # Call the Calendar API
        val = datetime.datetime.strptime(agregar, "%Y-%m-%d")
        year = datetime.datetime.strftime(val, "%Y")
        month = datetime.datetime.strftime(val, "%m")
        day = datetime.datetime.strftime(val, "%d")
        start_date = datetime.datetime(int(year), int(month), int(day), 7, 0).isoformat()
        end_date = datetime.datetime(int(year), int(month), int(day), 10, 0).isoformat()
        
        event = {
      'summary': 'Dia de limpiar el baño',
      'location': 'Casa',
      'description': '---',
      'start': {
        'dateTime': start_date,
        'timeZone': 'America/Asuncion',
      },
      'end': {
        'dateTime': end_date,
        'timeZone': 'America/Asuncion',
      }}

        event = service.events().insert(calendarId='primary', body=event).execute()
        print('Event created: %s' % (event.get('htmlLink')))
##    now = datetime.datetime.utcnow().isoformat() + 'Z' # 'Z' indicates UTC time
##    print('Getting the upcoming 10 events')
##    events_result = service.events().list(calendarId='primary', timeMin=now,
##                                        maxResults=10, singleEvents=True,
##                                        orderBy='startTime').execute()
##    events = events_result.get('items', [])
##
##    if not events:
##        print('No upcoming events found.')
##    for event in events:
##        start = event['start'].get('dateTime', event['start'].get('date'))
##        print(start, event['summary'])

if __name__ == '__main__':
    main()
