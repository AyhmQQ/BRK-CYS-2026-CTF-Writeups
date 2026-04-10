# The Gaussian Silence: Transcendental Shift — BRK-CYS 2026

## 🧠 Challenge Information

* **Category:** Crypto
* **Difficulty:** Insane
* **Author:** Ayham Alderbashi
* **Event:** BRK-CYS 2026

---

## 📖 Description

The singularity of the Gaussian manifold has been perturbed by a non-linear transcendental shift. In this dual-space, the echoes are no longer coherent; they are modulated by the very essence of the hidden kernel.

To recover the primitive root of the flag, one must first deconvolve the secret-dependent bias from the lattice-point projections.

The silence is not empty; it is shifted.

---

## 📂 Files Provided

This challenge includes multiple files:

* `Gaussian_Silence.py` → Public reference script (for understanding the algorithm)
* `output_v2.txt` → Public keys + encrypted flag bits
* `solution_v2.sage` → Solver script (LLL attack)
* `challenge_v2.py` → Original generator (internal version)

The public script keeps the same structure but hides the real flag.

---

## 🔍 Overview

Each bit is encrypted using a secret Gaussian integer:

```
c = k · z + 2r + m + shift
```

Where:

* `z = z_re + z_im i` → secret (2048-bit each part)
* `k` → large random value
* `r` → small noise (128-bit)
* `m ∈ {0,1}` → bit of the flag
* `shift` → hidden secret-dependent value

The hidden shift is:

```
shift = (z_re mod 5) + (z_im mod 7)
```

This is the main trap in the challenge.

---

## ⚠️ Why This Challenge Is Hard

### 1. Gaussian Integers ℤ[i]

The problem is not over normal integers — it works in complex integer space.

---

### 2. Approximate Samples

Public keys are encryptions of zero, but still noisy:

```
c ≈ k · z
```

Not exact multiples.

---

### 3. Hidden Shift (Trap)

Even after recovering `z`, decryption fails unless you remove:

```
shift = (z_re % 5) + (z_im % 7)
```

---

## 💣 Attack Strategy

The intended attack is:

### Step 1 — Use Public Keys

Public keys are encryptions of zero:

```
c ≈ k · z
```

Use them to extract structure.

---

### Step 2 — Build Lattice

Compute ratios:

```
ratio = sample / reference
```

These are close to Gaussian integers.

---

### Step 3 — Apply LLL

Build a lattice using scaled ratios and run:

```
LLL reduction
```

This reveals an approximation of:

```
k0 → then recover z
```

---

### Step 4 — Recover Secret z

```
z ≈ reference / k0
```

Round to get:

```
z_re, z_im
```

---

### Step 5 — Compute Hidden Shift

```
shift = (z_re % 5) + (z_im % 7)
```

---

### Step 6 — Decrypt Bits

For each ciphertext:

1. Subtract shift
2. Recover k
3. Extract bit m

---

### Step 7 — Rebuild Flag

Convert bits → bytes → string

---

## 🧪 Full Solver (SageMath)

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
        A = int(round(ratio.real * scale))
        B = int(round(ratio.imag * scale))

        L[0, 2+2*i] = A
        L[1, 2+2*i] = -B
        L[0, 2+2*i+1] = B
        L[1, 2+2*i+1] = A

        L[2+2*i, 2+2*i] = -scale
        L[2+2*i+1, 2+2*i+1] = -scale

    basis = L.LLL()

    k0 = complex(basis[0][0], basis[0][1])
    z_approx = x0 / k0

    z_re = round(z_approx.real)
    z_im = round(z_approx.imag)

    shift = (z_re % 5) + (z_im % 7)

    flag_bits = ""
    norm_z = z_re**2 + z_im**2

    for c_re, c_im in cts:
        c_s_re = c_re - shift
        c_s_im = c_im - shift

        k_re = round((c_s_re * z_re + c_s_im * z_im) / norm_z)
        k_im = round((c_s_im * z_re - c_s_re * z_im) / norm_z)

        m = (c_re - (k_re * z_re - k_im * z_im) - shift) % 2
        flag_bits += str(int(m))

    flag = "".join(
        chr(int(flag_bits[i:i+8], 2))
        for i in range(0, len(flag_bits), 8)
    )

    print(flag)

solve_v2()
```

---

## 🏁 Final Flag

```
BRKCYS{AI_F4il3d_G4uss14n_Sh1ft_M4st3ry_9921}
```

---

## 💡 Key Takeaways

* Gaussian ACDP-style challenge
* Lattice (LLL) is the core attack
* Hidden shift is the main trick
* Proper modeling is everything

---

## 🧰 Tools Used

* SageMath
* LLL (Lattice Reduction)
* Python

---

## ⚡ Final Insight

This challenge is a perfect example of:

> “Break the structure → not the encryption”

Understanding the math is what solves the challenge — not brute force.

---
