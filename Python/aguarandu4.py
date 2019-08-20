X = int(input("Ingrese la cantidad de frases a codificar: "))
while not(X in range(1,101)):
    print("La cantidad debe estar entre 1 y 100 inclusive.")
    X = int(input("Ingrese la cantidad de frases a codificar: "))
          
from string import ascii_lowercase as abece
abece = abece[:14] + "ñ" + abece[14:]
allowed = abece + " "
frases = []
i = 1
while i <= X:
    posf = input("Ingrese una frase: ")
    if all([val.lower() in allowed for val in posf]):
        frases.append(posf)
        i += 1
    else:
        print("Usted tiene un caracter que no deberia estar en la frase")

abece = abece + "abcde"
codif = [""] *X
for j in range(X):
    for letter in frases[j]:
        if letter == " ":
            codif[j] += " "
        else:
            if letter.isupper():
                codif[j] += abece[abece.index(letter.lower())+5].upper()
            else:
                codif[j] += abece[abece.index(letter)+5]

print("Sigue la lista de mensajes codificados:")
for val in codif:
    print(val)
