#PE587
import time
from math import sqrt
from math import asin
from math import pi
start = time.perf_counter()
def dist(p1, p2):
    return sqrt(pow((p1[0]-p2[0]), 2) + pow((p1[1]-p2[1]), 2))


def area(d1, d2, d3):
    S = d1/2 + d2/2 + d3/2
    return sqrt(S*(S-d1) * (S-d2) * (S-d3))


def perc(n):
    inter = [n * ((n+1)-sqrt(2*n))/(n*n+1), ((n+1)-sqrt(2*n))/(n*n+1) ]

    conc1 = dist(inter, [1, 0])
    conc2 = dist(inter, [0, 0])
    conc3 = 1
    triarea = area(conc1, conc2, conc3)
    triarea2 = area(conc1, 1, 1)
    totarea = triarea + triarea2
    B = 2* asin(conc1/2)
    circarea = B/2

    concarea = totarea-circarea
    Lsec = (4-pi)/4
    return concarea/Lsec

s = 15
while perc(s) >= 0.001:
    s+=1
print(s)
print(time.perf_counter()-start)
