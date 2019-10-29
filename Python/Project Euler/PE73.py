from math import floor
import time
start = time.perf_counter()
def gcd(a, b):
    while True:
        a, b = max(a, b)%min(a, b), min(a, b)
        if min(a, b) == 0:
            return max(a, b)
        if not max(a, b)%min(a, b):
            return min(a, b)


num = 0
for i in range(2, 9):
    tent = floor(i/3)
    while 2*tent < i:
        if 3*tent> i and gcd(tent, i) == 1:
            num+=1
        tent+=1

print(num)
print(time.perf_counter()-start)
            
            
