def lychrel(n):
    n = str(n)
    aux = str(int(n) + int(n[::-1]))
    for i in range(1, 51):
        if all([aux[i] == aux[len(aux)-1-i] for i in range(0, int(len(aux)/2)+1)]):
               return True
        aux = str(int(aux) + int(aux[::-1]))
    return False
