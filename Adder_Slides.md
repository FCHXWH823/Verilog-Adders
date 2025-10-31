---
marp: true
theme: default
paginate: true
---

# Digital Adders in Verilog
## A Comprehensive Overview

Undergraduate Computer Architecture Course

---

# Agenda

1. Introduction to Digital Adders
2. Carry Ripple Adder (RCA)
3. Carry Lookahead Adder (CLA)
4. Carry Select Adder (CSA)
5. Carry Skip Adder
6. Kogge-Stone Adder (KSA)
7. Hybrid Adder
8. Performance Comparison
9. Summary

---

# Introduction to Digital Adders

## What is a Digital Adder?

- A combinational circuit that performs addition of binary numbers
- Fundamental building block in processors and digital systems
- Trade-offs between **speed**, **area**, and **power**

## Key Concepts

- **Propagate (P)**: When a carry propagates through a bit position (A ⊕ B)
- **Generate (G)**: When a carry is generated at a bit position (A · B)
- **Carry**: Bit that "carries over" to the next significant position

---

# Full Adder: The Basic Building Block

## Logic

```verilog
module FA(output sum, cout, input a, b, cin);
  wire w0, w1, w2;
  
  xor  (w0, a, b);
  xor  (sum, w0, cin);
  
  and  (w1, w0, cin);
  and  (w2, a, b);
  or   (cout, w1, w2);
endmodule
```

## Equations
- **Sum** = A ⊕ B ⊕ Cin
- **Cout** = (A · B) + (Cin · (A ⊕ B))

---

# 1. Carry Ripple Adder (RCA)

## Concept

- Simplest multi-bit adder design
- Chain of full adders connected in series
- Carry output of one FA feeds into carry input of next FA

## Architecture

![RCA Architecture](https://www.researchgate.net/publication/283037309/figure/fig2/AS:454461651984390@1485363509931/Eight-bit-Ripple-Carry-adder.png)

*8-bit Ripple Carry Adder*

---

# Carry Ripple Adder (RCA)

## Characteristics

**Advantages:**
- Simple to design and implement
- Minimal hardware (area efficient)
- Easy to understand

**Disadvantages:**
- Slow for large bit-widths
- Carry must ripple through all stages
- Delay = O(n) where n is number of bits

## Performance
- **Delay**: n × (delay of 1 full adder)
- For 8-bit: 8 FA delays

---

# RCA Verilog Implementation

```verilog
// Ripple Carry Adder - 8 bits
module RCA8(output [7:0] sum, output cout, input [7:0] a, b);
  
  wire [7:1] c;
  
  FA fa0(sum[0], c[1], a[0], b[0], 0);
  FA fa[6:1](sum[6:1], c[7:2], a[6:1], b[6:1], c[6:1]);
  FA fa7(sum[7], cout, a[7], b[7], c[7]);
  
endmodule
```

**Key Points:**
- Sequential carry propagation
- Each stage waits for previous carry

---

# 2. Carry Lookahead Adder (CLA)

## Concept

- Reduces delay by computing carries in parallel
- Pre-calculates carry signals using **Generate** and **Propagate**
- Eliminates ripple delay

## Key Equations

- **Propagate**: Pi = Ai ⊕ Bi
- **Generate**: Gi = Ai · Bi
- **Carry**: Ci = Gi + Pi · Ci-1

---

# Carry Lookahead Adder (CLA)

## Architecture

![CLA Architecture](https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/4-bit_carry_lookahead_adder.svg/500px-4-bit_carry_lookahead_adder.svg.png)

*4-bit Carry Lookahead Adder*

---

# CLA Characteristics

**Advantages:**
- Much faster than RCA for larger bit-widths
- Parallel carry computation
- Delay = O(log n)

**Disadvantages:**
- More complex hardware
- Larger area (more gates)
- Fan-in increases with bit-width

## Performance
- **Delay**: Constant for small groups (4-8 bits)
- For 8-bit: ~3 gate delays (vs 8 for RCA)

---

# CLA Carry Computation Example

For a 4-bit adder:

```
C0 = G0 + P0·Cin
C1 = G1 + P1·G0 + P1·P0·Cin
C2 = G2 + P2·G1 + P2·P1·G0 + P2·P1·P0·Cin
C3 = G3 + P3·G2 + P3·P2·G1 + P3·P2·P1·G0 + P3·P2·P1·P0·Cin
```

**Notice:** All carries computed simultaneously!

---

# 3. Carry Select Adder (CSA)

## Concept

- Compromise between RCA and CLA
- Uses **dual computation** and **multiplexing**
- Computes addition for Cin=0 and Cin=1 in parallel
- Selects correct result once actual carry is known

## Strategy

1. Split n-bit addition into blocks
2. For each block, compute two results (assuming Cin=0 and Cin=1)
3. Use multiplexer to select correct result

---

# Carry Select Adder (CSA)

## Architecture

![CSA Architecture](https://upload.wikimedia.org/wikipedia/en/thumb/1/10/Carry-select-adder-detailed-block.png/712px-Carry-select-adder-detailed-block.png)

*Carry Select Adder Block Diagram*

---

# CSA Characteristics

**Advantages:**
- Faster than RCA
- Simpler than full CLA
- Scalable design

**Disadvantages:**
- Requires duplicate hardware (2 adders per block)
- More area than RCA
- Power consumption higher due to dual computation

## Performance
- **Delay**: O(√n)
- Good balance between speed and complexity

---

# CSA Verilog Structure

```verilog
// Block 1: Compute both possibilities
RCA4 rca1_0(sum0[7:4], cout1_0, a[7:4], b[7:4], 1'b0);
RCA4 rca1_1(sum1[7:4], cout1_1, a[7:4], b[7:4], 1'b1);

// Select based on actual carry from previous block
MUX2to1_w4 mux1_sum(sum[7:4], sum0[7:4], sum1[7:4], c1);
MUX2to1_w1 mux1_cout(cout, cout1_0, cout1_1, c1);
```

**Key Idea:** Pre-compute, then select!

---

# 4. Carry Skip Adder

## Concept

- Optimizes RCA by "skipping" over blocks
- Uses propagate signals to bypass blocks
- If all bits in a block propagate, skip directly to next block

## Skip Logic

If **all** bits in a block propagate (P = P0 · P1 · P2 · P3):
- Carry-out = Carry-in (skip the block)

Otherwise:
- Normal ripple through the block

---

# Carry Skip Adder

## Architecture

![Carry Skip Architecture](https://www.researchgate.net/profile/Sujan_Sarkar3/publication/322057640/figure/fig3/AS:631632960700450@1527604441337/8-bit-Carry-Skip-Adder.png)

*8-bit Carry Skip Adder*

---

# Carry Skip Adder Characteristics

**Advantages:**
- Faster than RCA
- Less hardware than CSA (no duplication)
- Simple modification of RCA

**Disadvantages:**
- Still has some ripple delay
- Not as fast as CLA
- Effectiveness depends on block size

## Performance
- **Delay**: O(√n)
- Best case: Carry skips multiple blocks
- Worst case: Similar to RCA

---

# Carry Skip Logic Implementation

```verilog
module SkipLogic(output cin_next,
  input [3:0] a, b, input cin, cout);
  
  wire p0, p1, p2, p3, P;
  wire nP, P1Cout, P0Cout;
  
  // Generate propagate for each bit
  xor (p0, a[0], b[0]);
  xor (p1, a[1], b[1]);
  xor (p2, a[2], b[2]);
  xor (p3, a[3], b[3]);
  
  // Block propagate: all bits must propagate
  and (P, p0, p1, p2, p3);
  
  // Select: if P=1 skip (use cin), else use cout
  not (nP, P);
  and (P1Cout, P, cin);
  and (P0Cout, nP, cout);
  or (cin_next, P1Cout, P0Cout);
endmodule
```

---

# 5. Kogge-Stone Adder (KSA)

## Concept

- Parallel prefix adder
- Uses tree structure to compute carries
- Logarithmic depth (very fast!)
- Based on prefix computation of G and P

## Key Features

- **Parallel computation** at each level
- **Tree structure** reduces depth
- Each level doubles the span

---

# Kogge-Stone Adder Architecture

## Tree Levels

![KSA Architecture](https://elnndccpro.files.wordpress.com/2017/01/4bit-kogge-stone-adder.jpg)

*4-bit Kogge-Stone Adder showing tree structure*

---

# KSA Building Blocks

```verilog
// Black cell (BigCircle): Combines G and P
module BigCircle(output G, P, input Gi, Pi, GiPrev, PiPrev);
  wire e;
  and (e, Pi, GiPrev);
  or  (G, e, Gi);
  and (P, Pi, PiPrev);
endmodule

// Gray cell: Combines only G
module GrayCircle(output G, input Gi, Pi, GiPrev);
  wire e;
  and (e, Pi, GiPrev);
  or  (G, e, Gi);
endmodule

// Initial generation
module Square(output G, P, input Ai, Bi);
  and (G, Ai, Bi);
  xor (P, Ai, Bi);
endmodule
```

---

# KSA Characteristics

**Advantages:**
- **Fastest** for large bit-widths
- Delay = O(log n)
- Regular structure (good for VLSI)
- Highly parallel

**Disadvantages:**
- Most complex design
- Largest area and power consumption
- Many wiring tracks needed
- High fan-out

## Performance
- **Delay**: log₂(n) levels
- For 8-bit: Only 3 levels!

---

# 6. Hybrid Adder

## Concept

- Combines **different adder architectures**
- Optimizes for specific use cases
- Example: CLA for lower bits, KSA for upper bits

## Implementation in Repository

```verilog
module HA8(output [7:0] sum, output cout, input [7:0] a, b);
  // Lower 4 bits: Use CLA (simpler)
  CLA4 cla4(sum[3:0], cout_1, a[3:0], b[3:0]);
  
  // Upper 4 bits: Use KSA (faster for carry chain)
  KSA4 ksa4(sum[7:4], cout, a[7:4], b[7:4], cout_1);
endmodule
```

---

# Hybrid Adder Characteristics

**Advantages:**
- Optimizes area-delay trade-off
- Flexible design
- Can be tuned for specific requirements

**Disadvantages:**
- More complex design process
- Requires careful analysis
- May not be optimal for all cases

## Use Cases
- When different bit ranges have different timing requirements
- To balance area and speed
- Custom optimization for specific applications

---

# Performance Comparison

## Delay Complexity

| Adder Type | Delay | Relative Speed | Area |
|------------|-------|----------------|------|
| RCA | O(n) | Slowest | Smallest |
| Carry Skip | O(√n) | Medium | Small-Medium |
| Carry Select | O(√n) | Medium | Medium-Large |
| CLA | O(log n) | Fast | Medium-Large |
| Kogge-Stone | O(log n) | Fastest | Largest |
| Hybrid | Varies | Tunable | Tunable |

*n = number of bits*

---

# Speed vs Area Trade-off

## For 32-bit Addition (approximate)

```
Speed (fastest to slowest):
  Kogge-Stone > CLA > Carry Select ≈ Carry Skip > RCA

Area (smallest to largest):
  RCA < Carry Skip < CLA ≈ Carry Select < Kogge-Stone

Power (lowest to highest):
  RCA < Carry Skip < CLA < Carry Select < Kogge-Stone
```

## Design Choice Factors
- Target frequency
- Available chip area
- Power budget
- Design complexity tolerance

---

# Practical Considerations

## When to Use Each Adder?

**RCA:** 
- Small bit-widths (< 8 bits)
- Low-power applications
- Area-constrained designs

**Carry Skip/Select:** 
- Medium bit-widths (8-32 bits)
- Balanced performance needs

**CLA/Kogge-Stone:** 
- Large bit-widths (32-64+ bits)
- High-performance processors
- Critical path optimization

**Hybrid:** 
- Custom optimization scenarios
- Mixed requirements

---

# Real-World Applications

## Where Are These Used?

1. **Arithmetic Logic Units (ALUs)**
   - Core of every processor
   
2. **Digital Signal Processing (DSP)**
   - Fast arithmetic for signal processing
   
3. **Graphics Processing Units (GPUs)**
   - Parallel arithmetic operations
   
4. **Cryptographic Hardware**
   - Large integer arithmetic
   
5. **Network Processors**
   - Checksum and address computation

---

# Design Considerations

## Key Questions for Designers

1. **What is the target bit-width?**
   - Affects choice of architecture

2. **What is the critical path constraint?**
   - Determines speed requirement

3. **What is the area budget?**
   - Limits complexity

4. **What is the power budget?**
   - Affects number of gates switching

5. **Is the design regular/scalable?**
   - Important for VLSI implementation

---

# Extending to Larger Widths

## Hierarchical Design

Most adders can be extended hierarchically:

**16-bit from 4-bit blocks:**
```
[4-bit] → [4-bit] → [4-bit] → [4-bit]
```

**32-bit from 8-bit blocks:**
```
[8-bit] → [8-bit] → [8-bit] → [8-bit]
```

## Techniques
- Carry lookahead across blocks
- Multiple levels of carry select
- Tree-based structures (KSA scales naturally)

---

# Advanced Topics (Optional)

## Beyond Basic Addition

1. **Subtraction**
   - Use 2's complement: A - B = A + (~B) + 1

2. **Signed Addition**
   - Overflow detection
   - Sign extension

3. **Floating-Point Addition**
   - Alignment, addition, normalization
   - Uses integer adders internally

4. **Multiply-Add Units**
   - Fused operations for DSP

---

# Verification Strategies

## How to Test Your Adder

1. **Exhaustive Testing** (for small widths)
   - Test all possible input combinations
   - 2^(2n+1) test cases for n-bit adder with cin

2. **Random Testing**
   - Generate random test vectors
   - Compare with golden model

3. **Corner Cases**
   - All 0s + All 0s
   - All 1s + All 1s (maximum carry propagation)
   - Alternating patterns

---

# Summary

## Key Takeaways

1. **No "best" adder** - trade-offs depend on requirements

2. **RCA**: Simple but slow (O(n))

3. **CLA/KSA**: Fast but complex (O(log n))

4. **Carry Skip/Select**: Middle ground (O(√n))

5. **Hybrid**: Optimize for specific needs

6. **Design choice** depends on:
   - Bit-width
   - Speed requirements
   - Area/power constraints

---

# Practical Exercise Ideas

## Hands-On Learning

1. **Simulate** each adder type with test benches
   - Measure delay
   - Compare results

2. **Synthesize** designs for FPGA
   - Analyze resource utilization
   - Measure actual timing

3. **Modify** designs
   - Create 16-bit or 32-bit versions
   - Try different block sizes

4. **Compare** performance
   - Plot delay vs bit-width
   - Analyze area vs speed

---

# Resources for Further Study

## Recommended Reading

1. **Computer Organization and Design** - Patterson & Hennessy
   - Chapter on Computer Arithmetic

2. **Digital Design and Computer Architecture** - Harris & Harris
   - Detailed adder implementations

3. **VLSI Digital Signal Processing Systems** - Parhi
   - Advanced arithmetic architectures

## Online Resources
- IEEE papers on adder architectures
- OpenCores (open-source hardware)
- This repository: github.com/FCHXWH823/Verilog-Adders

---

# Questions?

## Thank You!

**Repository**: github.com/FCHXWH823/Verilog-Adders

All adder implementations available in Verilog with:
- 8, 16, 32, and 64-bit versions
- Complete test benches
- Documentation

Feel free to explore, modify, and experiment!

---

# Appendix: Quick Reference

## Adder Formulas

**Full Adder:**
- Sum = A ⊕ B ⊕ Cin
- Cout = AB + Cin(A ⊕ B)

**Propagate & Generate:**
- P = A ⊕ B
- G = A · B

**Carry in CLA:**
- Ci = Gi + Pi · Ci-1

**Prefix in KSA (combining G,P pairs):**
- G(i:j) = G(i:k) + P(i:k) · G(k-1:j)
- P(i:j) = P(i:k) · P(k-1:j)

