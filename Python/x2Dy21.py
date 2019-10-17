from math import sqrt
def min_x(D):
    """Finding minimal solution in x for x^2-Dy^2 = 1"""
    
    y = 1

    while True:
        if int(sqrt(1+D*y*y)) == sqrt(1+D*y*y):
            return sqrt(1+D*y*y)
        y += 1;
            
        
        
    
