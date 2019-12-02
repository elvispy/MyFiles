#PE85
mylist = [i*(i+1)/2 for i in range(1, 1500)]

mc = 10_000_000
for j in range(len(mylist)):
    aux1 = [abs(2000000-mylist[j]*i) for i in mylist]
    aux = min(aux1)
    if aux < mc:
        res = [mylist[j], mylist[aux1.index(aux)]]
        mc = aux
    mylist[j] = 0
