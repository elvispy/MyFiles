import time
start = time.perf_counter()
from math import floor, ceil, sqrt
b1 = lambda k: 3*k*k+4
b2 = lambda k: 3*k*k+2
b3 = lambda k: 3*k*k+1
x = 1
aux1 = b1(x)
aux2 = b2(x)
aux3 = b3(x)
while aux1 < 1_500_000_000:
    if int(sqrt(aux1)) == sqrt(aux1):
        print(4*x*x+1)
        #print(x, aux1, 1)
    if int(sqrt(aux2)) == sqrt(aux2):
        print(2*x*x+1)
        #print(x, aux2, 2)
    if int(sqrt(aux3)) == sqrt(aux3):
        print(x*x+1)
        #print(x, aux3, 3)
    
    x+=1
    aux1 = b1(x)
    aux2 = b2(x)
    aux3 = b3(x)

print(time.perf_counter()-start)
