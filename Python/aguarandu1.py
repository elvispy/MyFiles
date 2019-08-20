from math import floor

lis = []

while True:
    print(lis)
    x = int(input("Ingrese una cantidad de monedas en la pila (24 es la ultima): "))
    if x == 24:
        lis.append(x)
        break
    if x in lis:
        print("Ese elemento ya lo habias ingresado antes!")
        
    if not(x in range(2,31)):
        print("Debe estar en el rango establecido!(2 a 30 inclusive)")
    if x in range(2,31) and not(x in lis):
        lis.append(x)

lis.sort()


print("El orden de los elementos ordenados es :")
for y in lis:
    if y == lis[-1]:
        print(y)
    else:
        print(y, end = ', ')

maxx = lis[-1]

res  = sum([maxx - i for i in lis])

print("Hacen falta {} monedas para que todas las pilas tengan {} monedas".format(res, maxx))

           
        
