# DarthSheaf BLAS Improvements & Notes

## Sparse Vectors & Matrices

### Representation Strategy
- COO (coordinate format): List of (index, value) pairs — simplest, serializable
- CSR (compressed sparse row): For matrix rows — cache-friendly iteration
- CSC (compressed sparse column): For matrix columns — memory layout alternative
- Decision: Start COO for vectors, defer matrix formats pending Level 2/3 scope

### Sparse Vector Ops (Level 1)
- SCAL_SPARSE: scalar × sparse vector (drop zeros)
- AXPY_SPARSE: a × sparse_x + sparse_y (merge sparse structures)
- DOT_SPARSE: sparse · sparse inner product
- NRM2_SPARSE: norm of sparse vector (only nonzero entries)

### Design Questions
- Type class for sparse representation? `SparseVector v` vs concrete COO type?
- How to preserve sparsity through operations (drop near-zeros? threshold?)
- Efficiency of merge-and-drop in AXPY_SPARSE

### Performance Targets
- AXPY_SPARSE should beat dense for fill factor < ~0.3
- Benchmark against dense baseline at various sparsity levels

---

## Quantization Framework

### Quantization Levels (Parameterized)
- Q64: Full precision (no-op, baseline)
- Q32: Single precision float
- Q16: Half precision (float16 or bfloat16)
- Q8: 8-bit int (symmetric or asymmetric)
- Custom: User-defined level with explicit conversion rules

### Type System Integration
- Phantom type for quantization level: `Vector q a` where `q` is the level
- Or constraint-based: operations require `Quantizable a q => ...`
- Decision: Start phantom type (simpler, no typeclass proliferation)

### Operations Affected
- All BLAS ops should be quantization-aware
- Dequantize before compute? Or compute in quantized domain?
- Accumulation precision: should DOT return higher precision than operands?

### Rounding & Overflow
- Rounding strategy per level (nearest, round-to-even, stochastic)
- Overflow handling: saturate, wrap, or error?
- Conversion loss: how to measure and report?

### Benchmarking Hooks
- Memory footprint vs full precision
- Compute speedup (hardware-dependent)
- Accuracy loss on real problems (regression tests)

---

## Integration Points

### Dense ↔ Sparse Interop
- Conversion ops: dense_to_sparse, sparse_to_dense
- Implicit conversions or explicit?

### Quantization + Sparsity
- Can operations combine both? (Q16 sparse vector)
- Interaction effects on memory/speed?

---

## Testing & Validation

### Sparse Correctness
- Property: `sparse_axpy ≈ dense_axpy (ignoring structure)`
- Sparsity preservation: verify outputs have expected fill factor

### Quantization Correctness
- Dequantized result ≈ full precision (within rounding bounds)
- Round-trip: quantize → dequantize → compare

### Mixed Modes
- Sparse + quantized: verify both properties hold

---

## Research & References

### Sparse BLAS
- GraphBLAS interface (if worth learning)
- Eigen SparseVector API
- petsc sparse ops

### Quantization
- INT8/FP16 best practices in deep learning (TensorFlow/PyTorch refs)
- Rounding schemes (stochastic, nearest, saturation)

---

## Deferred Decisions

- Scope: do sparse ops extend to Level 2 (matrix-vector)? Level 3 (matrix-matrix)?
- Quantization: static (type-level) vs runtime (value-level)?
- Error reporting: what if quantization overflows? Silently saturate vs exception? 
