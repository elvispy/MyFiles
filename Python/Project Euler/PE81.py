with open("p081_matrix.txt") as f:
    data = f.read()
data = data.split("\n")
mat = []
for i in data:
    mat.append(i.split(","))
mat = mat[:-1]

for aux in range(159):
    for j in range(aux+1):
        i = aux-j
        if max(i, j)>79:
            continue
        mat[i][j] = int(mat[i][j])
        if i == j and j == 0:
            val = 0
        elif j == 0:
            val = mat[i-1][j]
        elif i == 0:
            val = mat[i][j-1]
        else:
            val = min(mat[i-1][j], mat[i][j-1])
        mat[i][j] = int(mat[i][j]) + val
