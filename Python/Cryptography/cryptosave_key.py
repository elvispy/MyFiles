import os
#just to save the key
the_key = b'pLp04p82YzBL1ciZo-PlLm6pzEj52mUN2TAw02HzCqU='
with open(os.getcwd()+"\\cryptokey1.bin", "wb") as my_file:
    my_file.write(the_key)

