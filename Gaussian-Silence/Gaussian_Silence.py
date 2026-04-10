import random
import os


def encrypt_bit_v2(m, z_re, z_im, k_bits, r_bits):
    """Encrypts a single bit m using the secret Gaussian integer (z_re, z_im) with a hidden shift."""
    k_re = random.getrandbits(k_bits)
    k_im = random.getrandbits(k_bits)
    
    r_re = random.getrandbits(r_bits)
    r_im = random.getrandbits(r_bits)
    
    hidden_shift = (z_re % 5) + (z_im % 7) 
    
    c_re = k_re * z_re - k_im * z_im + 2 * r_re + m + hidden_shift
    c_im = k_re * z_im + k_im * z_re + 2 * r_im + hidden_shift
    return (c_re, c_im)

def main():
    flag = "BRKCYS{REDACTED_SECRET_FLAG_HERE}"
    
    z_re = random.getrandbits(2048)
    z_im = random.getrandbits(2048)
    
    k_bits = 2048
    r_bits = 128
    
    num_public_keys = 20 
    public_keys = [encrypt_bit_v2(0, z_re, z_im, k_bits, r_bits) for _ in range(num_public_keys)]

    flag_bits = "".join(format(ord(c), '08b') for c in flag)
    ciphertexts = [encrypt_bit_v2(int(bit), z_re, z_im, k_bits, r_bits) for bit in flag_bits]
    
    print("Public Keys and Ciphertexts generated.")

if __name__ == "__main__":
    main()
