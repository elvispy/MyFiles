def per(lst: list):
    val = len(lst)
    """gives all the permutations of a given list"""
    lst = list(lst)
    if len(lst) == 1:
        return lst
    elif len(lst) == 2:
        return [lst[0] +lst[1], lst[1] + lst[0]]
    
    aux = lst[0]
    a = per(lst[1:])
    res = []
    for i in a:
        for j in range(len(i)+1):
            res.append(i[:j] + aux + i[j:])
    return res
            

def main():
    res = []
    digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    d6 = ['0', '5']
    dp = ['0', '2', '4', '6', '8']
    for v1 in dp:
        for v2 in set(d6) - set(v1):
            for num in per(set(digits) - set((v1, v2))):
                fin_num = num[0:3] + v1 + num[3] + v2 + num[4:]
                if int(fin_num[2:5])%3:
                    continue
                elif int(fin_num[4:7])%7:
                    continue
                elif int(fin_num[5:8])%11:
                    continue
                elif int(fin_num[6:9])%13:
                    continue
                elif int(fin_num[7:10])%17:
                    continue
                print(fin_num)
                res.append(int(fin_num))

    print(sum(res))
            

if __name__ == "__main__":
    main()
