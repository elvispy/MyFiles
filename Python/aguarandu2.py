X = int(input("Ingrese la mayor cantidad de personas que pueden esperar en el primer tipo de consulta: "))
Y = int(input("Ingrese la mayor cantidad de personas que pueden esperar en el segundo tipo de consulta: "))

A = int(input("Ingrese la cantidad de personas que estan esperando por consultas varias: "))
B = int(input("Ingrese la cantidad de personas que estan esperando por compras de equipos: "))

lol = True if X<Y else False
while (A>0) and (B>0):
    if lol:
        if A>=X:
            print("Deben pasar {} personas de consultas varias".format(X))
        else:
            print("Deben pasar {} personas de consultas varias".format(A))
        A  = A-X if A>=X else 0
        lol = False
    else:
        if B>=Y:
            print("Deben pasar {} personas de compra de equipos".format(Y))
        else:
            print("Deben pasar {} personas de compra de equipos".format(B))
        B  = B-Y if B>=Y else 0
        lol = True
if (B>0):
    print("Ya no quedan personas del otro tipo de consultas. Pasaran las {} personas restantes para compra de equipos".format(B))
elif A>0:
   print("Ya no quedan personas del otro tipo de consultas. Pasaran las {} personas restantes para consultas varias".format(A)) 
    
