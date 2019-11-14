A = [[False] * 80] * 80
A[0][0] = True
B = [[0] * 80] * 80
F = [[None] * 80] * 80
def sett(i, j):
    global A
    global B
    global F
    global mat
    try:
        a1 = B[i-1][j]
    except:
        a1 = 0
    try:
        a2 = B[i+1][j]
    except:
        a2 = 0
    try:
        a3 = B[i][j-1]
    except:
        a3 = 0
    try:
        a4 = B[i][j+1]
    except:
        a4 = 0

    m = 0
    lol = [a1, a2, a3, a4]
    mm = min([i for i in lol if i > 0])
    for i in range(4):
        if lol[i] == mm:
            m = i+1
            break

    A[i][j] = True
    B[i][j] = lol[m-1] + int(mat[i][j])
    if m == 1:
        F[i][j] = (-1, 0)
    elif m == 2:
        F[i][j] = (1, 0)
    elif m == 3:
        F[i][j] = (0, -1)
    elif m == 4:
        F[i][j] = (0, 1)

    layer = [(0, 1), (1, 0)]
    while len(layer) > 0:
        layers2 = []
        for cell in layer:
             

        


with open("p083_matrix.txt") as f:
    data = f.read()
data = data.split("\n")
mat = []
for i in data[:-1]:
    mat.append(i.split(","))
B[0][0] = int(mat[0][0])
B[1][0] = int(mat[0][0]) + int(mat[1][0])
B[0][1] = int(mat[0][0]) + int(mat[0][1])
F[0][1] = (-1,  0)
F[1][0] = ( 0, -1)
A[0][1] = True
A[1][0] = True
while A[-1][-1] == False:
    for i in range(80):
        for j in range(80):
            if A[i][j] == False:
                sett(i, j)
    
