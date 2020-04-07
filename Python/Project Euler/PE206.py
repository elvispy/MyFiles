#PE206
from time import perf_counter
t = perf_counter()
candidates = ["3", "7"]

while len(str(int(pow(int(candidates[0]), 2)))) < 17:
    
    n_candidates = []
    for i in candidates:
        for j in range(1, 100):
            j = str(j)
            if len(j) < 2:
                j = "0" + j
            lencan = len(j+i)
            cand = str(int(pow(int(j + i), 2)))
            is_c = True
            for k in range(1, lencan+1, 2):
                if int(cand[-k]) != int(9-(k-1)/2):
                    is_c = False
                    break
            if is_c:
                n_candidates.append(j+i)
    candidates = n_candidates + [1]
    candidates = candidates[:-1]

for j in candidates:
    aux = str(int(pow(int(j), 2)))
    if aux[0] == "1" and aux[2] == "2" and aux[4] == "3" and aux[6] == "4" and len(aux) == 17:
        break
        


print("El resultado es: {}".format(j))
print("The time spent is: {}".format(perf_counter()-t))
