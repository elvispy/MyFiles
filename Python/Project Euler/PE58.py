#PE58
from time import perf_counter
from prime import is_prime
t = perf_counter()


d2 = []
d3 = []
d4 = []




def percent(n):
    if n == 1:
        return 0
    if n%2:
        while len(d2) < (n-1)/2:
            j = 2*len(d2)+3
            d2.append(is_prime(j*j-j+1))
            d3.append(is_prime(j*j-2*j+2))
            d4.append(is_prime(j*j-3*j+3))
        return (sum(d2[0:int((n-1)/2)]) + sum(d3[0:int((n-1)/2)]) + sum(d4[0:int((n-1)/2)]))/(2*n-1)  
          
    else:
        raise Exception("Solo puedo recibir argumentos impares")


lol = 3
while percent(lol) > 0.1:
    lol+=2
    
print("Solution: ", lol)
print("Time spent: {}".format(perf_counter()-t))
