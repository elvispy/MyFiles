import math
def is_prime(n):
    """Return True if n is a prime number, False otherwise."""
    if n < 2:
        return False
    return all(n % i for i in range(2, int(math.sqrt(n)) + 1))

def get_prime_factors(n):
    """Return the prime factorisation of n in sorted order."""
    prime_factors = {}
    d = 2
    if is_prime(n):
        return {n:1}
    while d * d <= n:
        while n % d == 0 and is_prime(d):
            n //= d
            if d in prime_factors.keys():
                prime_factors[d] += 1
            else:
                prime_factors.update({d:1})
        d += 1
    if n > 1:  # to avoid 1 as a factor
        assert d <= n
        prime_factors.update({n:1})
    return prime_factors

def number_of_divisors(n):
    """Get the number of divisors of a positive integer"""

    dic = get_prime_factors(n)
    #print(dic)

    return int(math.exp(sum([math.log(i+1) for i in list(dic.values())])))

def perms(s):
    res = []
    if len(s) == 1:
        return [s]
    else:
        a = s[0]
        s = s[1:]
        aux = perms(s)
        for val in aux:
            val = str(val)
            for i in range(len(val)+1):
                res.append(val[:i] + a + val[i:])
        return list(set([int(j)  for j in res ]))
        

a = [False if i< 999 else (is_prime(i)) for i in range(0, 10000)]
#a[1487] = False


for k in range(1000, 10000):
    if a[k]:
        tentativas = perms(str(k))
        tentativas.sort()
        tent2 = []
        for l in tentativas:
            if a[l]:
                tent2.append(l)
        tent2.sort()
        if len(tent2) > 2:
            #print("probanding")
            val1 = 0
            val2 = 1
            val3 = 2
            while val1 <= len(tent2)-3:
                #print("hum", tent2)
                if ( abs(tent2[val1]-tent2[val2]) ==
                     abs(tent2[val2]-tent2[val3])):
                    print(tent2[val1], tent2[val2], tent2[val3])
                    a[tent2[val1]] = False
                    a[tent2[val2]] = False
                    a[tent2[val3]] = False
                    
                val3 +=1
                if val3 == len(tent2):
                    val2+=1
                    val3 = val2 + 1
                if val2 == len(tent2) - 1:
                    val1 += 1
                    val2 = val1 + 1
                    val3 = val2 + 1
                
    #print(k)
                    
                
