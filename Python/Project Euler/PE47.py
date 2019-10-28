from math import ceil, sqrt
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
    return len(result)

a = 5
aux = [primeFactors(2), primeFactors(3), primeFactors(4), primeFactors(5)]
while aux != [4, 4, 4, 4]:
    a+=1
    aux = aux + [primeFactors(a)]
    aux = aux[-4:]
