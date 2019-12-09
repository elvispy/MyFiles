import time
start = time.perf_counter()


def R(k, a):
    """Returns the number  of ways that k can be expressed as a sum of
    positive integers such that they are not greater than a
    k and a should be positive integers."""
    if a < 1:
        raise Exception
    if k == 1:
        return 1

    if a == 1:
        return 1
    elif a == 2:
        return 1+int(k/2)
    return sum([R(k-i, i) for i in range(1, min(a, k-1)+1)])


def F(s):
    return sum([R(s-i, i) for i in range(1, s)])


print(F(5))
print(time.perf_counter()-start)
