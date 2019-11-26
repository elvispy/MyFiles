#PE31
import time
start = time.perf_counter()
def p2_1(n):
    if n == 0:
        return 0
    n = n-n%2
    return int(n/2)+1

def p5(n):
    if n == 0:
        return 0
    return sum([(p2_1(n-5*j) if n-5*j > 0 else 1) for j in range(int((n-n%5)/5)+1)])

def p10(n):
    if n == 0:
        return 0
    return sum([(p5(n-10*j) if n-10*j > 0 else 1) for j in range(int((n-n%10)/10)+1)])

def p20(n):
    if n == 0:
        return 0
    return sum([(p10(n-20*j) if n-20*j > 0 else 1) for j in range(int((n-n%20)/20)+1)])

def p50(n):
    if n == 0:
        return 0

    return sum([(p20(n-50*j) if n-50*j > 0 else 1) for j in range(int((n-n%50)/50)+1)])

def p(n):
    if n == 0:
        return 0

    return sum([(p50(n-100*j) if n-100*j > 0 else 1) for j in range(int((n-n%100)/100)+1)])

print(p(200) +1) #+1 since we need to count the distribution with one coin of 200p
print(time.perf_counter()-start)
