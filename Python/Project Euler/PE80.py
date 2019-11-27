#PE80

class number:
    """This will try to replicate the structure of a number
    without having to lose decimal precision"""
    
    def __init__(self, bd, ad):
        self.befored = bd
        self.afterd = ad

    def __repr__(self):
        first = ""
        for ch in self.befored:
            first = first + str(ch)
        last = ""
        for ch in self.afterd:
            last = last + str(ch)

        return "{}.{}".format(first, last)

    def __add__(self, other):
        l1 = self.afterd
        l2 = other.afterd
        if len(l1) < len(l2):
            m = l1
            g = l2
        else:
            m = l2
            g = l1
        while len(m) < len(g):
            m = m + [0]
        decplaces = len(m)

        l1 = self.befored + self.afterd   if self.afterd == g  else self.befored + m
        l2 = other.befored + other.afterd if other.afterd == g else other.befored + m
        if len(l1) < len(l2):
            m = l1
            g = l2
        else:
            m = l2
            g = l1
        while len(m) < len(g):
            m = [0] + m 
        res = []
        residual = 0
        for i in range(1, len(m)+1):
            carry = m[-i] + g[-i] + residual
            residual  = int((carry - carry %10)/10)
            res = [carry%10] + res
        res = res if residual == 0 else [residual] + res
        bd = res[:-decplaces]
        ad = res[-decplaces:]
        return number(bd, ad)

    def shift(self):
        bd = [0] + self.befored
        ad = self.afterd
        ad = [bd[-1]] + ad
        bd = bd[:-1]
        return number(bd, ad)

    def __mul__(self, other):
        decplaces = len(other.afterd)
        num = ""
        for i in other.befored:
            num = num + str(i)
        num = int(num)
        ad = ""
        for i in other.afterd:
            ad = ad + str(i)
        ad = int(ad)
        res1 = number([0], [0])
        for i in range(num):
            res1 = res1 + self
        res2 = number([0], [0])
        for i in range(ad):
            res2 = res2 + self
        for j in range(decplaces):
            res2 = res2.shift()
        return res1 + res2
   
        

for q in range(1, 101):
    break
