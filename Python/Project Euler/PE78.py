import operator as op
from functools import reduce

def ncr(n, r):
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return numer / denom


def f(n):
    if n == 1:
        return 1
    elif n == 2:
        return 2
    elif n == 3:
        return 3
    elif n == 4:
        return 6
    return 2 + sum([f(n, i) for i in range(2, n)])


def f(n, i):
    if i in [1, n-1, n]:
        return 1
    return 

    
