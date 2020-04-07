#PE 75
#We are trying to solve for unique solutions to d*a*(a+b) = L
#or, equivalently d*x*y = L, with x < y < 2*x
#assumming d = 1, i showd that every solution of x*y = L corresponds
#to a divisor of L in the inverval (sqrt(L/2), sqrt(L)).

L = [0] * 750001 #corresponds to every possible value of L, which is known to be even

from math import sqrt, gcd
from math import floor, ceil
from time import perf_counter
t = perf_counter()

mys = set() #this set will save the ratio between the catetos, so that we do not count them twice.
for i in range(2, 867):
 
    for j in range(1, i):
        cat1 = min([2*j*i, (i*i-j*j)])
        cat2 = max([2*j*i, (i*i-j*j)])
        if gcd(i, j) >1 or cat2/cat1 in mys:
            pass
        else:
            mys.add(cat2/cat1)
            d = 1
            while d*i*(i+j) <= 750000:

                L[d*i*(i+j)] += 1
                d += 1

                
res = 0
for i in L:
    if i == 1:
        res += 1
print("The result is {}".format(res))
print(perf_counter() - t)
