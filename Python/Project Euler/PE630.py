import time
start = time.perf_counter()
import mpmath
mpmath.mp.dps = 10
mpmath.mp.pretty = True
def pend(p1, p2):
    if p1[0] == p2[0]:
        return ["inf", None]
    aux = mpmath.fdiv(p1[1]-p2[1], p1[0]-p2[0])
    return [aux, p1[1]-aux*p1[0]]
Sn = 290797
n = 1
Pts = []
Tn = 0
while n < 5000:
    last = Tn
    Sn = pow(Sn, 2, 50515093)
    Tn = Sn%2000 - 1000
    if n%2 == 0:
        Pts.append((last, Tn))
    n+=1
lines = []
for idx in range(len(Pts)):
    print(idx)
    for l in range(idx+1, len(Pts)):
        res = pend(Pts[idx], Pts[l])
        if not (res in lines):
            lines.append(res)
print(time.perf_counter()-start)
