import csv
import sqlite3
conn = sqlite3.connect('app.db')
c = conn.cursor()
##c.execute("""CREATE TABLE app (
##             id integer,
##             verb text,
##             answer text,
##             example text,
##             record text,
##             tier integer,
##             coefficient integer) """)
##with open('data.csv', 'r') as app:
##    csv_reader = csv.DictReader(app)
##    c2 = 1
##    for line in csv_reader:
##        with conn:
##            c.execute("""INSERT INTO app (id, verb, answer, example, record, tier, coefficient) VALUES (:id, :verb, :answer, :example, :record,
##                         :tier, :coefficient)""",
##                         {'id':c2,'verb':line['verb'], 'answer':line['answer'], 'example':line['example'],'record':'000000','tier':1,'coefficient':0})
##            c2 = c2 + 1
##            conn.commit()

c.execute("""SELECT count(id) FROM app""")
for i in range(10):
    print(c.fetchone())

conn.close()
