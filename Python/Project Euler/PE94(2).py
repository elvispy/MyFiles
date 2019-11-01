import time
from math import sqrt, floor
start = time.perf_counter()

i = 2
S = lambda x: (3*x+1)/2
S2 = lambda x: (3*x-1)/2
def A(x):
    aux = floor(sqrt(S(x)*(S(x)-x-1)))
    if aux * aux == S(x) * (S(x)-x-1):
        return True
    return False
def B(x):
    aux = floor(sqrt(S2(x)*(S2(x)-x+1)))
    if aux * aux == S2(x) * (S2(x)-x+1):
        return True
    return False
res = []
while i*i < 500_000_000:
    #First analyse the almost equilateral triangle a, a, a+1
    #case a = 4k, 4k+2
    if int(sqrt(3*i*i+4)) == sqrt(3*i*i+4):
        test = i*i+1
        if A(test):
            if [test, True] in res:
                pass
            else:
                res.append([test, True])
            print(test, 1)
    #case a = 4k+1
    if int(sqrt(3*i*i+1)) == sqrt(3*i*i+1):
        test = 4*i*i+1
        if A(test):
            if [test, True] in res:
                pass
            else:
                res.append([test, True])
            print(test, 2)
    #case 4k+3 ! there is no solution
    
    
    
    #Now let's analyse the case a, a, a-1
    #The case a = 4k, 4k+2
    #There are no solutions!

    #The case a = 4k+1
    test = 3*i*i-2
    if int(sqrt(test)) == sqrt(test):
        test = 2*i*i-1
        if B(test):
            if [test, False] in res:
                pass
            else:
                res.append([test, False])
            print(test, 3)
            
    i+=1




print(time.perf_counter()-start)
