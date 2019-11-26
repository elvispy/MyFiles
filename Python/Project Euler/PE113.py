import operator as op
from functools import reduce
def ncr(n, r):
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return int(numer/denom)

def  w(e, i):
    return ncr(i+e-1, e-1)


def myf(n):
    return w(9, n) + w(10, n) - 1 - 9
    return a #because we are counting two times the numbers that
    #are ascending and descending at the same time


#print(sum([myf(i) for i in range(1, 101)]))
