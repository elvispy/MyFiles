import time
start = time.perf_counter()
class pot10:
    def __init__(self, two, five):
        self.two = two
        self.five = five

    def phi(self):
        if self.two > 0:
            self.two = self.two - 1

        if self.five > 0:
            self.five = self.five - 1
            self.two = self.two + 2

    def __repr__(self):
        return str(pow(2, self.two) * pow(5, self.five))

    def tonumber(self):
        return pow(2, self.two) * pow(5, self.five)


def darrow(a, k):
    aux = pot10(8, 8)
    auxs = []
    while aux.tonumber() > 1 and len(auxs) < k:
        auxs.append(aux.tonumber())
        aux.phi()

    res = 1
    for i in auxs[::-1]:
        res = pow(a, res, i)

    return res
        
print(darrow(1777, 1855))

print(time.perf_counter()-start)
