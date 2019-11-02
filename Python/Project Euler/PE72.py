import time
start = time.perf_counter()
from math import ceil, sqrt
def primeFactors(n):
    result = []
    exps = []
    i = 2
    while i<= ceil(sqrt(n)):
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

def phi(n):
    if n == 1:
        return 1
    res = 1
    [primes, exponents] = primeFactors(n)
    for i in range(len(primes)):

        res *= pow(primes[i], exponents[i]-1)*(primes[i]-1)

    return res


print(sum([phi(n) for n in range(2, 1000001)]))

print(time.perf_counter()-start)
