def bouncy(n: str) -> bool:
    """Check whether a number is bouncy"""
    n = str(n)
    if int(n)<100:
        return False
    known = False
    up = False
    first = True
    for char in n:
        if first:
            first = False
        else:
            if known == False:
                if char < aux:
                    known = True
                    up = False
                elif char > aux:
                    known = True
                    up = True
                else:
                    known = False
            else:
                if up and char < aux:
                    return True
                elif (not up) and char > aux:
                    return True

        aux = char

    return False
        
def first_p(p: float) -> int:
    """Returns the first number to have that proportion"""
    nm = 0
    a = 101
    while True:
        
        if bouncy(a):
            nm +=1

        if (nm/a == p):
            return a

        a+=1
