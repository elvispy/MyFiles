from PCprimes import primes1 as PC
import time
start = time.perf_counter()
squares = PC(7072)
cubes = PC(int(pow(50_000_000, 1/3))+1)
fourth = PC(85)

def lst2num(lst):
    return [int(pow(ls[0], 2) + pow(ls[1], 3) + pow(ls[2], 4)) for ls in lst]

def square(n):
    return [i for i in squares if i*i < n]

def cube(n):
    aux = [i for  i in cubes if i*i*i < n]
    res = []
    for i in aux:
        res = res + [[a, i] for a in square(n-i*i*i)]

    return res

def fourths(n):
    aux = [i for i in fourth if pow(i, 4) < n]

    res = []

    for i in aux:
        res = res + [ a + [i] for a in cube(n-i*i*i*i)]


    return res

res = fourths(50_000_000)
res = lst2num(res)
print(len(set(res)))
print(time.perf_counter()-start)
