def collatz(x: int):
    c = 1
    while x != 1:
        print(x)
        if x % 2 > 0:
             x =((3 * x) + 1)
        else:
            x = (x / 2)

        c+=1

    return c
    

maxx = 0

for i in range(1,1000000):

    var = collatz(i)
    if var > maxx:
        maxx = var
        print(i)
    
