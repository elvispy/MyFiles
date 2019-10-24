from math import floor
from math import sqrt
def is_prime(n: int) -> bool:
    """ Checks whether n is prime"""
    if n == 1:
        return False
    for i in range(2, int(floor(sqrt(n))+1)):
        if not n%i:
            return False
    return True
a = [c for c in range(1, 50000) if is_prime(c)]
def look_g(m, p, i):
    i2 = 0
    m2 = m+1
    
    

    
m = 21
p = 953
i = 3
for a in range(1000000, 0, -1):
    if is_prime(a):
        
