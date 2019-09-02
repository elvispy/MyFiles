from cryptography.fernet import Fernet
#just to generate the key
key = Fernet.generate_key()
print(key)
