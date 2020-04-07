
def is_prime(number):
    if number == 1:
        return False
    cot = int(pow(number+1, 1/2))
    c = 2
    while c< cot:
        if not number%c:
            return False
        c+=1
    return True
