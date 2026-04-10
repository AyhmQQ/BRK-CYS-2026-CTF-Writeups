# Wildflower's Fading Echoes - Solver (SageMath)

from Crypto.Util.number import long_to_bytes

# Given values
p = 6864797660130609714981900799081393217269435300143305409394463459185543183397

j0 = 1728

j1 = 1556624166204933151995134940131592904797968101661905303881796534990155466655258968419640796132508747873108491950984979468271331142331385510439881031690688419

# Create finite field
Fp = GF(p)

print("[*] Solving Discrete Logarithm Problem...")

# Solve for secret exponent x such that:
# j0^x ≡ j1 (mod p)
secret = Fp(j1).log(Fp(j0))

print(f"[+] Secret (integer): {secret}")

# Convert integer back to bytes (flag)
flag_bytes = long_to_bytes(secret)

try:
    flag = flag_bytes.decode()
    print(f"[+] Flag: {flag}")
except:
    print("[!] Could not decode flag directly")
    print(f"[+] Raw bytes: {flag_bytes}")
