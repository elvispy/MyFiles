#PE44
from math import sqrt
def test(k):
    n = (sqrt(24*k+1)+1)/6
    n = int(n)
    if n*(3*n-1)/2 == k:
        return True
    return False
    
pentagons = []
j = 1
pent = lambda x: x*(3*x-1)/2
stay = True
while stay:
    
    val =  pent(j)
    for q in pentagons:
        if val-q in pentagons:
            if test(val + q):
                stay = False
                print(val, q)
                break
    pentagons.append(val)
                
    j+=1
