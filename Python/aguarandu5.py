
X = input("Ingrese la palabra a cambiar al plural: ")

vowels = ["a", "e", "i", "o", "u"]
sndrule = ["s", "x"]

if X[-1] in vowels:
    print(X+"s")
elif X[-1] in sndrule:
    print(X)
elif X[-1] == "z":
    print(X[:-1]+"ces")
else:
    print(X+"es")
