import time
start = time.perf_counter()
from math import sqrt, ceil
def abb(n):
    if n == 0:
        return False
    s = 1
    for i in range(2, ceil(sqrt(n))):
        if not n%i:
            if i*i == n:
                s+=i
            else:
                s = s + i + int(n/i)
    return s > n

candidate = 28123
cannot = []
abbs = [i for i in range(1, 28120) if abb(i)]
abbs.sort()
print("Finished")
while candidate > 0:
    
    can = False
    aux = ceil(candidate/2)+1
    for i in abbs:
        if i> aux:
            break
        if abb(candidate-i):
            can = True
            break
    if can == False:
        cannot.append(candidate)
    candidate -= 1
print(sum(cannot))
print(time.perf_counter() - start)
