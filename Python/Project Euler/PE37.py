import time
start = time.perf_counter()

def replace(st, idx, nw):
    return st[:idx] + nw + st[(idx+1):]

def is_prime(n):
    if n<2:
        return False
    return all([n%i for i in range(2, int(n/2)+1)])

class candidates():

    def act(self):
        self.num = int(self.char)
    
    def __init__(self, char):
        self.char = char
        self.act()

    def add(self):
        lleva = True
        idx = -1
        while lleva:
            if idx == -len(self.char)-1:
                self.char = "1" + self.char
                break
            else:
                lleva = False
                if self.char[idx] == "1":
                    self.char = replace(self.char, len(self.char) + idx, "3")
                elif self.char[idx] == "3":
                    self.char = replace(self.char, len(self.char) + idx, "7")
                elif self.char[idx] == "7":
                    self.char = replace(self.char, len(self.char) + idx, "9")
                elif self.char[idx] == "9":
                    self.char = replace(self.char, len(self.char) + idx, "1")
                    lleva = True
            idx -= 1

        self.act()

trunc = [37, 73, 313, 317, 373, 797, 3137, 3797, 739397]
c = candidates("3339933")
while len(trunc) < 11:
    while c.char[0] == "1" or c.char[-1] == "1":
        c.add()
    if all([is_prime(c.num%pow(10, i)) for i in range(1, len(c.char)+1)]) and all([is_prime(int(c.num/pow(10, i-1))) for i in range(1, len(c.char)+1)]):
        trunc.append(c.num)

    c.add()
    
    

        


print(time.perf_counter()-start)
            
