# Module Review Summary: Modules 04-09

**Review Date:** 2026-02-11  
**Modules:** 04 through 09 (Distribusi through PCA)

---

## Overview

This consolidated review covers the remaining 6 modules. All share similar patterns with Module 01-02 regarding missing chunk labels, but have varying levels of technical complexity and code quality.

---

# Module 04: Distribusi Statistik & Interval Kepercayaan

**Assessment:** ⚠️ **NEEDS WORK**

## Critical Issues

❌ **Missing ALL chunk labels** (12 chunks unlabeled based on outline)

## Major Issues

⚠️ **Complex data preprocessing** without clear explanation:

- Lines 28-97: Combines 4 datasets (ITERA, UNILA, UBL, UINRIL)
- Uses `case_when()` with regex patterns (`str_detect`)
- Students at semester 2 may struggle with this complexity

⚠️ **Library inconsistency:**

- Uses `readr` but most other modules use `openxlsx`
- Loads `tidyverse` AND `readr` separately (readr is part of tidyverse)

## Minor Issues

📝 **MKinfer package** introduced late (line 235)

- Should be in "Persiapan" section

📝 **Code comments** explaining `case_when` are good but could be in separate .rmdnote block

## Recommendations

1. Add chunk labels (HIGH PRIORITY)
2. Simplify dataset loading OR add comprehensive walkthrough
3. Move MKinfer to preparation section
4. Consider splitting complex preprocessing into separate sub-sections

---

# Module 05: Uji Hipotesis

**Assessment:** ⚠️ **COMPLEX BUT GOOD PEDAGOGY**

## Critical Issues

❌ **Missing chunk labels** (33+ chunks based on outline - LARGEST module!)

## Strengths

✅ **Excellent visual teaching:**

- Lines 135-273: Three distribution diagrams showing two-tailed, left-tailed, right-tailed tests
- Uses `echo=FALSE, fig.cap` correctly for figure captions
- Great pedagogical tool

✅ **Custom functions:**

- Line 88: Defines `ht_mean_1pop()` function for hypothesis testing
- Good teaching of function creation

✅ **Comprehensive coverage:**

- One population tests
- Two population tests
- Multiple test types (mean, proportion)

## Major Issues

⚠️ **Module too long** (886 lines!)

- Difficult to navigate
- Could be split into 5A and 5B

⚠️ **Dataset loading inconsistency:**

- Line 30: Uses `read_csv2("data_mahasiswa.csv")`
- But file path not prefixed with `datasets/`
- Inconsistent with other modules

## Recommendations

1. Add chunk labels (CRITICAL - 33+ chunks!)
2. Fix dataset path to include `datasets/` prefix
3. Consider splitting into two modules (one vs two population)
4. Add brief learning objectives at start of each major section

---

# Module 06: Korelasi Nominal-Ordinal

**Assessment:** ⚠️ **SOLID CONTENT, MISSING BASICS**

## Critical Issues

❌ **Missing chunk labels** (14 chunks unlabeled)

## Major Issues

⚠️ **Overly complex factor creation:**

- Lines 59-151: Creates factors using `group_by |> summarize |> extract column` pattern
- Module 02 method (direct vector definition) is simpler and clearer
- Inconsistent with earlier teaching

**Example Current (Complex):**

```r
faktor_prodi <- data_mahasiswa |>
  group_by(prodi = Prodi) |>
  summarize(jumlah = n())
faktor_prodi <- faktor_prodi$prodi
```

**Better (From Module 02):**

```r
faktor_prodi <- c("Administrasi Bisnis", "Administrasi Publik", ...)
```

⚠️ **External image file:**

- Line 195: Uses `![...](images/hasil%20tabel%20silang.png)`
- Should generate table in-document with gtsummary

⚠️ **Library loading mid-module:**

- Lines 179, 232, 312: Loads libraries in middle of analysis
- Violates pedagogical structure

## Recommendations

1. Add chunk labels
2. Simplify factor creation to match Module 02 pattern
3. Generate cross-tabulation in-document instead of external image
4. Move all library loads to "Persiapan" section
5. Verify dataset path consistency

---

# Module 07: Korelasi Metrik

**Assessment:** ✅ **CONCISE AND CLEAR**

## Critical Issues

❌ **Missing chunk labels** (8 chunks)

## Strengths

✅ **Shortest module** (184 lines) - Good scope management
✅ **Clear progression:** Scatterplot → Spearman's ρ → Pearson's r
✅ **Good dataset filtering example** (line 108: filtering for online transportation users)

## Minor Issues

📝 **Small inconsistency:**

- Uses both `|>` and some direct function calls
- Generally consistent though

📝 **Could add interpretation section** for coefficient values:

- What does ρ = 0.3 mean?
- When to use Spearman vs Pearson?

## Recommendations

1. Add chunk labels (8 chunks only - quick fix!)
2. Add brief interpretation guide for correlation coefficients
3. Consider adding example of negative correlation

---

# Module 08: Regresi Linear

**Assessment:** ⚠️ **GOOD CONTENT, PRESENTATION ISSUES**

## Critical Issues

❌ **Missing chunk labels** (21+ chunks)

## Strengths

✅ **Good visualization:**

- Shows scatterplot with regression line
- Uses `geom_smooth(method = "lm")`

✅ **Multiple presentation formats:**

- `summary(model)`
- `tbl_regression()` from gtsummary

✅ **Covers outlier handling:**

- Discusses removing outliers
- Shows before/after comparison

## Major Issues

⚠️ **Dataset inconsistency:**

- Uses `data_mahasiswa_online` (filtered dataset)
- Not clear if this is same as previous modules
- Path and loading not shown clearly

⚠️ **Interpretation could be clearer:**

- Line 323: Asks "why does further distance = lower cost?"
- Good question but answer not provided
- Could confuse students

⚠️ **Multiple regression section** (if present):

- Need to verify if covered adequately
- Outline shows simple regression focus

## Recommendations

1. Add chunk labels
2. Answer the "bonus question" about distance/cost relationship
3. Clarify dataset provenance
4. Verify multiple regression coverage matches capaian pembelajaran

---

# Module 09: Komponen Prinsip (PCA)

**Assessment:** ⚠️ **ADVANCED TOPIC, GOOD STRUCTURE**

## Critical Issues

❌ **Missing chunk labels** (10 chunks)

## Strengths

✅ **Uses different dataset** (`data_cfd` - CFD/Car Free Day data)

- Good variety for students

✅ **Comprehensive pre-analysis checks:**

- KMO test
- Bartlett test
- Eigenvalues
- Scree plot (likely)

✅ **Clear differentiation:**

- Factor Analysis vs PCA explained
- Both methods demonstrated

## Major Issues

⚠️ **New packages introduced:**

- `psych` package for PCA
- `corrplot` (likely, based on correlation matrix visualization)
- Needs clear installation/load section

⚠️ **Dataset `data_cfd`:**

- Not from standard `datasets/` folder pattern?
- Origin/path unclear from outline

⚠️ **Mathematical complexity:**

- Eigenvalues, loadings, weights, scores
- Good explanations needed for semester-2 students

## Recommendations

1. Add chunk labels
2. Clarify dataset source and loading
3. Add comprehensive glossary for PCA terms
4. Consider adding visual diagram of PCA process
5. Ensure exercises guide students through interpretation

---

# Cross-Module Summary

## Common Critical Issues (ALL Modules 04-09)

1. ❌ **Missing chunk labels** → Blocks PDF compilation
2. ⚠️ **Dataset path inconsistencies** → May cause file-not-found errors
3. ⚠️ **Libraries loaded mid-module** → Violates pedagogical structure

## Common Strengths

1. ✅ **Good exercise boxes** with STP tags
2. ✅ **Progressive difficulty**
3. ✅ **Real datasets** with meaningful context

## Common Weaknesses

1. ⚠️ **Inconsistent pipe operator usage** (`|>` vs `%>%`)
2. ⚠️ **Factor creation patterns vary** across modules
3. ⚠️ **No standardized data preprocessing** workflow

---

# Priority Matrix

## CRITICAL (Fix Before Next Use)

- **ALL MODULES**: Add chunk labels
- **Module 04**: Verify dataset paths
- **Module 05**: Fix `data_mahasiswa.csv` path
- **Module 06**: Move library loads to top

## HIGH PRIORITY

- **Module 05**: Consider splitting (too long)
- **Module 06**: Simplify factor creation
- **Module 08**: Answer interpretation questions
- **Module 09**: Clarify dataset source

## MEDIUM PRIORITY

- **All**: Standardize pipe operators to `|>`
- **All**: Ensure libraries in "Persiapan" section
- **Module 07**: Add interpretation guide

---

# Recommendations for Entire Book

## Standardization Needed

1. **Create style guide artifact:**
   - Standard pipe operator: `|>`
   - Standard factor creation pattern
   - Standard dataset loading pattern

2. **Template chunk label format:**
   - `{r load-libraries}`
   - `{r import-data}`
   - `{r wrangle-data}`
   - `{r visualize-[charttype]}`
   - `{r analyze-[testtype]}`

3. **Consistent pedagogical structure:**
   - Persiapan (ALL libraries loaded here)
   - Mengimpor Dataset
   - Merapikan Dataset
   - Analisis [Topik]
   - Latihan/Aktivitas Mandiri

---

# Estimated Effort

**Per Module:**

- Add chunk labels: 15-30 minutes
- Fix major issues: 1-2 hours
- Total per module: 2-3 hours

**All 6 Modules (04-09):**  
12-18 hours of work

**Priority Order:**

1. Module 03 (already good) - 30 min
2. Module 07 (shortest) - 2 hrs
3. Module 04, 06, 08, 09 - 3 hrs each
4. Module 05 (longest) - 4 hrs
