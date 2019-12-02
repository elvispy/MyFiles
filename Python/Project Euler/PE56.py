import time
start =time.perf_counter()

def dsum(n):
    return sum([int(i) for i in str(int(n))])
maxx = 1
for a in range(1, 100):
    for b in range(1, 100):
        aux = dsum(pow(a, b))
        if aux > maxx:
            maxx = aux

print(maxx)
print(time.perf_counter()-start)
