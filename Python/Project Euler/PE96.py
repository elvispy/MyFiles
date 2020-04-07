from time import perf_counter
a = perf_counter()
resf = 0 #the final result

with open("p096_sudoku.txt", "r") as file:
    content = file.read()
    
sudokus = content.split("Grid")[1:]
mysudo = [[1, 2, 3, 4, 5, 6, 7, 8, 9],
          [4, 5, 6, 7, 8, 9, 1, 2, 3],
          [7, 8, 9, 1, 2, 3, 4, 5, 6],
          [2, 3, 4, 5, 6, 7, 8, 9, 1],
          [5, 6, 7, 8, 9, 1, 2, 3, 4],
          [8, 9, 1, 2, 3, 4, 5, 6, 7],
          [3, 4, 5, 6, 7, 8, 9, 1, 2],
          [6, 7, 8, 9, 1, 2, 3, 4, 5],
          [9, 1, 2, 3, 4, 5, 6, 7, 0]]


def solve(sudo):
    """Solves the sudoku by backtracking"""
    global resf
    for i in range(9):
        for j in range(9):
            if sudo[i][j] == 0:
                for tri in range(1, 10):
                    if legal(sudo, i, j, tri):
                        sudo[i][j] = tri
                        solve(sudo)
                        sudo[i][j] = 0
                return None
    resf += sudo[0][0]*100 + sudo[0][1]*10 + sudo[0][2]  
    myprint(sudo)
    

def myprint(sudo):
    """Prints the sudoku"""
    for i in sudo:
        print(i)
        
def legal(sudo, i, j, new):
    """Returns true if its legal to put new un sudo at (i, j)"""
 
    for l in range(9):
        if sudo[l][j] == new:
            #print(1)
            return False    
        if sudo[i][l] == new:
            #print(2)
            return False
    auxj = j - j%3
    auxi = i - i%3
    for a in range(3):
        for b in range(3):
            if sudo[auxi + a][auxj + b] == new:
                return False
    return True

def str_to_l(s):
    res = []
    for i in s:
        res.append(int(i))
    return res

for i in range(len(sudokus)):
    sudokus[i] = sudokus[i].split("\n")[1:]
    sudokus[i] = sudokus[i][0:9]
    for j in range(9):
        sudokus[i][j] = str_to_l(sudokus[i][j])



for i in range(50):
    print("Solution: to problem {}".format(i+1))
    solve(sudokus[i])
    
print("Time spent:")
print(perf_counter()-a)
print("FINAL RESULT: {}".format(resf))
    
    

