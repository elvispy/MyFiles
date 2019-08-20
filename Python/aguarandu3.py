from string import ascii_lowercase as abece
abece = abece + " "
print("Bienvenido al juego de los palindromos!")

while True:
    
    allowed = []
    print("Ingrese las letras permitidas para este turno (cualquier cosa que no es una letra dara por finalizado el ingreso de letras): ")
    x = input("")
    while len(x) == 1 and (x.lower() in abece):
        
        if x in allowed:
            print("Usted ya ingreso ese caracter. No se tomaran medidas al respecto")
        else:
            allowed.append(x)
        x = input("")
    print("Ahora ingrese la frase (mayusculas importan): ")
    phrase = input("")
    won = True
    if all([(val in allowed) for val in phrase]):
        #if true means the phrase is allowed
        for i in range(len(phrase)):
            if i > len(phrase)/2+1:
                break
            if phrase[i] != phrase[-i-1]:
                won = False
    else:
        print("La palabra no sigue las reglas establecidas previamente")
        won = False
        
    if won:
        print("El jugador ha ganado!")
    else:
        print("EL jugador ha perdido!")

    print("Desean jugar otra vez? (Ingrese 1 si es asi)")
    if input("") != "1":
        break

    
            
        
