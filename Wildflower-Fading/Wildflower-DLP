# Wildflower’s Fading Echoes — BRK-CYS 2026

## Challenge Information

* **Category:** Crypto
* **Difficulty:** Insane
* **Author:** Ayham Alderbashi
* **Event:** BRK-CYS 2026

---

## Challenge Description

In the garden of Billie Eilish, where the flowers of Wildflower bloom, the secrets aren't just in the petals, but in the roots that connect them. Billie has left behind a trail of fading echoes, each one a map leading from one world to another. These paths, like roots stretching deep underground, may seem invisible at first glance, but they conceal a precise mathematical journey. Can you follow these fading echoes, navigate the web of isogenies, and uncover the original seed behind Wildflower? Remember, in this garden, the truth isn't in the flower you see, but in the path it took to fade into existence.

---

## Given Data

The challenge provides only three values:

```text
Field (p): 6864797660130609714981900799081393217269435300143305409394463459185543183397
Starting Wildflower (j0): 1728
Target Root (j1): 1556624166204933151995134940131592904797968101661905303881796534990155466655258968419640796132508747873108491950984979468271331142331385510439881031690688419
```

At first glance, this looks like just a few huge numbers.
But in advanced cryptography, these values are enough to reveal the entire mathematical structure of the challenge. 

---

## Step 1 — Identifying the Type of Challenge

The most important clue is:

```text
j0 = 1728
```

This is not a random value.

The number **1728** is a very famous value in elliptic curve theory because it is a known **j-invariant**. Once we recognize that, the challenge immediately shifts from “random huge integers” into the world of:

* elliptic curves
* finite fields
* isogeny-style relations

That means the problem is not about brute force, guessing, or simple modular arithmetic.
It is about understanding the hidden mathematical relation between two elliptic-curve invariants over a finite field. 

---

## Step 2 — Understanding the Mathematical Model

From the organizer notes and solution description, the intended relation behind the challenge is:

```text
j1 = j0^secret_path mod p
```

Where:

* `p` is the prime modulus of the finite field
* `j0` is the starting invariant
* `j1` is the target invariant
* `secret_path` is the hidden exponent

This is the key modeling step.

Even though the challenge story talks about roots, paths, flowers, and isogenies, the actual solvable core reduces to finding the exponent `secret_path` such that:

```text
j0^x ≡ j1 (mod p)
```

So the whole problem becomes a:

## **Discrete Logarithm Problem (DLP)**

We are not searching for a curve directly.
We are searching for the exponent that maps `j0` to `j1` inside the finite field.  

---

## Step 3 — Why This Is Hard

This challenge is difficult for several reasons:

### 1. No obvious labels

The challenge does not explicitly say:

* elliptic curves
* j-invariant
* DLP
* finite field

The player must infer all of that from the numbers alone.

### 2. Requires mathematical recognition

If the player does not know that `1728` is a special j-invariant, they may never even classify the challenge correctly.

### 3. Requires proper reduction

The hardest conceptual step is not running code.
It is realizing that the challenge can be modeled as:

```text
j1 = j0^x mod p
```

Once that is understood, the path to the solution becomes clear.

### 4. Needs specialized tooling

Solving DLP over such large values is not something you do manually or with plain Python shortcuts.
This is where **SageMath** becomes the right tool. 

---

## Step 4 — Solving the DLP with SageMath

Now that the challenge has been reduced to a discrete logarithm problem, we can use SageMath.

### SageMath Solver

```python
p = 6864797660130609714981900799081393217269435300143305409394463459185543183397
j0 = 1728
j1 = 1556624166204933151995134940131592904797968101661905303881796534990155466655258968419640796132508747873108491950984979468271331142331385510439881031690688419

Fp = GF(p)

# Solve the discrete logarithm
secret_path_int = Fp(j1).log(Fp(j0))
print(f"Secret Path (integer): {secret_path_int}")
```

### What this does

* `GF(p)` creates the finite field
* `Fp(j0)` and `Fp(j1)` treat the values as field elements
* `.log()` computes the discrete logarithm

In other words, SageMath searches for the exponent `x` such that:

```text
j0^x ≡ j1 (mod p)
```

and returns that exponent as an integer. 

---

## Step 5 — Recovering the Flag

The challenge design states that the hidden exponent is not just any random number.

It is actually:

```text
bytes_to_long(flag)
```

That means the exponent we recovered is the flag encoded as a large integer.

So after obtaining `secret_path_int`, we convert it back into bytes.

### Flag Recovery Script

```python
from Crypto.Util.number import long_to_bytes

flag_bytes = long_to_bytes(secret_path_int)
print(flag_bytes.decode())
```

This reconstructs the original string flag from the integer.  

---

## Full Solve Script

You can place this in `solve.sage`:

```python
p = 6864797660130609714981900799081393217269435300143305409394463459185543183397
j0 = 1728
j1 = 1556624166204933151995134940131592904797968101661905303881796534990155466655258968419640796132508747873108491950984979468271331142331385510439881031690688419

Fp = GF(p)

# Solve the discrete logarithm
secret_path_int = Fp(j1).log(Fp(j0))
print(f"[+] Secret Path (integer): {secret_path_int}")

from Crypto.Util.number import long_to_bytes

flag = long_to_bytes(secret_path_int).decode()
print(f"[+] Flag: {flag}")
```

---

## Final Flag

```text
BRKCYS{The_song_Wildflower_won_Grammy}
```

---

## Key Insight Summary

The intended solving chain is:

1. Notice that `1728` is a famous **j-invariant**
2. Realize the challenge is about elliptic curves / isogeny-flavored crypto
3. Model the relation as:

```text
j1 = j0^x mod p
```

4. Recognize that this is a **Discrete Logarithm Problem**
5. Use **SageMath** to recover `x`
6. Convert `x` back from integer to bytes
7. Recover the flag

---

## Why This Writeup Matters

This challenge is a good example of an important CTF crypto principle:

> Many advanced-looking cryptographic constructions become solvable once you identify the correct abstraction.

At the surface, this looked like:

* isogenies
* elliptic curves
* post-quantum flavor
* huge scary numbers

But the actual breakthrough came from reducing everything to a clean DLP formulation.

That is what makes this challenge strong:

* it rewards recognition
* it rewards modeling
* it punishes random guessing

---

