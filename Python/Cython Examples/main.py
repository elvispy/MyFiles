def primes(amount):
    primes = []
    nb = 2
    cant = 0
    while cant < amount:
        for x in primes:
            if nb%x == 0:
                break
        else:
            primes.append(nb)
        
        nb+=1

    return primes