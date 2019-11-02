f = 3/7
frac = [0, 1]
from math import floor
close = 0
for i in range(1, 1000001):
    can1 = [floor(i*3/7), i]
    can2 = [floor(i*3/7)+1, i]
    if f-can1[0]/can1[1] < f-frac[0]/frac[1] and can1[0]/can1[1] <f:
        frac = can1
    elif f-can2[0]/can2[1] < f-frac[0]/frac[1] and can2[0]/can2[1] <f:
        frac = can2

print(frac)
    
