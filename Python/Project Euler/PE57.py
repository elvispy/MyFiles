#PE57
import time
from PE65 import rationale

start = time.perf_counter()

#The 1000th continued fraction

#Approximations of sqrt(2)

def approx(n):
    tapp =[1] + [2] * n

    frac = rationale(tapp.pop(), 1)

    for j in tapp[::-1]:
        frac = rationale(j, 1) + frac.inverse()

    return frac

c = 1

if __name__ == '__main__':
    
    for i in range(1, 1001):
        appi = approx(i)

        if len(str(appi.num)) > len(str(appi.den)):
            c+=1

print(c)
print(time.perf_counter()-start)
