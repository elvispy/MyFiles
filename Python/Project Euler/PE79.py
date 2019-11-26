<<<<<<< HEAD
with open("p079_keylog.txt", "r") as f:
    content = f.read()
logs = content.split("\n")
logs = [log for log in logs if len(log) > 0]
pos = []
for log in logs:
    aux = [log[0], log[1], log[2]]
    newpos = []
    for po in pos:
        try:
            x = po.index(log[0])
            try:
                y = po.index(log[1])
                try:
                    z = po.index(log[2])
                    #all of them are present, just add it to the new possibilities
                    newpos.append(pos)
                except:
                    for i in range(y+1, len(pos)+1):
                        lolazo = pos[:i] + log[2] + pos[i:]
                        if lolazo in newpos:
                            pass
                        else:
                            newpos.append(lolazo)
                    #just the first two are present
                    pass
            except:
                try:
                    z = po.index(log[2])
                    #second is not present
                except:
                    #just the first is present
                    pass
                pass
        except:
            try:
                y = po.index(log[1])
                try:
                    z = po.index(log[2])
                    #The first is not present
                except:
                    #Just the second is present
            except:
                try:
                    z = po.index(log[2])
                    #just the last one is present
                except:
                    #None of them are present
    pos = newpos
=======
a = None
with open("p079_keylog.txt") as f:
    data = f.read()
data = data.split("\n")[:-1]
>>>>>>> 873e116bc2b8facd3ca6576cb7ceac81448520e2
