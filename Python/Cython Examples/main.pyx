def primes(int amount):
    cdef int x, found, nb
    cdef cant = 0
    cdef int primes[100000]

    amount = min(amount, 100000)

    found = 0
    nb = 2
    while found < amount:
        for x in primes[:found]:
            if nb % x == 0:
                break
        else:
            primes[found] = nb
            found +=1 

        nb+=1

    return [p for p in primes[:found]]
