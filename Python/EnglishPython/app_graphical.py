import sqlite3
import random
def prio(j : int) -> int:
    '''This sets the priority of all tiers'''
    return 3*(-abs(j-3)+3) if j<4 else 3*(-abs(j-3)+3)-2
def dicc(line):
    '''this creates a diccionary so that we can better handle the data'''
    return {'id':line[0],'verb':line[1], 'answer':line[2],
             'example':line[3],'record':line[4],'tier':line[5],'coefficient':line[6]}
def tier_calc(record : str) -> int:
    '''this calculates que tier of a word based on its record'''
    var = int(record,base = 2)
    if var<4:
        return 1
    elif var<8:
        return 2
    elif var <=32 :
        return 3
    elif var < 56:
        return 4
    else:
        return 5
def main():
    conn = sqlite3.connect('app.db')
    #--------------------------- Here I create the weights to choose the verb
    c=conn.cursor()
    tiers = [1,2,3,4,5]
    pesos = [prio(j) for j in tiers]
    c.execute("Select tier, count(id) from app group by tier")
    rta = c.fetchall()
    rtain = [tier[0] for tier in rta]
    rtaq = [tier[1] for tier in rta]
    pesos = [(0 if not (j in rtain) else pesos[j-1]*rtaq[rtain.index(j)])
             for j in tiers] #los pesos de cada verbo
    #---------------------------------
    t = random.choices(tiers, weights = pesos)[0]

    ##c.execute("update app set tier = '0000000'")
    c.execute("SELECT * from app where tier = :tier", {'tier':t})
    word = dicc(random.choices(c.fetchall())[0])


    conn.commit()
    conn.close()

    
    return word


    '''
    print("The chosen word is: {}".format(word['verb']))

    ans = input("Your answer is: ")

    if ans in word['answer'].split(";"):
        print("That's correct!")
        word['record'] = '1' + word['record'][:-1]  
        
    else:
        print("That's not correct. The correct answer is : {} {}".format(word['verb'], word['answer'].replace(";", " or ")))
        word['record'] = '0' + word['record'][:-1]
        
    word['coefficient'] = int(word['record'], base = 2)
    word['tier'] = tier_calc(word['record'])
    print("Example:")
    print(word['example'])

    c.execute("UPDATE app set record = :record, tier = :tier, coefficient = :coef where id = :id",
              {'record':word['record'], 'tier':word['tier'], 'coef':word['coefficient'], 'id':word['id']})
    '''
    
def fnAnswer(boolean : bool, word : dict):
    '''This function will check whether the answer is correct or not
    depending on the boolean '''
    conn = sqlite3.connect('app.db')

    c=conn.cursor()

    if boolean:
        word['record'] = '1' + word['record'][:-1]
    else:
        word['record'] = '0' + word['record'][:-1]
        
    word['coefficient'] = int(word['record'], base = 2)
    word['tier'] = tier_calc(word['record'])

    #Ejecutamos la actualizacion dependiendo de la respuesta
    c.execute("UPDATE app set record = :record, tier = :tier, coefficient = :coef where id = :id",
              {'record':word['record'], 'tier':word['tier'], 'coef':word['coefficient'], 'id':word['id']})

    conn.commit()
    conn.close()
    
if __name__ == '__main__':
    #main()
    pass

