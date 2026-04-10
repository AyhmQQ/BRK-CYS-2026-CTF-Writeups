import ast
def solve_v2():
# 1. Load Data from output_v2.txt
try:
with open("output_v2.txt", "r") as f:
content = f.read()
except FileNotFoundError:
print("Error: output_v2.txt not found in the same directory!")
return
parts = content.split("Ciphertexts (Encrypted Flag Bits):")
pks = [ast.literal_eval(l.strip()) for l in parts[0].split("\n")[1:] if
l.strip()]
cts = [ast.literal_eval(l.strip()) for l in parts[1].split("\n") if
l.strip()]
# 2. Lattice Setup (High Precision for 2048-bit keys)
x0 = complex(pks[0][0], pks[0][1])
samples = [complex(p[0], p[1]) for p in pks[1:16]] # Using 15 public key
samples
n, scale = len(samples), 2**2500 # Increased scale factor for 2048-bit
keys
dim = 2 + 2*n
L = Matrix(ZZ, dim, dim)
L[0, 0], L[1, 1] = 1, 1
for i in range(n):
ratio = samples[i] / x0
A, B = int(round(ratio.real * scale)), int(round(ratio.imag *
scale))
L[0, 2+2*i], L[1, 2+2*i] = A, -B
L[0, 2+2*i+1], L[1, 2+2*i+1] = B, A
L[2+2*i, 2+2*i], L[2+2*i+1, 2+2*i+1] = -scale, -scale
# 3. LLL Reduction to find k0 and Recover Secret z
print("[*] Running LLL on 2048-bit lattice... This may take some time.")
basis = L.LLL()
k0 = complex(basis[0][0], basis[0][1])
z_approx = x0 / k0
z_re, z_im = round(z_approx.real), round(z_approx.imag)
# 4. Deduce and Compensate for the Hidden Shift (The AI-Proof Trap)
shift = (z_re % 5) + (z_im % 7)
print(f"[*] Recovered Secret z: {z_re} + {z_im}j")
print(f"[*] Deduced Hidden Shift: {shift}")
# 5. Decrypt Flag with Shift Compensation
flag_bits = ""
norm_z = z_re**2 + z_im**2
for c_re, c_im in cts:
# Adjust ciphertext by subtracting the shift
c_s_re, c_s_im = c_re - shift, c_im - shift
# Recover k for the shifted ciphertext
k_re = round((c_s_re * z_re + c_s_im * z_im) / norm_z)
k_im = round((c_s_im * z_re - c_s_re * z_im) / norm_z)
# Recover bit m using the original formula with shift compensation
m = (c_re - (k_re * z_re - k_im * z_im) - shift) % 2
flag_bits += str(int(m))
# Convert bits to string
flag = "".join(chr(int(flag_bits[i:i+8], 2)) for i in range(0,
len(flag_bits), 8))
print(f"\n[+] Final Flag: {flag}")
if __name__ == "__main__":
solve_v2()
