#how to create a key using a password
import base64
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

password_provided = "passwords123" #this is the input in the form of a string
password = password_provided.encode()


#creating salt with os.urandom(32)
salt = b'\xb2H\x12\xe6\xdb!\xcf\xd4k\r\x93)j7\x81\xf7j(\nD\x87Z\xa9\x15FdP\xa6(9\xc2-'

kdf = PBKDF2HMAC(
    algorithm = hashes.SHA256(),
    length = 32,
    salt = salt,
    iterations = 100000,
    backend = default_backend()
    )
key = base64.urlsafe_b64encode(kdf.derive(password)) #can only use kdf once
print(key)
