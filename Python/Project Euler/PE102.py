import time
start = time.perf_counter()

with open("p102_triangles.txt") as f:
    content = f.read()
triangles = content.split("\n")
coordinates = []
for triangle in triangles:
    coordinates.append(triangle.split(","))
coordinates = coordinates[:-1]
def rotate(coor):
    return coor[2:] + coor[:2]

def determinant(M):
    return M[0][0]*M[1][1]-M[0][1]*M[1][0]

def area(coor):
    res = True
    M = [[int(coor[2])-int(coor[0]) ,int(coor[4]) - int(coor[2]) ] ,
         [int(coor[3])-int(coor[1]) , int(coor[5])-int(coor[3]) ]]
    val = determinant(M)
    if val == 0:
        raise Exception("Colineales")
    return True if val >0 else False


def cont_origin(coor):
    aux = coor[:2] + [0, 0] + coor[4:]

    if area(coor) == area(aux):
        coor = rotate(coor)

        aux = coor[:2] + [0, 0] + coor[4:]
        if area(coor) == area(aux):
            coor = rotate(coor)
            aux = coor[:2] + [0, 0] + coor[4:]
            if area(coor) == area(aux):
                return True
    return False

s = 0
for coor in coordinates:
    if cont_origin(coor):
        s+=1

print(s)
print("Running time: ", time.perf_counter()-start)
