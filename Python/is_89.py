def at_89(n: int, aux89 = [], aux1 = []) -> bool:
    local_aux = [n]
    n = str(n)
    
    while True:
        if n == "1" or int(n) in aux1:
            return [False, list(set(local_aux + aux1))]

        if n == "89" or int(n) in aux89:
            return [True, list(set(local_aux + aux89))]
        
        n = str(sum([int(i)*int(i) for i in n]))
        local_aux.append(int(n))

