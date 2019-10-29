import time
start = time.perf_counter()
primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37,
     41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

def num2lst(n):
    b = [0]*25
    for i in range(len(primes)):
        while not n%primes[i]:
            n = int(n/primes[i])
            b[i]+=1
        if n == 1:
            break
    return b

def mult(lst, n):
    return [i*n for i in lst]

lst = []
control = 100
for a in range(2, control+1):
    a = num2lst(a)
    for b in range(2, control+1):
        aux = mult(a, b)
        if not(aux in lst):
            lst.append(aux)

print(len(lst))
print(time.perf_counter()-start)
