#PE82

with open("p082_matrix.txt") as f:
    content = f.read()

rows = content.split("\n")[:-1]
data = [row.split(",") for row in rows]

