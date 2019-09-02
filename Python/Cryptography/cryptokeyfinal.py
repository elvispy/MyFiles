from cryptography.fernet import Fernet

# get the key from the file
with open("cryptokey1.bin", "rb") as f:
    key = f.read()

# Encode the message
message = "My deep dark secret"
encoded = message.encode()

#encrypt the message
f = Fernet(key)
encrypted = f.encrypt(encoded)

print("This is the encrypted message, using the encryption of cryptokey1: ")
print(encrypted)

de = f.decrypt(encrypted)

print("The decrypted message: ")
print(de)
