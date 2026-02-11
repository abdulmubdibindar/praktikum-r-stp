# Module Review: 02-statistik-deskriptif.Rmd

**Review Date:** 2026-02-11  
**Module:** Modul-2: Analisis Statistika Deskriptif

---

## Executive Summary

**Overall Assessment:** ✅ **GOOD** (with minor issues)

Module 02 is significantly better than Module 01:

- ✅ Uses pipe operators extensively
- ✅ Demonstrates factor creation properly
- ✅ Good pedagogical structure
- ❌ **CRITICAL**: Missing chunk labels (same as Module 01)
- Minor issues with code organization

---

## Critical Issues

### 1. ❌ Missing Chunk Labels (CRITICAL)

**Issue:** ALL code chunks lack unique labels.

**Impact:** PDF compilation will fail.

**Chunks Needing Labels:**

- Line 15: `{r load-libraries}`
- Line 25: `{r import-data}`
- Line 36: `{r summary}`
- Line 57: `{r rename-conventional}`
- Line 74: `{r pipe-example-1}`
- Line 87: `{r pipe-example-2}`
- Line 137: `{r check-missing}`
- Line 149: `{r drop-na}`
- Line 163: `{r glimpse-before-factor}`
- Line 170: `{r factor-gender-wrong}`
- Line 186: `{r reload-and-fix}`
- Line 209: `{r check-values}`
- Line 225: `{r define-factor-vectors}`
- Line 249: `{r apply-factors}`
- Line 269: `{r check-levels}`
- Line 292: `{r load-gtsummary}`
- Line 303: `{r summary-categorical}`
- Line 315: `{r define-iqv}`
- Line 350: `{r calculate-iqv}`
- Line 363: `{r summary-numeric-auto}`
- Line 376: `{r summary-numeric-custom}`

**Action:** Add unique labels to all ~21 chunks.

---

## Strengths

### ✅ Strong Points

1. **Excellent Pipe Operator Teaching**
   - Lines 69-117: Clear comparison of conventional vs pipe approach
   - Good pedagogical structure

2. **Great Factor Creation Section**
   - Lines 159-263: Comprehensive coverage
   - Shows common mistake (case sensitivity) and how to fix it
   - Demonstrates both nominal and ordinal factors

3. **Good Exercise Design**
   - Exercise boxes at lines 119-129, 275-284, 429-462
   - Progressive difficulty
   - Clear instructions

4. **IQV Function Implementation**
   - Lines 315-345: Well-commented custom function
   - Good teaching opportunity

---

## Major Issues

### 2. ⚠️ Mixed Use of base R and dplyr

**Issue:** Uses `table()` (base R) alongside `count()` (dplyr).

**Location:** Lines 209-218

**Current:**

```r
table(data.ubl$Fakultas) # cara 1
data.ubl |> # cara 2
  count(Prodi)
```

**Impact:** Inconsistent style, confusing for beginners.

**Recommendation:** Stick to `count()` for consistency.

---

### 3. ⚠️ Unnecessary Code Repetition

**Issue:** Reloads dataset multiple times unnecessarily.

**Locations:** Lines 58, 71-78, 78, 91, 187

**Example:**

```r
data.ubl <- read.xlsx(file.dibaca, sheet = sheet.ubl) # Line 59
# ... do stuff ...
data.ubl <- read.xlsx(file.dibaca, sheet = sheet.ubl) # Line 78 (reload again!)
```

**Impact:**

- Wastes computational resources
- Confusing workflow
- Risk of losing prior transformations

**Recommendation:** Only reload when demonstrating different approaches, add clear comments explaining why.

---

## Minor Issues

### 4. 📝 Case Sensitivity Teaching Could Be Clearer

**Issue:** Line 172 uses `"Laki-laki"` (wrong) then Line 195 fixes to `"Laki-Laki"` (correct).

**Location:** Lines 168-203

**Current Approach:** Shows mistake then fixes it.

**Better Approach:** Add warning upfront:

```rmd
> ⚠️ **Penting: Huruf Besar/Kecil Penting!**
>
> Nilai "Laki-laki" (lowercase 'l') BERBEDA dengan "Laki-Laki" (uppercase 'L').
> R membedakan huruf besar dan kecil (*case-sensitive*).
```

---

### 5. 📝 Function Syntax Missing Argument Name

**Issue:** Line 176 uses `factor(Jenis.Kelamin, jk)` without `levels =`.

**Location:** Line 176

**Current:**

```r
mutate(Jenis.Kelamin = factor(Jenis.Kelamin,jk))
```

**Better:**

```r
mutate(Jenis.Kelamin = factor(Jenis.Kelamin, levels = jk))
```

**Impact:** Works but not educationally clear about what `jk` parameter does.

---

### 6. 📝 gtsummary Installation Comment

**Issue:** Line 293 uses `install.packages(c("gtsummary", "flextable"))` but only loads `gtsummary`.

**Location:** Lines 292-294

**Question:** Is `flextable` actually needed? The `as_flex_table()` function is from `gtsummary`, not `flextable`.

**Recommendation:** Verify dependencies and update comment/installation line.

---

## Dataset Verification

**File:** `datasets/Data Praktikum 02.xlsx`  
**Sheet:** `DataUtama_mhsUBL`  
**Status:** ✅ Assumed to exist (same as Module 01 uses this dataset)

---

## Code Quality Checklist

- ❌ All code chunks have unique labels → **FAILED**
- ✅ Datasets exist (assumed) → **PASSED**
- ✅ Pipe operator used → **PASSED**
- ✅ Factors created → **PASSED**
- ✅ Interpretations in Indonesian → **PASSED**
- ✅ Exercise boxes included → **PASSED**
- ✅ Capaian pembelajaran tags → **PASSED**

---

## Recommendations Summary

### Immediate Actions

1. **Add chunk labels** (CRITICAL for PDF)
2. **Verify flextable dependency** (might be unnecessary)

### High Priority

3. **Reduce code repetition** (remove unnecessary dataset reloads)
4. **Standardize on dplyr** (replace `table()` with `count()`)

### Medium Priority

5. **Add case-sensitivity warning** earlier
6. **Use explicit argument names** in factor creation
7. **Add interpretation paragraphs** for IQV function output

---

## Conclusion

Module 02 is pedagogically strong with excellent pipe operator and factor creation teaching. The main blocker is missing chunk labels. The module successfully builds on Module 01 and prepares students well for visualization (Module 03).

**Estimated Effort:** 1-2 hours to fix all issues.
