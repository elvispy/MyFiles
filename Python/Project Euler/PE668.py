import time
start = time.perf_counter()
from math import sqrt, ceil
def primeFactors(n):
    result = []
    exps = []
    i = 2
    while i< ceil(sqrt(n)):
        c = 0
        while n%i == 0:
            c+=1
            (result.append(i), exps.append(0)) if not i in result else None
            exps[-1] +=1
            n = int(n/i)
        i+=1
    if n>1:
        result.append(n) if not n in result else None
        exps.append(1)
    return [result, exps]


for i in range(1, pow(10, 10)):
    pass

print(time.perf_counter() - start)
