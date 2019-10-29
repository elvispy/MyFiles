from math import sqrt
def m(D):
    if int(sqrt(D)) == sqrt(D):
        return None
    x = 1
    while True:
        x+=1
        if pow(x, 2, D) != 1:
            continue
        aux = (x*x-1)/D
        if int(sqrt(aux))*int(sqrt(aux)) == aux:
            return x

