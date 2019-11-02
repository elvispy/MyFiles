import time
start = time.perf_counter()

def replace(st, idx, nw):
    return st[:idx] + nw + st[(idx+1):]

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

right = ["2", "3", "5", "7"]
left = ["2", "3", "5", "7"]
digits = ["1", "2", "3", "5", "7", "9"]
valid = []
while  len(valid) < 11:
    print("---------------")
    print(len(right[0]))
    print("---------------")
    aux1 = []
    aux2 = []
    for tp in right:
        for digit in digits:
            if is_prime(tp + digit):
                aux1.append(tp + digit)

    for tp in left:
        for digit in digits:
            if is_prime(digit + tp):
                aux2.append(digit + tp)

    valid = valid + list(set(aux1).intersection(set(aux2)))
    right = aux1
    left = aux2
##trunc = [37, 73, 313, 317, 373, 797, 3137, 3797, 739397]
##c = candidates("3339933")
##while len(trunc) < 11:
##    while c.char[0] == "1" or c.char[-1] == "1":
##        c.add()
##    if all([is_prime(c.num%pow(10, i)) for i in range(1, len(c.char)+1)]) and all([is_prime(int(c.num/pow(10, i-1))) for i in range(1, len(c.char)+1)]):
##        trunc.append(c.num)
##
##    c.add()
##    
##    

        


print(time.perf_counter()-start)
            
