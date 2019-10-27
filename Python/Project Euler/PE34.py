import time
init = time.perf_counter()

def fact(n):
    if n<0:
        return 0
    if int(n) in [0, 1]:
        return 1
    elif n == 2:
        return 2
    elif n == 3:
        return 6
    elif n == 4:
        return 24
    elif n == 5:
        return 120
    else:
        return n * fact(n-1)


is_special = lambda x: sum([fact(int(i)) for i in str(x)]) == x

print(sum([n for n in range(10, 2700000) if is_special(n)]))

print(time.perf_counter() - init)
