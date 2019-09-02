from cryptography.fernet import Fernet

with open("cryptokey1.bin", "rb") as f:
    key = f.read()

#Open the file to encrypt
with open("text.txt", "rb") as f:
    data = f.read()

fernet = Fernet(key)
encrypted = fernet.encrypt(data)

#write the enrypted file
with open("text.txt.encrypted", "wb") as f:
    f.write(encrypted)


