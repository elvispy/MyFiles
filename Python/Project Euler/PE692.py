#PE692
from time import perf_counter
from fibbo import fib
t = perf_counter()
fiblis = [fib(i) for i in range(1, 81)]
G_fi = [1, 1, 3, 6, 12, 23, 43]
j = len(G_fi)

while j < len(fiblis):
    G_fi.append(G_fi[-1] + G_fi[-2] + fiblis[j] - fiblis[j-2])
    j = len(G_fi)



res = G_fi[-1]# 23416728348467685 is a fibbonacci number!
# in fact, 23416728348467685 = fiblis[-1], the 80th fibbo number.
print("El resultado es: {}".format(res))
print("The time spent is: {}".format(perf_counter()-t))
