import operator as op
from functools import reduce

def ncr(n, r):
    r = min(r, n-r)
    numer = reduce(op.mul, range(n, n-r, -1), 1)
    denom = reduce(op.mul, range(1, r+1), 1)
    return numer / denom


def p(n):
    return sum([e(n-q, q) for q in range(1, n+1)])


def e(p, q):
    if p<0 or q<1:
        raise Exception
    if p == 0 or q == 1:
        return 1
    if p == 1:
        return q
    if q == 2:
        return int((p+1)/2)
    return sum([em(p, q, i) for i in range(p, min(int(p/q)-1, 1), -1)])

def em(p, q, i):
    if i == 0:
        return 0
    if i == 1:
        return ncr(p, q)
    
    return sum([emj(p, q, i, j) for j in range(1, min(q+1,int(p/i)+2))])

def emj(p, q, i, j):
    return sum([em(p-i*j, q-j, k) for k in range(1, i)])
