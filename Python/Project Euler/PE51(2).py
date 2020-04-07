#PE51
from time import perf_counter
t = perf_counter()

with open("pprimes.txt", "r") as f:
    data = f.read()
data = data.split("\n")
dig = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
data2 = [p for p in data if max([p[:-1].count(i) for i in dig]) == 3]
data3 = [[], [], [], []]
for i in data2:
    if len(i) > 4:
        data3[len(i)-5].append(i)



print("El resultado es: {}".format(1))
print("The time spent is: {}".format(perf_counter()-t))
