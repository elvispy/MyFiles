#PE51
from time import perf_counter
t = perf_counter()

with open("pprimes.txt", "r") as f:
    data = f.read()
data = data.split("\n")

def add_digit(lis, m):
    if lis[-1] < m:
        lis[-1] += 1
    elif lis[-2] < m-1:
        lis[-2] += 1
        lis[-1] = lis[-2] + 1
    else:
        lis[0] += 1
        lis[1] = lis[0] + 1
        lis[2] = lis[1] + 1
    
    return lis

def check_family(prime):
    prime = str(prime)
    digits = [0, 1, 2]
    l = len(prime)
    inimax = 0
    inidigits = [0, 0, 0]
    while digits != [l-3, l-2, l-1]:
        maxx = 0
        for i in range(10):
            if 0 in digits and i == 0:
                continue
            else:
                aux = ""
                for j in range(l):
                    if j in digits:
                        aux = aux + str(i)
                    else:
                        aux = aux + prime[j]
                if aux in data:
                    maxx +=1
        if maxx > inimax:
            inimax = maxx
            inidigits = [digits[0], digits[1], digits[2]]
        digits = add_digit(digits, l-2)
    return [inimax, inidigits]
ini = 2101
res = 0
while res < 8:
    [res, _] = check_family(data[ini])
    ini += 1
print("El resultado es: {}".format(data[ini-1]))
print("The time spent is: {}".format(perf_counter()-t))
