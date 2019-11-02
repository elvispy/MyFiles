from itertools import permutations
import time
start = time.perf_counter()
result = [1, 2, 3, 4]

lst2num = lambda tupl: sum([tupl[-i]*pow(10, i-1) for i in
                            range(1, len(tupl)+1)])
digits = {1, 2, 3, 4, 5, 6, 7, 8, 9}
panpro = set()
c = 0
while result != [6, 7, 8, 9]:
    c+=1
    #-------
    sett = digits - set(result)
    tries = list(permutations(sett))
    products = list(permutations(result))
    for pos in range(1, 5):
        for guess in tries:
            for reorder in products:
                if lst2num(guess[0:pos]) * lst2num(guess[pos:]) == lst2num(reorder):
                    panpro = panpro.union(set([lst2num(reorder)]))
                
    #-------
    if result[-1] == 9:
        if result[-2] == 8:
            if result[-3] == 7:
                result = [result[0]+1, result[0]+2, result[0]+3, result[0]+4]
            else:
                result = [result[0], result[1]+1, result[1]+2, result[1]+3]
        else:
            result = [result[0], result[1], result[2]+1, result[2]+2]
    else:
        result[-1] +=1
        
print(time.perf_counter()-start)
