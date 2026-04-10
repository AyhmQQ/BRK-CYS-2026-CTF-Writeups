# The Gwen Stacy Protocol — BRK-CYS 2026

## 🧠 Challenge Information

* **Category:** Crypto / Multi-Stage
* **Difficulty:** Impossible
* **Author:** Ayham Al-Qaisi (Breakers)
* **Event:** BRK-CYS 2026

---

## 📖 Description

In this challenge, participants dive into a tragic multi-stage cryptographic system where every connection generates a completely new instance.

Each stage represents a different cryptographic domain, and failure in any step results in immediate disconnection and regeneration of all parameters.

> This is not just a challenge — it is a one-shot protocol.

---

## ⚙️ Challenge Structure

The challenge consists of **three stages**:

---

### 1. Memory of Threads (ECC + Chaos)

* Chaotic elliptic curve generation
* Dynamic parameters (`p`, `a`, `b`)
* Time-dependent seeds

🔹 Goal:
Recover an intermediate key using elliptic curve operations

🔹 Difficulty:

* Parameters change every connection
* Depends on time and system state

---

### 2. Gwen’s Fall (LWE)

* Based on **Learning With Errors (LWE)**
* Random matrix `A`
* Secret vector `s`
* Noise `e`

```text
b = A·s + e
```

🔹 Goal:
Recover the secret vector `s`

🔹 Difficulty:

* Noise prevents direct solving
* Requires lattice-based techniques

---

### 3. Peter’s Solitude (Chaotic System)

* Dual chaotic maps:

  * Logistic Map
  * Tent Map
* State poisoning
* Temporal interleaving

🔹 Goal:
Decrypt the final flag using recovered seed

🔹 Difficulty:

* Depends on:

  * time.time_ns()
  * os.getpid()
  * system load
  * server secret

---

## ⚠️ One-Shot Mechanism

* Any wrong answer → instant disconnect
* Reconnection → completely new parameters

👉 No brute force
👉 No retry analysis
👉 No statistical attacks

---

## 🧠 Why This Challenge Is "Impossible"

This challenge is intentionally designed to be unsolvable in practice:

* Dynamic parameter generation
* Dependence on internal server state
* Nanosecond-level randomness
* LWE hardness
* Chaotic system unpredictability

As described in the design: 

> Parameters depend on time, PID, system load, and a hidden server secret.

---

## 🧪 Theoretical Solution

A theoretical solution would require:

1. Access to internal server data:

   * `time.time_ns()`
   * `os.getpid()`
   * `os.getloadavg()`
   * `SERVER_SECRET`

2. Reconstructing:

   * ECC parameters
   * LWE secret
   * Chaotic seeds

3. Fully reproducing the system state

👉 This is not feasible in a real CTF environment.

---

## 🏁 Final Flag

```text
BRKCYS{In_the_end_Spider_Man_was_left_alone_when_Gwen_died}
```

---

## 💡 Key Concepts

* Elliptic Curve Cryptography (ECC)
* Learning With Errors (LWE)
* Lattice-based cryptography
* Chaotic systems
* Time-based entropy
* State poisoning

---

## 💣 Takeaway

This challenge is not about solving —
it is about understanding the limits of cryptanalysis.

---

## 🧰 Tools (Theoretical)

* SageMath
* Custom cryptanalysis scripts
* Deep mathematical modeling

---

## ⚡ Final Insight

> Some systems are not meant to be broken —
> they are meant to be understood.

---
