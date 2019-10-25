


#Creating a class of rational numbers to compute the sums and the inverses
class rationale:
    def __init__(self, num, den):
        self.num = num
        self.den = den

    def __add__(self, other):
        return rationale((self.num*other.den+self.den*other.num), self.den*other.den)

    def __repr__(self):
        return "{}/{}".format(self.num, self.den)
    def inverse(self):
        if self.num == 0:
            return rationale(0, 1)
        return rationale(self.den, self.num)
#end class definition


#The 100th continued fraction
n_a = 100
    
#Eapp, approximations of e
eapp = [2, 1] + [int(2*i/3) if not i%3 else 1 for i in range(3, n_a+1)]

frac = rationale(eapp.pop(), 1)

for j in eapp[::-1]:
    frac = rationale(j, 1) + frac.inverse()
print(frac)
    

