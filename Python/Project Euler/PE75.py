#PE 75
#We are trying to solve for unique solutions to d*a*(a+b) = L
#or, equivalently d*x*y = L, with x < y < 2*x
#assumming d = 1, i showd that every solution of x*y = L corresponds
#to a divisor of L in the inverval (sqrt(L/2), sqrt(L)).

L = [0] * 750001 #corresponds to every possible value of L, which is known to be even

from math import sqrt
from math import floor, ceil
from time import perf_counter
t = perf_counter()
def addways(l):
    if L[l] > 1:
        return
    #if l >= 750000: #if exceeds, raise an exception
    #    raise Exception("The la rifaste")
    
    sup = ceil(sqrt(l)-1) + 1 #superior bound to the 
    inf = floor(sqrt(l/2)+1)
    myres = 0
    for i in range(inf, sup):
        if not l%i:
            myres += 1
    for j in range(1, floor(750000/l)+1):
        L[j*l] += myres

for i in range(1, 750001):
    #print("Doin' ", i)
    addways(i)
res = 0
for i in L:
    if i == 1:
        res += 1
print("The result is {}".format(res))
print(perf_counter() - t)
