import operator as op
from functools import reduce

def ncr(n, r):
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return numer / denom
c = 0
for i in range(1, 101):
    for j in range(0, i+1):
        if ncr(i, j) > 1000000:
            c+=1
print(c)
