#PE51
from time import perf_counter
t = perf_counter()

with open("p082_matrix.txt") as f:
    data = f.read()
data = data.split("\n")
mat = []
for i in data:
    mat.append(i.split(","))
mat = mat[:-1]

res = 0
print("El resultado es: {}".format(res))
print("The time spent is: {}".format(perf_counter()-t))
