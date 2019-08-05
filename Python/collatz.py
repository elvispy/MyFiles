def collatz(x):
    list_ = []
    while x != 1:
        if x % 2 > 0:
             x =((3 * x) + 1)
             list_.append(x)
        else:
            x = (x / 2)
            list_.append(x)
    return len(list_)
