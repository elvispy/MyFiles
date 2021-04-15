import pathlib
import pandas as pd
path = 'D:\\Documents\\LicitacionesDNCP\\{}\\{}'

sofia = True

## COL TYPES for records

records_col_types = {'Open Contracting ID':'str',
                     'compiledRelease/id':'str',
                     'compiledRelease/tender/id':'str',
                     'compiledRelease/tender/title':'str',
                     'compiledRelease/tender/status':'str',
                     'compiledRelease/tender/awardCriteria':'str',
                     'compiledRelease/tender/awardCriteriaDetails':'str',
                     'compiledRelease/tender/submissionMethod':'str',
                     'compiledRelease/tender/bidOpening/date':'str',
                     'compiledRelease/tender/bidOpening/address/streetAddress':'str',
                     'compiledRelease/tender/submissionMethodDetails':'str',
                     'compiledRelease/tender/eligibilityCriteria':'str',
                     'compiledRelease/tender/statusDetails':'str',
                     'compiledRelease/tender/enquiriesAddress/streetAddress':'str',
                     'compiledRelease/tender/mainProcurementCategoryDetails':'str',
                     'compiledRelease/tender/hasEnquiries':'object',
                     'compiledRelease/tender/value/amount':'float64',
                     'compiledRelease/tender/value/currency':'str',
                     'compiledRelease/tender/datePublished':'str',
                     'compiledRelease/tender/tenderPeriod/startDate':'str',
                     'compiledRelease/tender/tenderPeriod/endDate':'str',
                     'compiledRelease/tender/tenderPeriod/durationInDays':'float64',
                     'compiledRelease/tender/awardPeriod/startDate':'str',
                     'compiledRelease/tender/contractPeriod/maxExtentDate':'str',
                     'compiledRelease/tender/enquiryPeriod/endDate':'str',
                     'compiledRelease/tender/enquiryPeriod/startDate':'str',
                     'compiledRelease/tender/enquiryPeriod/durationInDays':'float64',
                     'compiledRelease/tender/mainProcurementCategory':'str',
                     'compiledRelease/tender/procurementMethod':'str',
                     'compiledRelease/tender/procurementMethodDetails':'str',
                     'compiledRelease/tender/procuringEntity/id':'str',
                     'compiledRelease/tender/procuringEntity/name':'str',
                     'compiledRelease/tender/numberOfTenderers':'float64',
                     'compiledRelease/language':'str',
                     'compiledRelease/ocid':'str',
                     'compiledRelease/date':'str',
                     'compiledRelease/initiationType':'str',
                     'compiledRelease/buyer/id':'str',
                     'compiledRelease/buyer/name':'str',
                     'compiledRelease/planning/identifier':'str',
                     'compiledRelease/planning/estimatedDate':'str',
                     'compiledRelease/planning/budget/description':'str',
                     'compiledRelease/planning/budget/amount/amount':'float64'
                     }
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
                             dtype = col_types)
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

    
    

def filter_MS_tenders(path, code):
    
    archive = 'records.csv'


    columns = ['compiledRelease/planning/identifier',
               'compiledRelease/buyer/name',
               'compiledRelease/tender/procurementMethodDetails',
               'compiledRelease/tender/datePublished',
               'compiledRelease/tender/title',
               'compiledRelease/tender/status',
               'compiledRelease/tender/id',
               'compiledRelease/id',
               'compiledRelease/tender/mainProcurementCategoryDetails',
               'compiledRelease/tender/coveredBy',
               'compiledRelease/tender/bidOpening/date',
               'compiledRelease/tender/statusDetails',
               'compiledRelease/buyer/id',
               
               ]

    
    col_types = {'compiledRelease/planning/identifier':'str'}
    filters = {columns[-1]:code}
    col_sorts = ['compiledRelease/id']

    #Concatenate recods, filter columns, sort rows, filter rows
    MSadj = concat_csv(archive, columns, col_sorts, records_col_types, filters)

    #Filter more columns
    columns = columns[:-1]
    MSadj = MSadj[columns]

    #MSadj = MSadj[MSadj[columns[2]] > '2013-08-15']
    
    MSadj = MSadj.reset_index(drop = True)

    #LEts also add the url
    MSadj['url'] = ''

    for i in range(MSadj.shape[0]):
        MSadj.loc[i, 'url'] = 'https://www.contrataciones.gov.py/licitaciones/convocatoria/' + MSadj.loc[i, 'compiledRelease/tender/id'] + '.html'
        if len(MSadj['compiledRelease/planning/identifier'][i]) < 6:
            MSadj.loc[i, 'compiledRelease/planning/identifier'] = MSadj['compiledRelease/id'][i][:6]

    #Now lets add the link to the pbc
    #Add a new column
    '''
    MSadj['url_pbc'] = ''

    #Columns to be returned
    pbc_columns = ['compiledRelease/tender/id',
                   'compiledRelease/tender/documents/0/url'                   
                   ]

    #Pivot column to sort
    pbc_col_sorts = ['compiledRelease/tender/id']
    
    pbc_archive = 'ten_documents.csv' #Name of the archive
    
    #Filters to be applied
    pbc_filters = {'compiledRelease/tender/documents/0/documentType':'biddingDocuments'}

    #Concatenate documents of all years.
    MS_url_pbc = concat_csv(pbc_archive, pbc_columns, pbc_col_sorts, {}, pbc_filters)

    idx = list(MSadj.columns).index('url_pbc')
    maxx = MS_url_pbc.shape[0]

    #Add the corresponding results of look_adj_pbc
    for i in range(MSadj.shape[0]):
        MSadj.iloc[i, idx] = look_adj_pbc(MSadj, MS_url_pbc, i, maxx)

    '''


    

    if MSadj.empty:
        raise Exception("MSadj vacia!")
    return MSadj

def filt_cont(fp, MSadj):
    '''This function checks if the ID of the contract belongs to the list of tenderers
    MSadj has to be sorted in the column compiledRelease/id'''
    cols = fp.shape[0]
    Mcols = MSadj.shape[0]
    res = []
    is_in_date = []
    for i in range(cols):
        j = MSadj['compiledRelease/id'].searchsorted(fp['compiledRelease/id'][i])
        j = j if j < Mcols else 0
        lic_id = MSadj['compiledRelease/planning/identifier'][j]
        lic_id = str(lic_id)[:6]
        if lic_id:
            if lic_id in fp['compiledRelease/id'][i]:
                res.append(i)
                fp.loc[i, 'contract_title'] = MSadj.loc[j, 'compiledRelease/tender/title']
                fp.loc[i, 'convocante']     = MSadj.loc[j, 'compiledRelease/buyer/name']
                fp.loc[i, 'tags']           = MSadj.loc[j, 'compiledRelease/tender/coveredBy']
                fp.loc[i, 'categoria']      = MSadj.loc[j, 'compiledRelease/tender/mainProcurementCategoryDetails']
                is_in_date.append(j)
    is_in_date = list(set(is_in_date))
    #MSadj = MSadj.loc[is_in_date]
    #MSadj = MSadj.reset_index(drop = True)
    fp = fp.loc[res]
    fp = fp.reset_index(drop = True)
    return [is_in_date, fp]

def look_awa_entity(MScont, MSsupp, i, maxx):
    '''This function looks for the awarded suppliers per contract.
    It also returns the supplier's RUC. Returns an empty string if no supplier was found'''

    val = MScont['compiledRelease/contracts/0/awardID'][i]

    idx = MSsupp['compiledRelease/awards/0/id'].searchsorted(val)

    idx = idx if idx < maxx else 0

    if MSsupp['compiledRelease/awards/0/id'][idx] == val:
        return [MSsupp['compiledRelease/awards/0/suppliers/0/id'][idx],
                MSsupp['compiledRelease/awards/0/suppliers/0/name'][idx]]
    else:
        return ["", ""]

def look_party_data(MScont, MS_par, i, maxx):
    '''This function looks for data of the parties involved.
    Returns an empty string if no supplier was found'''
    #Search for the ID in the dataset of parties
    val = MScont['RUC_empresa'][i]
    
    c1 = 'compiledRelease/parties/0/id'
    idx = MS_par[c1].searchsorted(val)

    idx = idx if idx < maxx else 0
    
    #If present, return all the data
    if MS_par[c1][idx] == val:
        #print(MS_par.loc[idx])
        return [MS_par['compiledRelease/parties/0/contactPoint/telephone'][idx],
                MS_par['compiledRelease/parties/0/contactPoint/email'][idx],
                MS_par['compiledRelease/parties/0/address/locality'][idx] + ', ' + MS_par['compiledRelease/parties/0/address/streetAddress'][idx],
                MS_par['compiledRelease/parties/0/contactPoint/name'][idx]
                ]
    else:
        return ["", "", "", ""]


def look_cont_url(MS_cont, MS_url_cont, i, maxx):
    ''' This function returns the url of the contract in the position i'''

    c = 'compiledRelease/contracts/0/id'

    val = MS_cont[c][i]

    idx = MS_url_cont[c].searchsorted(val)

    idx = idx if idx < maxx else 0

    if MS_url_cont[c][idx] == val:
        return MS_url_cont['compiledRelease/contracts/0/documents/0/url'][idx]
    else:
        return ""

def look_adj_pbc(MSadj, MS_url_pbc, i, maxx):
    ''' This function returns the url of the PBC in the position i'''

    c = 'compiledRelease/tender/id'

    val = MSadj[c][i]

    idx = MS_url_pbc[c].searchsorted(val)

    idx = idx if idx < maxx else 0

    if MS_url_pbc[c][idx] == val:
        return MS_url_pbc['compiledRelease/tender/documents/0/url'][idx]
    else:
        return ""
                   


def list_MS_contracts(path, MSadj, ddate):
    ''' This function produces a csv with all the data necessary per contract.
    The input is the path of the folders with all the data'''


    con_archive = 'contracts.csv'

    columns = ['compiledRelease/id',
               'compiledRelease/contracts/0/id',
               'compiledRelease/contracts/0/dateSigned',
               'compiledRelease/contracts/0/period/startDate',
               'compiledRelease/contracts/0/value/amount',
               'compiledRelease/contracts/0/value/currency',
               'compiledRelease/contracts/0/statusDetails',
               'compiledRelease/contracts/0/awardID'
               ]

    col_sorts = ['compiledRelease/id']

    #filters = {'compiledRelease/contracts/0/statusDetails':'Adjudicado'}

    #Filter in every year and concatenate, then sort rows
    MS_cont = concat_csv(con_archive, columns, col_sorts)
    
    #If we are in the MSPBS research, filter from 2013 onwards
    #Else, filter from match 2020 onwards
    
    MS_cont = MS_cont[MS_cont['compiledRelease/contracts/0/dateSigned'] > ddate]
        
    MS_cont = MS_cont.reset_index(drop = True)
    MS_cont['contract_title'] = ''
    MS_cont['convocante'] = ''
    MS_cont['tags'] = ''
    MS_cont['categoria'] = ''
    
    is_in_date = []
    [is_in_date, MS_cont] = filt_cont(MS_cont, MSadj)
    MSadj = pd.merge(MSadj[MSadj['compiledRelease/tender/datePublished'] > ddate], MSadj.loc[is_in_date], how = 'outer')
    #MScont = MScont.sort_values(by = ['compiledRelease/id'], ignore_index = True)

    
    #Add link al contrato.
    MS_cont['url_contrato'] = 'https://www.contrataciones.gov.py/licitaciones/adjudicacion/contrato/' + MS_cont[columns[7]] + '.html'
    

    #Now lets link suppliers with contracts
    sup_archive = 'awa_suppliers.csv'
    col_sorts = ['compiledRelease/awards/0/id']
    MS_supp = concat_csv(sup_archive, [], col_sorts)
    #MS_supp = MS_supp.sort_values(by=['compiledRelease/awards/0/id'], ignore_index=True)
    
    #create new empty columns
    MS_cont['empresa_adjudicada'] = ''
    MS_cont['RUC_empresa'] = ''
    #Seek the index of this new column
    emp_idx = list(MS_cont.columns).index('empresa_adjudicada')
    maxx = MS_supp.shape[0]

    #Now lets fill the column with the RUC and name (in that order)
    for i in range(MS_cont.shape[0]):
        [MS_cont.iloc[i, emp_idx + 1], MS_cont.iloc[i, emp_idx]] = look_awa_entity(MS_cont, MS_supp, i, maxx)

    del MS_supp
    
    #Now lets fill the data of the Supplier.   
    par_archive = 'parties.csv'
    par_columns = ['compiledRelease/id',
                   'compiledRelease/parties/0/id',
                   'compiledRelease/parties/0/name',
                   'compiledRelease/parties/0/identifier/legalName',
                   'compiledRelease/parties/0/contactPoint/email',
                   'compiledRelease/parties/0/contactPoint/name',
                   'compiledRelease/parties/0/contactPoint/telephone',
                   'compiledRelease/parties/0/address/locality',
                   'compiledRelease/parties/0/address/streetAddress'
                   ]
    col_sorts = ['compiledRelease/parties/0/id']
    filters = {'compiledRelease/parties/0/identifier/scheme':'PY-RUC'}
    MS_par = concat_csv(par_archive, par_columns, col_sorts, {}, filters)
    MS_par = MS_par.drop_duplicates(subset = 'compiledRelease/parties/0/id', ignore_index = True)

    #Lets add the new columns:
    MS_cont['tel_empresa'] = ''
    MS_cont['email_empresa'] = ''
    MS_cont['address_emp'] = ''
    MS_cont['empresa_legalName'] = ''

    maxx = MS_par.shape[0]
    tel_idx = list(MS_cont.columns).index('tel_empresa')

    #Lets update the records
    for i in range(MS_cont.shape[0]):
        data = look_party_data(MS_cont, MS_par, i, maxx)
        MS_cont.iloc[i, tel_idx] = data[0]
        MS_cont.iloc[i, tel_idx + 1] = data[1]
        MS_cont.iloc[i, tel_idx + 2] = data[2]
        MS_cont.iloc[i, tel_idx + 3] = data[3]

    del MS_par

    '''
    #Now lets add the link to the contract

    cont_columns = ['compiledRelease/contracts/0/id',
                    'compiledRelease/contracts/0/documents/0/url']
    cont_col_sorts = ['compiledRelease/contracts/0/id']
    cont_archive = 'con_documents.csv'

    MS_url_cont = concat_csv(cont_archive, cont_columns, cont_col_sorts)
    MS_cont['url_contrato'] = ''
 
    idx = list(MS_cont.columns).index('url_contrato')
    maxx = MS_url_cont.shape[0]

    for i in range(MS_cont.shape[0]):
        MS_cont.iloc[i, idx] = look_cont_url(MS_cont, MS_url_cont, i, maxx)
    '''
    
    '''
    #Now let's set who was the minister in Charge
    if irene:
        ministry = {'Antonio Barrios':'2018-01-28',
                     'Carlos Morinigo':'2018-08-14',
                     'Julio Mazzoleni (PreCovid)':'2020-03-01',
                     'Julio Mazzoleni (PostCovid)':'2020-12-31'
                     }
        MS_cont['ministro'] = ''
        min_cont = list(MS_cont.columns).index('ministro')
        for i in range(MS_cont.shape[0]):
            for minister in ministry.keys():
                if MS_cont[columns[2]][i] < ministry[minister]:
                    MS_cont.iloc[i, min_cont] = minister
                    break

    '''


    #Now let's fill the CC details

    bud_archive = 'con_imp_fin_breakdown.csv'

    bud_cols = ['compiledRelease/contracts/0/id',
                'compiledRelease/contracts/0/implementation/financialProgress/breakdown/0/measures/monto_a_utilizar',
                'compiledRelease/contracts/0/implementation/financialProgress/breakdown/0/classifications/financiador'
                ]
    bud_col_sorts = ['compiledRelease/contracts/0/id']

    bud_col_types = {'compiledRelease/contracts/0/id':'str',
                'compiledRelease/contracts/0/implementation/financialProgress/breakdown/0/measures/monto_a_utilizar':'str',
                'compiledRelease/contracts/0/implementation/financialProgress/breakdown/0/classifications/financiador':'str'
                }

    MS_bud = concat_csv(bud_archive, bud_cols, bud_col_sorts, bud_col_types)

    maxx = MS_bud.shape[0]
    MS_cont['OF'] = ''
    MS_cont['monto_RE'] = ''
    MS_cont['other_fun'] = ''

    for i in range(MS_cont.shape[0]):
        c = 'compiledRelease/contracts/0/id'
        val = MS_cont[c][i]

        idx = MS_bud[c].searchsorted(val)

        idx = idx if idx < maxx else 0

        of = ''
        while MS_bud[c][idx] == val:
            of = of + MS_bud[bud_cols[2]][idx] + '_'
            if MS_bud[bud_cols[2]][idx] == '817':
                MS_cont.loc[i, 'monto_RE'] = MS_bud[bud_cols[1]][idx]
            idx += 1
        if of:
            of = of[:-1]
        if len(MS_cont.loc[i, 'monto_RE']) < 2:
            MS_cont.loc[i, 'monto_RE'] = '0'

        MS_cont.loc[i, 'other_fun'] = str(int(MS_cont['compiledRelease/contracts/0/value/amount'][i])
                                          - int(MS_cont['monto_RE'][i]))
        MS_cont.loc[i, 'OF'] = of
    

    return [MSadj, MS_cont]

def list_MS_items(path, MS_cont):
    archive = 'awa_items.csv'
    columns = ['compiledRelease/id',
               'compiledRelease/awards/0/id',
               'compiledRelease/awards/0/items/0/description',
               'compiledRelease/awards/0/items/0/classification/id',
               'compiledRelease/awards/0/items/0/quantity',
               'compiledRelease/awards/0/items/0/unit/value/amount',
               'compiledRelease/awards/0/items/0/unit/value/currency'
               ]
    MS_items = concat_csv(archive, columns)

    #MS_cont = MS_cont[['compiledRelease/contracts/0/awardID', 'compiledRelease/contracts/0/id']]

    MS_items["convocante"] = ''
    MS_items["cont_id"] = ''
    MS_items["cont_title"] = ''
    MS_items["categoria"] = ''
    MS_items["contract_sign_date"] = ''
    MS_items["cont_startDate"] = ''
    MS_items["empresa"] = ''
    

    MS_items = MS_items.sort_values(by = ['compiledRelease/awards/0/id'],
                                  ignore_index = True)
    
    indexes_in_date = [] #to restric MS_items 
    
    maxx = MS_items.shape[0]
    print("Agregando columnas al MS_items (Via contratos):")
    
    for i in range(MS_cont.shape[0]):
        c = 'compiledRelease/contracts/0/awardID'
        c_it = 'compiledRelease/awards/0/id'

        val = MS_cont[c][i] 

        idx = MS_items[c_it].searchsorted(val)

        idx = idx if idx < maxx else 0

        while MS_items[c_it][idx] == val:
            indexes_in_date.append(idx)
            
            #Now lets add the Contract ID and other info
            MS_items.loc[idx, 'cont_id']            = MS_cont['compiledRelease/contracts/0/id'][i]
            MS_items.loc[idx, "convocante"]         = MS_cont['convocante'][i]
            MS_items.loc[idx, "cont_title"]         = MS_cont['contract_title'][i]
            MS_items.loc[idx, "categoria"]          = MS_cont['categoria'][i]
            MS_items.loc[idx, "contract_sign_date"] = MS_cont['compiledRelease/contracts/0/dateSigned'][i]
            MS_items.loc[idx, "cont_startDate"]     = MS_cont['compiledRelease/contracts/0/period/startDate'][i]
            MS_items.loc[idx, "empresa"]            = MS_cont['empresa_adjudicada'][i]
            idx = idx + 1

        if i%100 == 0:
            print(i)
    MS_items = MS_items.loc[indexes_in_date]
    
    MS_items = MS_items.reset_index(drop = True)

    return MS_items

def rename_final(MSadj, MS_cont, MS_items, name):

    adjname = '{}_awarded_2013_2020.csv'.format(name)
    contname = '{}_contracts_2013_2020.csv'.format(name)
    itname = '{}_items_2013_2020.csv'.format(name)
    
    lic_cols = ["ID de Licitacion",
                "Institucion Convocante",
                "Tipo de licitacion",
                "Titulo de licitacion",
                "Etapa de licitacion",
                "Estado de Licitacion",
                "Fecha de publicación de convocatoria del llamado",
                "Categoria del bien a adquirir",
                "Fecha de Apertura de Ofertas",
                "URL",
                "Tags"
                ]

    lic_ori = ['compiledRelease/planning/identifier',
               'compiledRelease/buyer/name',
               'compiledRelease/tender/procurementMethodDetails',
               'compiledRelease/tender/title',
               'compiledRelease/tender/statusDetails',
               'compiledRelease/tender/status',
               'compiledRelease/tender/datePublished',
               'compiledRelease/tender/mainProcurementCategoryDetails',
               'compiledRelease/tender/bidOpening/date',
               'url', #need to program this
               'compiledRelease/tender/coveredBy',
               ]
    
               
    #Columns for the contract table           
    
    cont_cols = ["ID de Licitacion",
                 "Institucion Convocante",
                 "N de Contrato",
                 "Fecha de firma de contrato",
                 "Fecha de publicacion de contrato en la DNCP",
                 "Inicio de la prestacion de servicios",
                 "Titulo de contrato",
                 "Monto total del contrato",
                 "Organos Financiadores",
                 "Empresa Adjudicada",
                 "Link al contrato",
                 "Representante Legal",
                 "RUC Empresa Adjudicada",
                 "Estado de Contrato",
                 "Tags",
                 "Categoria"
                 ]
    

    cont_ori = ['compiledRelease/id',
                'convocante',
                'compiledRelease/contracts/0/id',
                'compiledRelease/contracts/0/dateSigned',
                'pub_date',
                'compiledRelease/contracts/0/period/startDate',
                'contract_title', #This may be 
                'compiledRelease/contracts/0/value/amount',
                'OF', #This is new
                'empresa_adjudicada',
                'url_contrato',
                'empresa_legalName',
                'RUC_empresa',
                'compiledRelease/contracts/0/statusDetails',
                'tags',
                'categoria'
                ]
    MS_cont['pub_date'] = ''

    

                
    for i in range(MS_cont.shape[0]):
        MS_cont.loc[i, 'compiledRelease/id'] = MS_cont.loc[i, 'compiledRelease/id'][:6]

    #Now the columns of the items
        
    it_cols = ["ID de Licitacion",
               "Institucion Convocante",
               "N de contrato",
               "Titulo de contrato",
               "Categoria",
               "Fecha de firma de contrato",
               "Inicio de Prestacion de Servicios",
               "Empresa",
               "Item Adjudicado",
               "ID del Item",
               "Monto Unitario por Item",
               "Unidad de Medida",
               "Monto total del Item"
               ]
    
    it_ori = ["compiledRelease/id",
              "convocante", #lic
              "cont_id", #cont
              "cont_title", #cont
              "categoria", #lic
              "contract_sign_date", #cont
              "cont_startDate", #cont
              "empresa", #cont  
              "compiledRelease/awards/0/items/0/description",
              "compiledRelease/awards/0/items/0/classification/id",
              "compiledRelease/awards/0/items/0/unit/value/amount",
              "compiledRelease/awards/0/items/0/quantity",
              "total_item" #This is new
              ]

    for i in range(MS_items.shape[0]):
        MS_items.loc[i, 'compiledRelease/id'] = MS_items.loc[i, 'compiledRelease/id'][:6]
    

    if not MSadj.empty:
        MSadj = MSadj[lic_ori]
        MSadj.columns = lic_cols
        MSadj = MSadj.sort_values(by = ['ID de Licitacion'], ascending = False, ignore_index = True)
        MSadj.to_csv(adjname, index = False)

    if not MS_cont.empty:
        MS_cont = MS_cont[cont_ori]
        MS_cont.columns = cont_cols
        MS_cont = MS_cont.sort_values(by = ['ID de Licitacion'], ascending = False, ignore_index = True)
        MS_cont.to_csv(contname, index = False)

    if not MS_items.empty:
        MS_items['total_item'] = MS_items["compiledRelease/awards/0/items/0/unit/value/amount"].astype("int64") * MS_items["compiledRelease/awards/0/items/0/quantity"].astype("int64")
        MS_items = MS_items[it_ori]
        MS_items.columns = it_cols
        MS_items.to_csv(itname, index = False)

    #return [MSadj, MS_cont, MS_items]
              

if __name__ == '__main__':

    if sofia:
        code = 'DNCP-SICP-CODE-196'

        name = 'Mun{}'

        if code[-3:] == '196':
            name = name.format('CDE')
        elif code[-3:] == '-44':
            name = name.format('Franco')
        elif code[-3:] == '199':
            name = name.format('Hern')
        elif code[-3:] == '233':
            name = name.format('Minga')
        else:
            raise Exception("Uy kieto, codigo no identificado")

        ddate = '2020-03-01'


    #MSadj = filter_MS_tenders(path, code)

    
    print("Finished with tenders")
    
    #[MSadj, MS_cont] = list_MS_contracts(path, MSadj, ddate)

    print("Lets begin with the items")

    #MS_items = list_MS_items(path, MS_cont)

    print("Now I rename and set everything")

    #renamed = rename_final(MSadj, MS_cont, pd.DataFrame(), code, name)
