import time
start = time.perf_counter()
with open("p022_names.txt", "r") as f:
    content = f.read()
words = content.split(",")
words = [word.strip("\"") for word in words]
words.sort()
s = 0

def toascii(w):
    return sum([ord(l.lower())-96 for l in w])

for c in range(len(words)):
    s+= (c+1) * toascii(words[c])

print(s)
print(time.perf_counter()-start)
