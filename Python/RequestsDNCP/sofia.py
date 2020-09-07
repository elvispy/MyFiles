from CleanRecordsSofia import *



if __name__ == '__main__':

    #First CDE Mun
    sofia = True
    irene = False
    print("------------------")
    print("LETS BEGIN WITH CDE")
    
    code = 'DNCP-SICP-CODE-196'
    ddate = '2020-03-01'
    
    CDEadj = filter_MS_tenders(path, code)
    
    print("Finished with tenders")
    
    [CDEadj, CDE_cont] = list_MS_contracts(path, CDEadj, ddate)

    print("Lets begin with the items")

    CDE_items = list_MS_items(path, CDE_cont)

    print("Now I rename and set everything")

    

    #Second Franco Mun
    print("------------------")
    print("LETS BEGIN WITH FRANCO")
    code = 'DNCP-SICP-CODE-44'
    ddate = '2020-03-01'
    
    FRadj = filter_MS_tenders(path, code)
    
    print("Finished with tenders")
    
    [FRadj, FR_cont] = list_MS_contracts(path, FRadj, ddate)

    print("Lets begin with the items")

    FR_items = list_MS_items(path, FR_cont)

    

    #Third Hernandarias Mun
    print("------------------")
    print("LETS BEGIN WITH HERNANDARIAS")    
    code = 'DNCP-SICP-CODE-199'
    ddate = '2020-03-01'
    
    HERadj = filter_MS_tenders(path, code)
    
    print("Finished with tenders")
    
    [HERadj, HER_cont] = list_MS_contracts(path, HERadj, ddate)

    print("Lets begin with the items")

    HER_items = list_MS_items(path, HER_cont)

    #Fourth Minga Mun
    print("------------------")
    print("LETS BEGIN WITH MINGA")
    code = 'DNCP-SICP-CODE-233'
    ddate = '2020-03-01'
    
    MINadj = filter_MS_tenders(path, code)
    
    print("Finished with tenders")
    
    [MINadj, MIN_cont] = list_MS_contracts(path, MINadj, ddate)

    print("Lets begin with the items")

    MIN_items = list_MS_items(path, MIN_cont)




    adj_frames = [CDEadj, FRadj, HERadj, MINadj]
    MSadj = pd.concat(adj_frames, ignore_index = True)

    cont_frames = [CDE_cont, FR_cont, HER_cont, MIN_cont]
    MS_cont = pd.concat(cont_frames, ignore_index = True)

    it_frames = [CDE_items, FR_items, HER_items, MIN_items]
    MS_items = pd.concat(it_frames, ignore_index = True)


    name = 'SOSResearch'    
    rename_final(MSadj, MS_cont, MS_items, name)
    
