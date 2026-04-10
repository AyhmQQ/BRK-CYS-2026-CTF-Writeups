# The Gaussian Silence: Transcendental Shift — BRK-CYS 2026

## Challenge Information

* **Category:** Crypto
* **Difficulty:** Insane
* **Author:** Ayham Al-Qaisi
* **Event:** BRK-CYS 2026

---

## Challenge Description

The singularity of the Gaussian manifold has been perturbed by a non-linear transcendental shift. In this dual-space, the echoes are no longer coherent; they are modulated by the very essence of the hidden kernel. To recover the primitive root of the flag, one must first deconvolve the secret-dependent bias from the lattice-point projections. The silence is not empty; it is shifted.

---

## Overview

This challenge is built around a Gaussian-integer variant of the **Approximate Common Divisor Problem (ACDP)** with a hidden secret-dependent shift.

Each encrypted bit is generated using a large secret Gaussian integer:

```text
c = k · z + 2r + m + shift
```

Where:

* `z = z_re + z_im i` is the secret Gaussian integer
* `k` is a large random Gaussian integer
* `r` is a small random Gaussian integer
* `m ∈ {0,1}` is the encrypted bit
* `shift` is a hidden bias derived from the secret itself

The crucial trap is that the shift is not public and is not constant in a generic way. It depends directly on the secret key:

```text
shift = (z_re mod 5) + (z_im mod 7)
```

This makes standard attacks fail unless the solver first recovers the hidden structure correctly.  

---

## Files Provided

The challenge includes:

* `challenge_v2.py` — challenge generation script
* `output_v2.txt` — public keys and encrypted flag bits
* `solution_v2.sage` — SageMath solver

The generator encrypts zero multiple times to produce public samples, then encrypts the flag bit-by-bit using the same hidden Gaussian secret. 

---

## Step 1 — Understanding the Construction

From the challenge source, each ciphertext is computed as follows:

```python
hidden_shift = (z_re % 5) + (z_im % 7)
c_re = k_re * z_re - k_im * z_im + 2 * r_re + m + hidden_shift
c_im = k_re * z_im + k_im * z_re + 2 * r_im + hidden_shift
```

So the ciphertext is a noisy approximate multiple of the secret Gaussian integer `z`, with two small perturbations:

1. the message bit `m`
2. the hidden shift

This means the public keys are not exact multiples of `z`, but they are still close enough to enable a lattice-based recovery strategy. 

---

## Step 2 — Why the Challenge Is Hard

This challenge is difficult for three main reasons:

### 1. Gaussian integer setting

The structure is not over ordinary integers, but over **ℤ[i]**, so both real and imaginary parts matter.

### 2. Approximate samples

The public keys are encryptions of zero, but still contain noise:

```text
c ≈ k · z
```

not exact multiples.

### 3. Hidden secret-dependent shift

Even after recovering an approximation of `z`, decryption still fails if the solver ignores:

```text
shift = (z_re mod 5) + (z_im mod 7)
```

This is the intended trap of the challenge. 

---

## Step 3 — Attack Idea

The intended solution is a **lattice attack**.

Because the public samples are approximate multiples of the same secret Gaussian integer, we can build a lattice from ratios of ciphertexts and use **LLL reduction** to recover information about the hidden multiplier and then reconstruct `z`.

The solver uses the first public key as a reference:

```python
x0 = complex(pks[0][0], pks[0][1])
samples = [complex(p[0], p[1]) for p in pks[1:16]]
```

Then it builds a lattice from the ratios:

```python
ratio = samples[i] / x0
```

These ratios are close to Gaussian integers because the samples are all derived from the same secret `z`. This is exactly what makes LLL useful here. 

---

## Step 4 — Lattice Construction

The Sage solver creates a matrix whose shortest vector reveals an approximation of the hidden multiplier used in the reference sample.

The scale factor is intentionally very large:

```python
scale = 2**2500
```

This is needed because the secret components are 2048-bit values, and the lattice must preserve enough precision during the approximation step. 

After LLL reduction:

```python
basis = L.LLL()
k0 = complex(basis[0][0], basis[0][1])
z_approx = x0 / k0
z_re, z_im = round(z_approx.real), round(z_approx.imag)
```

This gives an approximation of the secret Gaussian integer:

```text
z = z_re + z_im i
```

---

## Step 5 — Recovering the Hidden Shift

Once `z_re` and `z_im` are known, the hidden shift becomes easy to compute:

```python
shift = (z_re % 5) + (z_im % 7)
```

This is the most important post-processing step in the challenge.

Without subtracting this shift, the recovered bits are corrupted and the final flag will be wrong.  

---

## Step 6 — Decrypting the Flag Bits

For each ciphertext:

1. subtract the hidden shift from both parts
2. estimate the Gaussian multiplier `k`
3. recover the bit `m`

The solver does:

```python
c_s_re, c_s_im = c_re - shift, c_im - shift

k_re = round((c_s_re * z_re + c_s_im * z_im) / norm_z)
k_im = round((c_s_im * z_re - c_s_re * z_im) / norm_z)

m = (c_re - (k_re * z_re - k_im * z_im) - shift) % 2
```

Then it reconstructs the bitstring and converts it back into ASCII text. 

---

## Full Solver

```python
import ast

def solve_v2():
    with open("output_v2.txt", "r") as f:
        content = f.read()

    parts = content.split("Ciphertexts (Encrypted Flag Bits):")
    pks = [ast.literal_eval(l.strip()) for l in parts[0].split("\n")[1:] if l.strip()]
    cts = [ast.literal_eval(l.strip()) for l in parts[1].split("\n") if l.strip()]

    x0 = complex(pks[0][0], pks[0][1])
    samples = [complex(p[0], p[1]) for p in pks[1:16]]

    n, scale = len(samples), 2**2500
    dim = 2 + 2*n
    L = Matrix(ZZ, dim, dim)
    L[0, 0], L[1, 1] = 1, 1

    for i in range(n):
        ratio = samples[i] / x0
        A, B = int(round(ratio.real * scale)), int(round(ratio.imag * scale))
        L[0, 2+2*i], L[1, 2+2*i] = A, -B
        L[0, 2+2*i+1], L[1, 2+2*i+1] = B, A
        L[2+2*i, 2+2*i], L[2+2*i+1, 2+2*i+1] = -scale, -scale

    basis = L.LLL()
    k0 = complex(basis[0][0], basis[0][1])
    z_approx = x0 / k0
    z_re, z_im = round(z_approx.real), round(z_approx.imag)

    shift = (z_re % 5) + (z_im % 7)

    flag_bits = ""
    norm_z = z_re**2 + z_im**2

    for c_re, c_im in cts:
        c_s_re, c_s_im = c_re - shift, c_im - shift
        k_re = round((c_s_re * z_re + c_s_im * z_im) / norm_z)
        k_im = round((c_s_im * z_re - c_s_re * z_im) / norm_z)
        m = (c_re - (k_re * z_re - k_im * z_im) - shift) % 2
        flag_bits += str(int(m))

    flag = "".join(chr(int(flag_bits[i:i+8], 2)) for i in range(0, len(flag_bits), 8))
    print(flag)

if __name__ == "__main__":
    solve_v2()
```

---

## Final Flag

```text
BRKCYS{AI_F4il3d_G4uss14n_Sh1ft_M4st3ry_9921}
```

---

## Key Takeaways

* The challenge is a Gaussian-integer variant of approximate common divisor style cryptanalysis
* Lattice reduction is the central recovery tool
* The hidden shift is the main trap
* Recovering the structure is more important than directly attacking the bits

---

## Tools Used

* SageMath
* LLL lattice reduction
* Python parsing utilities

---
