import time
from math import ceil, sqrt
start = time.perf_counter()
triples = [[]] * 1_500_000
def get_d1(p):
    if p%2:
        return []
    p = int(p/2)
    res = []
    for m in range(1, int(p/2)):
        if not p%m:
            if int(p/m) < 2*m and int(p/m)>m:
                n = int(p/m)-m
                res.append([m*m-n*n, 2*m*n, m*m+n*n])

    return res
                
prohibited = []  

for p in range(1, 1_500_001):
    if ( p%2 or any([not p%j for j in prohibited])):
        continue
    triples[p-1] = get_d1(p)
    for d in range(2, int(p/2)+1):
        if len(triples[p-1]) > 1:
            prohibited.append(p)
            break
        if not p%d:
            aux = int(p/d)
            tri_d = get_d1(aux)
            tri_d = [[d*j[0], d*j[1], d*j[2]] for j in tri_d if not ([d*j[0], d*j[1], d*j[2]] in triples[p-1]) and
                     not ([d*j[1], d*j[0], d*j[2]] in triples[p-1])]
            triples[p-1] = triples[p-1] + tri_d
    
    

print(time.perf_counter()-start)
