#PE27
import time
start = time.perf_counter()
def is_prime(n):
    if n<2:
        return False
    return all([n%i for i in range(2, int(n/2)+1)])

bs = [n for n in range(3, 1000) if is_prime(n)]

mx = 40
coef = [1, 41]
for b in bs:
    print(b)
    if b<mx:
        continue
    aas = range(-(b+2 if b%2 else b+1), 1000, 2)
    for a in aas:
        pol = lambda n: n*n +a*n + b
        candidate = True
        for i in range(mx, 0, -1):
            if not is_prime(pol(i)):
                candidate = False
                break
        if candidate:
            coef = [a, b]
            mx+=1
            while is_prime(pol(mx)):
                mx+=1
            


                
                
            
print(time.perf_counter()-start)
