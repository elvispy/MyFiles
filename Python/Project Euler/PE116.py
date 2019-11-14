#Project Euler Problem 116
from PE113 import ncr
from math import ceil
def reds(n, j):
    return ncr(n-j, j)

def red(n):
    val = ceil(n/2)
    while 2*val > n:
        val-=1
    return sum([reds(n, j) for j in range(1, val+1)])

def greens(n, j):
    return ncr(n-2*j, j)

def green(n):
    val = ceil(n/3)
    while 3*val > n:
        val-=1
    return sum([greens(n, j) for j in range(1, val+1)])

def blues(n, j):
    return ncr(n-3*j, j)

def blue(n):
    val = ceil(n/4)
    while 4*val > n:
        val-=1
    return sum([blues(n, j) for j in range(1, val+1)])


def total(n):
    return red(n) + blue(n) + green(n)

