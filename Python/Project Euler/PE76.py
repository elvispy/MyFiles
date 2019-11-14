def R(k, l):
    if l<1:
        raise Exception
    if k == 1:
        return 1
    
    if l==1:
        return 1
    return sum([R(k-i, i) for i in range(1, min(l, k-1)+1)])

F = lambda s: sum([R(s-i, i) for i in range(1, s)])
