import pandas as pd
import pathlib
col_types = {'Fecha de firma de contrato':'str',
             'Fecha de publicación de convocatoria de licitación':'str',
             'Monto Total de contrato':'str'}
fp = pd.read_excel('AIGA.xlsx', sheet_name = 'Solo_contratos', dtype = col_types)

path = 'D:\\Documents\\LicitacionesDNCP\\{}\\{}'

def concat_csv(archive, columns = [], col_sorts = [], col_types = dict(), filters = dict()):
    ''' This function joins and filters the data over a number of years of a specific
    archive that you provide.
    cpl_sorts is the set of columns to be sorted
    col_types is a dict with name-value pairs to set the type of some columns
    columns is the set of columns that have to be returned
    filters is a set of filters for the rows, with name-value arguments'''
    frames = []
    year = 2020
    while pathlib.Path.exists(pathlib.Path(path.format(year, archive))):

        if col_types:
            fp = pd.read_csv(path.format(year, archive), encoding = 'utf-8',
                             dtype = 'str')
        else:
            fp = pd.read_csv(path.format(year, archive), encoding = 'utf-8')
        #now next year
        fp = fp.fillna("")
        year -= 1
        frames.append(fp)

    #concatenate results
    MS_res = pd.concat(frames, ignore_index = True)

    if filters:
        for f in filters.keys():
            MS_res = MS_res[MS_res[f] == filters[f]]

    #filter Columns
    if columns:
        MS_res = MS_res[columns]

    #Filter rows
    

    if col_sorts:
        MS_res = MS_res.sort_values(by = col_sorts, ignore_index = True)
    
    return MS_res

def look_awa_entity(fp, MS_cont, i, maxx):
    '''This function looks for the awarded suppliers per contract.
    It also returns the supplier's RUC. Returns an empty string if no supplier was found'''

    val = fp['ID de licitación'][i]

    idx = MS_cont['compiledRelease/id'].searchsorted(str(val))

    idx = idx if idx < maxx else 0

    for j in range(-30, 31):
        if str(val) in MS_cont['compiledRelease/id'][idx + j]:
            #print(MS_cont.loc[idx + j])
            if str(fp['Monto Total de contrato'][i]) == str(MS_cont['compiledRelease/contracts/0/value/amount'][idx + j]):
                return idx + j
                break

    #print(fp.loc[i])
    return None

def look_awa_supp(fp, MS_awa, i, maxx):
    
    val = fp['URL'][i]
    if len(str(val)) < 5:
        return None

    val = val.split("/")[-1]
    val = val.split(".")[0]

    idx = MS_awa['compiledRelease/awards/0/id'].searchsorted(val)

    idx = idx if idx < maxx else 0

    if MS_awa['compiledRelease/awards/0/id'][idx] == val:
        return [MS_awa['compiledRelease/awards/0/suppliers/0/name'][idx],
                MS_awa['compiledRelease/awards/0/suppliers/0/id'][idx]]

    return None

def look_records(fp, MSadj, i, maxx):

    val = fp['ID de licitación'][i]


    idx = MSadj['compiledRelease/planning/identifier'].searchsorted(str(val))

    idx = idx if idx < maxx else 0

    if MSadj['compiledRelease/planning/identifier'][idx] == str(val):
        return [MSadj['compiledRelease/tender/datePublished'][idx],
                MSadj['compiledRelease/tender/procurementMethodDetails'][idx],
                MSadj['compiledRelease/buyer/name'][idx]
                ]
    return None



#Now the records

archive = 'records.csv'


columns = ['compiledRelease/planning/identifier',
           'compiledRelease/buyer/name',
           'compiledRelease/tender/datePublished',
           'compiledRelease/id',
           'compiledRelease/tender/procurementMethodDetails'
           ]


records_col_types = {'compiledRelease/planning/identifier':'str'}
col_sorts = ['compiledRelease/planning/identifier']

#Concatenate recods, filter columns, sort rows, filter rows
MSadj = concat_csv(archive, columns, [], records_col_types)

#empties =  MSadj['compiledRelease/planning/identifier'].isna()
#MSadj['compiledRelease/planning/identifier'] = MSadj['compiledRelease/planning/identifier'].fillna(MSadj['compiledRelease/id'])
id_idx = list(MSadj.columns).index('compiledRelease/planning/identifier')
for i in range(MSadj.shape[0]):
    if len(str(MSadj.iloc[i, id_idx])) < 6:
        MSadj.iloc[i, id_idx] = MSadj['compiledRelease/id'][i][:6]


MSadj = MSadj.sort_values(by = col_sorts, ignore_index = True)




#First the contract ID's
archive = 'contracts.csv'
columns = ['compiledRelease/contracts/0/id',
           'compiledRelease/id',
           'compiledRelease/contracts/0/dateSigned',
           'compiledRelease/contracts/0/value/amount']
col_sorts = ['compiledRelease/id']

MS_cont = concat_csv(archive, columns, col_sorts, col_types)



#Now the award ID
archive = 'awa_suppliers.csv'
col_sorts = ['compiledRelease/awards/0/id']
MS_awa = concat_csv(archive, [], col_sorts)

id_idx = list(fp.columns).index('compiledRelease/contracts/0/id')

for i in range(fp.shape[0]):
    #First we write the contract ID 
    idx = look_awa_entity(fp, MS_cont, i, MS_cont.shape[0])
    if idx:
        aux = MS_cont['compiledRelease/contracts/0/id'][idx]
        fp.iloc[i, id_idx] = aux
        '''
        if aux[:2] == 'LP':
            fp.iloc[i, id_idx - 2] = "Licitación Pública Nacional"
        elif aux[:2] == "CD":
            fp.iloc[i, id_idx - 2] = "Contratación Directa"
        elif aux[:2] == "CO":
            fp.iloc[i, id_idx - 2] = "Contratación de Ofertas"
        elif aux[:2] == "CE":
            fp.iloc[i, id_idx - 2] = "Contratación por Excepción"
        elif aux[:2] == "AM":
            fp.iloc[i, id_idx - 2] = "?"
        elif aux[:2] == "LI":
            fp.iloc[i, id_idx - 2] = "Licitación Pública Internacional"
        elif aux[:2] == "LC":
            fp.iloc[i, id_idx - 2] = "Locación de Inmuebles"
        elif aux[:2] == "SC":
            fp.iloc[i, id_idx - 2] = "Selección Basada en Calidad y Costo"
        else:
            print("Warning! {} is not an identified code".format(aux))

        '''

    #Now the RUC of the Supplier
    supp_dat = look_awa_supp(fp, MS_awa, i, MS_awa.shape[0])
    
    if supp_dat:
        fp.loc[i, 'RUC'] = supp_dat[1][7:]
        fp.loc[i, 'Nombre de la empresa'] = supp_dat[0]
    else:
        print("Something is not good with ruc/name")

        
    #Now the Date published, the tender type and COnvocante
    data = look_records(fp, MSadj, i, MSadj.shape[0])

    if data:
        if len(str(fp.iloc[i, list(fp.columns).index('Fecha de publicación de convocatoria de licitación')])) < 4:
            fp.iloc[i, list(fp.columns).index('Fecha de publicación de convocatoria de licitación')] = data[0]

        if len(str(fp.iloc[i, list(fp.columns).index('Tipo de licitación')])) < 4:
            fp.iloc[i, list(fp.columns).index('Tipo de licitación')] = data[1]

        if len(str(fp.iloc[i, list(fp.columns).index('Convocante')])) < 4:
            fp.iloc[i, list(fp.columns).index('Convocante')] = data[2]
            
    
    
fp.to_excel('AIGA_Contratos_2012_2019.xlsx',
            index = False, sheet_name = 'Solo_contratos')
