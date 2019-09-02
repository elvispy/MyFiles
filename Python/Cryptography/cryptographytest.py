#Understanding cryptography
from Crypto.Random import get_random_bytes as grb
from Crypto.Protocol.KDF import PBKDF2
import os

'''
Key generation may seem useless as you need to store it,
but that is definitely not the case. Since this function creates truly
random data, we could simply generate a key and then write it to a file
on a USB (or some other secure place). When we encrypt/decrypt files,
we then read this file from the USB and get the key out.
Here is an example of this:
'''
#generate the key
key = grb(32)
salt = b"r\xcc[7\x99\xfe\x17?'$\x1dK5vs\xc7\xfa\xaf\xc6]um \xa5\x14=j\x18V\xa4\xde1"
password = 'password123'
salted_key = PBKDF2(password, salt, dkLen = 32)


# store it in a safe place
key_location = os.getcwd() + "\\my_key.bin"
''' Since the file has been already created.
file_out = open(key_location, "wb") #wb = write bytes
file_out.write(key)
file_out.close()
'''
#later on... (assume we no longer have the key

file_in = open(key_location, "rb") #read bytes
key_from_file = file_in.read() #this key should be the same
 # this key should be the same
file_in.close()

# Since this is a demonstration, we can verify that the keys are the same
#(just for proof - you don't need to do this)
#assert key == key_from_file, 'Keys do not match' # Will throw an AssertionError if they do not match
