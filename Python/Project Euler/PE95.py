#PE95

import time
val = time.perf_counter()
def n_div(n):
    if n == 1:
        return 1
    div = 0
    mx = int(n/2)+2
    c = 1
    while c<mx:
        if not n%c:
            mx = max(int(n/c), c)
            div += c
            div = div + int(n/c) if c>1 else div
        c+=1
    return div
            
    
candidates = list(range(2, 1000001))
mc = 5
mcs = 12496
perfect = [1, 6, 28, 496, 8128]
for n in candidates:
    failed = False
    if n == None:
        continue
    chain = [n]
    lol = n_div(n)
    while lol != n:
        if lol < 1000000 and lol>1:
            candidates[lol-2] = None
        else:
            failed = True
            break
        if chain.count(lol) > 0:
            failed = True
            break
        else:
            chain.append(lol)
    
        lol = n_div(lol)
    if len(chain) > mc and not failed:
        mc = len(chain)
        mcs = n
    
    
print(time.perf_counter()-val)
