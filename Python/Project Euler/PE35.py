def rotation(n):
    a = str(n)
    return [int(a[i:] + a[:i]) for i in range(len(a))]
def is_prime(n):
    """
    Assumes that n is a positive natural number
    """
    n = int(n)
    # We know 1 is not a prime number
    if n <= 1:
        return False

    i = 2
    # This will loop from 2 to int(sqrt(x))
    while i*i <= n:
        # Check if i divides x without leaving a remainder
        if n % i == 0:
            # This means that n has a factor in between 2 and sqrt(n)
            # So it is not a prime number
            return False
        i += 1
    # If we did not find any factor in the above loop,
    # then n is a prime number
    return True

lol = []
for j in range(1, 1000000):
    if all([is_prime(i) for i in rotation(j) ]):
        lol.append(j)
    
