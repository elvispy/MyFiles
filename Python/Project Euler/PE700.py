#PE700
from time import perf_counter
t = perf_counter()

inversecalc = lambda a:pow(a, 4503599627370515, 4503599627370517)    

ec = 1504170715041707 #euler coin
mycon = ec
mod = 4503599627370517
summ = ec #sum of all
last = ec #last eulercoin
ecinv = inversecalc(ec)
while ec >1:
    ec = (ec + mycon)%mod
    if ec < last:
        last = ec
        summ += ec
        print(last)
    if last < 16_000_000:
        break
    
summ+=1
n = ecinv
for i in range(2, last):
    candidate = pow(i*ecinv, 1, mod)
    if candidate < n:
        n = candidate
        summ+=i

print("El resultado es: {}".format(summ))
print("The time spent is: {}".format(perf_counter()-t))
