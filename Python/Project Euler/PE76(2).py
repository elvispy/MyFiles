#PE76 version 2
#The idea is to create a class that represent a sum


class summ:
    def __init__(self, lis = [1]):
        while (lis[-1] == 0):
            lis = lis[:-1]
        if len(lis) == 0:
            raise Exception("Lista ingresada no valida")
        self.lis = lis


    def __eq__(self, other):
        lis = self.lis
        while (lis[-1] == 0):
            lis = lis[:-1]
        if len(lis) == 0:
            raise Exception("Lista ingresada no valida")
        lis2 = other.lis
        while (lis2[-1] == 0):
            lis2 = lis2[:-1]
        if len(lis2) == 0:
            raise Exception("Lista ingresada no valida")
        return lis == lis2


    def __repr__(self):
        res = ""
        for val in self.lis:
            if val > 0:
                res += str(val) + "+"
        return res[:-1]        

    def gen(self):
        lol = self.lis + [0]
        lol = lol[:-1]
        lol[0] += 1
        res = [summ(lol)]
        for i in range(len(self.lis)):
            if aux[i] > 0:
                aux = self.lis + [0]
                aux[i] -= 1
                aux[i+1] +=1
                aux = aux if aux[-1] != 0 else aux[:-1]
                res.append(summ(aux))
