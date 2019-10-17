import csv #this is the library we will use

with open('SacramentocrimeJanuary2006.csv', 'r') as csv_file:
    #you always need to specify the delimiter!
    csv_reader= csv.reader(csv_file, delimiter = ',') #this opens a csv reader object

    with open('new_csv.csv', 'w') as new_file:
        csv_file = csv.writer(new_file, delimiter = '\t')
        for line in csv_reader:
            print(line)
            print(type(line))
            csv_file.writerow(line[:3] + line[4:])

#The last one was the normal reader
'''
with open('SacramentocrimeJanuary2006.csv', 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    
    with open('dictcsv.csv', 'w') as new_file:
        
        fieldnames = ['cdatetime', 'address', 'district', 'beat',
                      'grid', 'crimedescr', 'ucr_ncic_code', 'latitude', 'longitude']
        csv_writer = csv.DictWriter(new_file, fieldnames = fieldnames, delimiter = ',')
## the above is only if the file were to be open in write mode
        csv_writer.writeheader()
    
        for line in csv_reader:
            csv_writer.writerow(line)
            print(line)
'''
