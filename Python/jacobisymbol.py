def legendre(n, m):
    '''Tries to calculate Legendre Symbol'''
    j = 1
 
    # rule 5
    n %= m
     
    while n:
        # rules 3 and 4
        t = 0
        while not int(n) & 1:
            n /= 2
            t += 1
        if t&1 and m%8 in (3, 5):
            j = -j
 
        # rule 6
        if (n % 4 == m % 4 == 3):
            j = -j
 
        # rules 5 and 6
        n, m = m % n, n
 
    return j if m == 1 else 0
