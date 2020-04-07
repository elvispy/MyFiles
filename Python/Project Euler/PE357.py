#PE357
from time import perf_counter
import bi_search
from math import sqrt
t = perf_counter()

with open("2T_part1.txt", "r") as f:
    data = f.read()
data = data.split("\n")
data = [int(dat) for dat in data if dat]
squares = [i*i for i in data[:10]]
candidates = []

def test(n):
    last = 2
    divisors = [1, 2]
    i = 0
    sqr = int(sqrt(n)+1)
    aux = n+1
    aux = aux - 1
    n = int(n/2)
    while data[i] < sqr:
        if n%data[i] == 0:
            if data[i] == last:
                return False
            else:
                last = data[i]
                n = int(n/data[i])
                divisors = divisors + [last*i for i in divisors]
        else:
            i+=1
    if n > 1 and bi_search.binary_search(data, n) == -1:
        return False
    elif n>1:
        divisors = divisors + [n*i for i in divisors]
    divisors.sort()
    for i in range(int(len(divisors)/2)):
        if bi_search.binary_search(data, divisors[i] + divisors[-(i+1)]) == -1:
            return False
    return True

for dat in data:
    if 1 in [dat%i for i in squares]:
        pass
    elif bi_search.binary_search(data, int((dat+3)/2)) != -1:
        candidates.append(int(dat)-1)
res = 0

for i in candidates:
    if test(i):
        res+=i


print("El resultado es: {}".format(res))
print("The time spent is: {}".format(perf_counter()-t))
