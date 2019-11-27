#PE80(2)
import math
from mpmath import *
mp.dps = 101
mp.pretty = True
sums = []
for i in range(1, 101):
    if i in [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]:
        sums.append(0)
        continue
    chute = findroot(lambda x: x*x - i, math.sqrt(i))
    chute = str(chute)
    chute = chute[:101]
    chute = chute.replace(".", "")
    sums.append(sum([int(ch) for ch in chute]))
    
