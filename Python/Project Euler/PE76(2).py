#PE76 version 2
#The idea is to create a class that represent a sum


class summ:
    def __init__(self, lis = (1,)):
        if type(lis) != type((0, )):
            raise Exception("Debe ser una tupla")
        while (lis[-1] == 0):
            lis = lis[:-1]
        if len(lis) == 0:
            raise Exception("Lista ingresada no valida")
        self.lis = lis
        self.sum = sum([self.lis[j]*(j+1) for j in range(len(self.lis))])


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
        for i in range(len(self.lis)):
            if self.lis[i]> 0:
                for j in range(self.lis[i]):
                    res = res + str(i+1) + "+"
        return res[:-1]


    def __hash__(self):
        lis = self.lis
        while (lis[-1] == 0):
            lis = lis[:-1]
        if len(lis) == 0:
            raise Exception("Lista ingresada no valida")
        return hash(lis)
        

    def gen(self):
        lol = self.lis + (0, )
        lol = lol[:-1]
        lol = (lol[0]+1,) + lol[1:]
        #print(lol)
        res = set([summ(lol)])
        
        for i in range(len(self.lis)):
            if self.lis[i]> 0:
                aux = self.lis + (0,)
                aux2 = aux[:i]
                aux2 = aux2 + (aux[i]-1, aux[i+1]+1) + aux[i+2:]
 
                aux2 = aux2 if aux2[-1] != 0 else aux2[:-1]
                res.add(summ(aux2))
        return res


def sums(n):
    if n < 2:
        raise Exception("lolazo")
    elif n == 2:
        return set([summ((2,))])
    elif n == 3:
        return set([summ((3,)), summ((2, 1))])
    elif n == 4:
        return set([summ((1, 0, 1)), summ((0, 2)), summ((2, 1)), summ((4,))])
    else:
        res = set()
        for s in sums(n-1):
            #print("Este es: ", s)
            res = res.union(s.gen())
        return res
a = summ((1, 2, 3, 4))
