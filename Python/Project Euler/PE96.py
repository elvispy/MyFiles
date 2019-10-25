with open("p096_sudoku.txt", "r") as file:
    content = file.read()
    
sudokus = content.split("Grid")[1:]

def coor(i, j):
    return []

for i in range(len(sudokus)):
    sudokus[i] = sudokus[i].split("\n")[1:]
resp = []

for sudoku in sudokus:
    n_allowed = [[[]]*9] * 9
    
    while '0' in sudoku[0][0:3]:
        checkpoint = False
        for i in range(9):
            for j in range(9):
                if sudoku[i][j] == '0':
                    for row in range(9):
                        if sudoku[row][j] != '0':
                            n_allowed[i][j].append(int(sudoku[row][j]))
                            checkpoint = True
                    for col in range(9):
                        if sudoku[i][col] != '0':
                            n_allowed[i][j].append(int(sudoku[i][col]))
                            checkpoint = True

                    for i1, j1 in coor(i, j):
                        if sudoku[i1][j1] != '0':
                            n_allowed[i][j].append(int(sudoku[i1][j1]))
                            #checkpoint = True

                if len(n_allowed[i][j]) == 8:
                    sudoku[i] = sudoku[i][0:j] + [str(i) for i in range(1, 10) if not str(i) in n_allowed][0] + sudoku[(j+1):]

        if checkpoint == False:
            break
        else:
            print("Lol")
    resp.append(sudoku)
