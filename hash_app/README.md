# Hash-based Bucket Allocation

This is a testing application written as a Bash script that is intended to test a homework assignment from the **Database Systems** course.  
It tests applications written in **Python**, **C**, **C++**, and **Java**.

## Homework Description

In this assignment, you need to develop an application (in any programming language) that implements a simple **file-based hash bucket system** using a **fast hashing algorithm**.  
The task will help you understand hashing, file storage, and overflow bucket management.

### Requirements

Your program must:

- Accept **`n`** and **`s`** parameters at runtime, representing:
  - `n` — number of hash buckets
  - `s` — bucket size (in characters)
- For each string input (while the application is running):
  - Hash the string using a fast hashing algorithm of your choice.  
    (Standard fast hash functions like MurmurHash, CityHash, xxHash are allowed. External libraries may be used.)
  - Based on the hash, store the string into one of the `n` bucket files named `1.txt`, `2.txt`, ..., `n.txt`.  
    (Example: if `hash(text) % n == 3`, write it into `3.txt`.)
  - Collisions are allowed: multiple strings can go into the same file.

---

## Grading

### Option A — **Basic Hashing System (6 points)**

- Implement the basic system that hashes inputs into `n` files (`1.txt` to `n.txt`), allowing collisions within the files.

### Option B — **Overflow Handling (9 points)**

- Extend Option A by handling **overflow buckets**:
  - If a bucket file exceeds `s` symbols (total character count inside the file exceeds `s`), create overflow bucket files.
  - Implement a reference or linking mechanism between the original bucket file and its overflow bucket(s).
  - The reference logic (e.g., file pointers, chaining info inside files) is up to your design and must be clearly documented.
  - Your design must ensure that:
    - You can correctly determine which file to write to.
    - You do not confuse the overflow file with the original file.
    - You correctly chain multiple overflow files if needed.

---

## Submission Requirements

- The application name must be: **`hash_app`**.
- Clear instructions must be provided on how to compile it (if it is not written in an interpreted language).
- Minimum of **three commits** on **three separate days** in the provided GitHub Classroom repository.
  - Each commit must represent meaningful progress.
- Your `README.md` must include:
  - Which option you implemented: **Option A** or **Option B**.
    - (If you implemented Option A, overflow handling will not be checked.)
  - The **hashing algorithm/library** you used.
  - A short explanation of your **overflow bucket reference method** (only if you chose Option B).

---

## Demo of Application Behavior

Example of how your app should work:

```bash
$ hash_app 5 20
Please enter the string: Hello
Hello added to 3.txt
Please enter the string: World
World added to 1.txt
Please enter the string: Test
Test added to 3.txt
Please enter the string:
```

- The application shall **keep requesting inputs** until the user **presses `Ctrl+C`** to terminate.

---
