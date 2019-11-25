from PE113 import ncr

def count(i):
    s = 0
    for  j in range(i+1):
        if ncr(i, j)%7 == 0:
            print(j)
            s+=1
    return s
