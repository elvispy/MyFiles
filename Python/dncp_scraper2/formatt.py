def main(datos):
    
    for dato in datos:
        dato['id_licitacion'] = int(dato['id_licitacion'])
    
        dato['monto_adjudicado'] = dato['monto_adjudicado'][2:]

        dato['monto_total'] = dato['monto_total'][2:]

    return datos


