numbers = []

def powers(n: int) -> bool:
    n = str(n)

    s = 0

    for i in range(len(n)):
        s+= pow(int(n[i]), 5)

        if s> int(n):
            return False

    if s<int(n):
        return False

    return True


cota = 1000000

for i in range(cota):
    if powers(i):
        numbers.append(i)


print(sum(numbers))
