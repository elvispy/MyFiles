def main(dato):
    
    #Formatting id_licitacion
    dato['id_licitacion'] = int(dato['id_licitacion'])
    
    #Formatting Monto Adjudicado and monto total 
    dato['monto_adjudicado'] = int(dato['monto_adjudicado'][2:].replace(".", ""))

    


    #Formatting nro de contrato
    if len(dato['nro_contrato']) < 3:

        dato['nro_contrato'] = dato['nro_contrato'] + "/" + dato['periodo']
    #Formatting categoria, to fit excel standards.
    cat = int(dato['categoria'][:2])
    if cat == 21:

        dato['categoria'] = 'Obras de infraestructura'

    elif cat == 9:

        dato['categoria'] = 'Alimentacion Escolar'

    elif cat == 23:

        dato['categoria'] = 'Equipamientos'

    else:
        if "construcciones" in dato['categoria'].lower():
            dato['categoria'] = 'Obras de infraestructura'
        else:
            print(dato['categoria'])
            print("Nuevo tipo de licitacion!. Favor introduzca una categoria.")
            print("Nombre del contrato")
            print(dato['nombre_licitacion'])
            dato['categoria'] = input("")

    '''
    #Formatting nombre_licitacion

    lic_name = datos['nombre_licitacion']
    dicc_acentos = {
        'á':'',
        'é':r'\u00e9',
        'í':'',
        'ó':r'\u00f3',
        'ú':'',
        'A':'',
        'E':r'\u00c9',
        'I':'',
        'O':r'\u00d3',
        'U':'',
        
        }
    '''

    return dato


