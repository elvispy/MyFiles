import time
start = time.perf_counter()
def R(k, l):
    """Returns the number  of ways that k can be expressed as a sum of
    positive integers such that they are not greater than l
    k and l should be positive integers."""
    if l<1:
        raise Exception
    if k == 1:
        return 1

    if l == 1:
        return 1
    elif l == 2:
        return 1+int(k/2)
    return sum([R(k-i, i) for i in range(1, min(l, k-1)+1)])

F = lambda s: sum([R(s-i, i) for i in range(1, s)])

print(F(5))
print(time.perf_counter()-start)
