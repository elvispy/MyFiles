#quick sort algorithm

def qsort(lista):
    if len(lista) == 0:
        return []
    if len(lista)==2:
        return [min(lista), max(lista)]
    elif len(lista) == 1:
        return lista
    pivot = lista[0]
    i = 1

    for j in range(i,len(lista)):
        if lista[j] < pivot:
            aux = lista[j]
            lista[j] = lista[i]
            lista[i] = aux
            i += 1
    lista[0] = lista[i-1]
    lista[i-1] = pivot
    #print(lista[:i], " ", [pivot
    return qsort(lista[:i-1]) + [pivot] + qsort(lista[i:])
