#PE46
def prime(n):
    j = 2
    while j*j < n:
        if n%j == 0:
            return False
        j+=1
    return True

def test(n):
    j = 1
    while 2*j*j < n:
        if prime(n-2*j*j):
            return True
        j+=1
    return False

d = 3
while True:

    if prime(d):
        None
    else:
        if not test(d):
            print(d)
            break
    d+=2

    
