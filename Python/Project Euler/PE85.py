#PE85
def tri_to_num(n):
    '''Dado el numero triangular n,
    devuelve el numero que da como resultado n'''
    j = 8*n+1
    j = pow(j, 1/2)
    j-=1
    j/=2
    return int(j)
    
    
mylist = [i*(i+1)/2 for i in range(1, 1500)]

mc = 10_000_000
for j in range(len(mylist)):
    aux1 = [abs(2000000-mylist[j]*i) for i in mylist] 
    aux = min(aux1) #calculate the minimum
    if aux < mc: #si hay un resultado menor, guardarlo
        res = [tri_to_num(mylist[j]), tri_to_num(mylist[aux1.index(aux)])]
        mc = aux
    mylist[j] = 0

print("El resultado es: {}".format(int(res[0]*res[1])))
