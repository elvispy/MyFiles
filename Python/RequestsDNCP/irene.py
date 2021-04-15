from CleanRecordsIrene import *

if __name__ == '__main__':
    irene = True
    code = 'DNCP-SICP-CODE-306'
    name = 'MSBPS'
    MSadj = filter_MS_tenders(path, code)
    
    ddate = '2013-08-15'
    
    print("Finished with tenders")
    
    [MSadj, MS_cont] = list_MS_contracts(path, MSadj, ddate)

    print("Lets begin with the items")
    
    MS_items = list_MS_items(path, MS_cont)
    
    
    print("Now I rename and set everything")

    renamed = rename_final(MSadj, MS_cont, MS_items, name)
    
