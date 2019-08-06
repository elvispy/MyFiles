import string
allowed = string.ascii_lowercase + string.ascii_uppercase + " ¿?,.!\n"
ans = ""
morse = {'a':".-", "b":"-...", "c":"-.-.", "d":"-..", "e":".", "f":"..-.",
         "g":"--.", "h":"....", "i":"..", "j":".---", "k":"-.-", "l":".-..",
         "m":"--", "n":"-.", "o":"---", "p":".--.", "q":"--.-", "r":".-.",
         "s":"...", "t":"-", "u":"..-", "v":"...-", "w":".--", "y":"-.--",
         "z":"--..","\n":"-----", "!":".----", "?":"..---", ",":"....-", ".":"....."}
with open("mog.txt", "r") as poem:
    c = poem.read()
    first = c[0]
    for x in c:
        if x == " ":
            ans = ans + "  "
        
        else:
            try:
                if x.lower() in string.ascii_lowercase and x != x.lower():
                    ans = ans + "m"
                ans = ans + morse[x.lower()] + " "
            except Exception:
                print(x)
                print(x.lower())
                print(c.index(x))




