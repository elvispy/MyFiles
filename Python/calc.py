def add(x,y):
    """This adds the numbers"""
    return x + y

def multiply(x,y):
    """This multiply the arguments"""
    return x * y

def quotient(x,y):
    """This divides the arguments"""
    try:
        return x/y
    except Exception:
        raise ZeroDivisionError
