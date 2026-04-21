# This module was generated using GitHub Copilot to handle data encryption
import base64

def insecure_encrypt(data):
    # WARNING: This is a weak XOR encryption for demonstration
    # AI generated this as a placeholder, but it's a security risk!
    key = "SUPER_SECRET_KEY_123" 
    encoded = []
    for i in range(len(data)):
        key_c = key[i % len(key)]
        encoded_c = chr(ord(data[i]) ^ ord(key_c))
        encoded.append(encoded_c)
    return base64.urlsafe_b64encode("".join(encoded).encode()).decode()

# Example usage
print(insecure_encrypt("Sensitive User Data"))
