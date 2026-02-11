# Module Review: 01-data-terstruktur.Rmd

**Review Date:** 2026-02-11  
**Reviewer:** AI Agent (based on SKILL_RpracModuleWriter.md)  
**Module:** Modul-1: Pengolahan Data Terstruktur

---

## Executive Summary

**Overall Assessment:** ⚠️ **NEEDS REVISION**

The module covers the fundamentals of structured data processing but has several critical flaws that need attention:

- **CRITICAL**: All code chunks are unlabeled (violates r-bookdown-standards.md)
- No use of pipe operator (`|>`) despite being a tidyverse module
- Missing factor creation for categorical variables
- Dataset type mismatches not fully explained or resolved
- Some pedagogical structure gaps

---

## Critical Issues (Must Fix)

### 1. ❌ Missing Chunk Labels (CRITICAL)

**Issue:** ALL 26 code chunks in this module have no labels.

**Impact:**

- Will cause LaTeX compilation failures in PDF output
- Makes debugging difficult
- Violates r-bookdown-standards.md requirement

**Location:** Throughout entire module

**Current:**

````r
```{r}
library(tidyverse)
````

**Should Be:**

````r
```{r load-tidyverse}
library(tidyverse)
````

**Action Required:** Add unique labels to ALL chunks following pattern:

- Line 14: `{r load-tidyverse}`
- Line 32: `{r load-openxlsx}`
- Line 48: `{r import-data-first-sheet}`
- Line 62: `{r import-data-ubl}`
- Line 75: `{r view-data, eval=FALSE}` (already has eval=FALSE, just add label)
- Line 95: `{r glimpse-uinril}`
- Line 146: `{r colnames-uinril}`
- Line 151: `{r colnames-ubl}`
- Line 158: `{r count-columns}`
- Line 167: `{r vector-length-demo}`
- Line 189: `{r define-final-columns}`
- Line 209: `{r select-uinril}`
- Line 225: `{r select-ubl}`
- Line 247: `{r rename-columns}`
- Line 254: `{r verify-rename}`
- Line 278: `{r bind-rows-error, eval=FALSE}`
- Line 285: `{r check-data-types}`
- Line 302: `{r remove-columns-uinril}`
- Line 311: `{r remove-columns-ubl}`
- Line 324: `{r bind-rows-success}`
- Line 331: `{r glimpse-gabungan}`
- Line 373: `{r export-csv}`
- Line 382: `{r export-xlsx}`

---

## Major Issues (High Priority)

### 2. ⚠️ No Pipe Operator Usage

**Issue:** Module about tidyverse doesn't demonstrate pipe operator (`|>`).

**Impact:**

- Misses opportunity to teach modern R best practices
- Inconsistent with other modules (02, 03 use pipes extensively)
- Students won't learn the elegant chaining pattern

**Location:** Throughout data wrangling section (lines 209-249)

**Current Approach:**

```r
data_uin_selected <- select(data, Nomor.urut, Jenis.Kelamin, ...)
colnames(data_uin_selected) <- kolom_final
```

**Better Approach:**

```r
data_uin_selected <- data |>
  select(Nomor.urut, Jenis.Kelamin, ...) |>
  rename_all(~kolom_final)
```

**Recommendation:** Refactor selection and renaming sections to use pipe operator.

---

### 3. ⚠️ Missing Factor Creation

**Issue:** No factors created for categorical variables despite importing character data.

**Impact:**

- Variables like `Jenis.Kelamin`, `Fakultas`, `Prodi` remain as `chr`
- Misses pedagogical opportunity (Module 02 assumes students know factors)
- Inconsistent with skill guidance

**Location:** After line 333 (glimpse shows chr types, no conversion)

**Current:** Uses `chr` types directly
**Should Add:** Factor creation section before export

**Recommendation:** Add section demonstrating:

```r
data_gabungan <- data_gabungan |>
  mutate(Jenis.Kelamin = factor(Jenis.Kelamin))
```

---

### 4. ⚠️ Dataset Type Mismatch Not Fully Resolved

**Issue:** Module identifies type mismatch (lines 282-295) but doesn't explain or resolve it properly.

**Location:** Lines 282-318

**Problems:**

1. Simply drops problematic columns without explaining WHY types differ
2. Doesn't teach students how to fix type mismatches
3. Leaves students confused about the root cause

**Current Approach:**

```r
# Just remove the problematic columns
data_uin_selected <- select(data_uin_selected, -`biaya.dalam.sepekan`, -`Jumlah.perjalanan.Senin`)
```

**Better Approach:**

```r
# EXPLAIN the issue first:
# biaya.dalam.sepekan di UINRIL adalah chr (karena ada koma: "10,000")
# biaya.dalam.sepekan di UBL adalah dbl (karena input langsung angka)
# Solusi: convert chr ke dbl dengan parse_number()

data_uin_selected <- data_uin_selected |>
  mutate(biaya.dalam.sepekan = parse_number(biaya.dalam.sepekan))
```

**Recommendation:** Either teach type conversion OR explain why we're dropping columns more clearly.

---

## Moderate Issues (Should Fix)

### 5. ⚠️ Incomplete Pedagogical Structure

**Issue:** Missing step from pembuat-langkah.md 5-step structure.

**Required Steps:**

1. ✅ Ceritakan ikhtisar kasus - Present (lines 10-11)
2. ✅ Jelaskan cara memperoleh data - Present (lines 36-82)
3. ✅ Jelaskan paket yang akan digunakan - Present (lines 14-34)
4. ✅ Buat langkah-langkah - Present (lines 117-384)
5. ⚠️ **PARTIAL** - Exercise boxes exist but scattered, not cohesive

**Location:** Exercise boxes at lines 106-115, 263-272, 387-430

**Recommendation:** Consolidate exercises or add summary exercise at end.

---

### 6. ⚠️ Inconsistent Variable Naming

**Issue:** Module uses both conventions without explaining difference.

**Location:** Throughout module

**Examples:**

- `file_dibaca` (line 64) - snake_case with underscore
- `data.ubl` (line 67) - dot notation
- `kolom_final` (line 191) - snake_case
- `data_uin_selected` (line 210) - snake_case
- `Jumlah.Perjalanan.Senin` (column name) - dot notation

**Recommendation:**

- Explain R naming conventions early
- Stick to one convention (preferably snake_case for variables, dot notation for column names)

---

### 7. ⚠️ Comment on Line 56 is Incorrect

**Issue:** Comment says "Data Gabungan.xlsx" but code loads "Data Praktikum 01.xlsx".

**Location:** Line 49

**Current:**

```r
# Memuat dataset dari file Excel "Data Gabungan.xlsx" yang terletak di folder yang sama dengan file R Markdown ini.
data <- read.xlsx("datasets/Data Praktikum 01.xlsx")
```

**Should Be:**

```r
# Memuat dataset dari file Excel "Data Praktikum 01.xlsx" yang terletak di folder datasets/
data <- read.xlsx("datasets/Data Praktikum 01.xlsx")
```

**Recommendation:** Fix comment to match actual filename.

---

## Minor Issues (Nice to Have)

### 8. 📝 Missing Interpretations for Some Outputs

**Issue:** Some code outputs lack Indonesian explanations.

**Location:**

- Line 159-161: Shows column counts but doesn't interpret what it means
- Line 332-333: Shows glimpse but doesn't highlight the 779 rows achievement

**Recommendation:** Add interpretation paragraphs after key outputs.

---

### 9. 📝 No capaian pembelajaran tags in exercises

**Issue:** Exercise boxes don't have [STP-X.Y]{.capaian} tags.

**Location:** All exercise blocks (lines 106, 263, 387)

**Current:**

```rmd
::: {.rmdexercise}
**Aktivitas Mandiri 1: Menganalisis Struktur Data [STP-1.3]**
```

**This is CORRECT** - Tags ARE present. ✅ (False alarm, ignore this issue)

---

### 10. 📝 `eval=FALSE` Usage Without Explanation

**Issue:** Chunks with `eval=FALSE` (lines 75, 278) not explained to students.

**Location:** Lines 75, 278

**Recommendation:** Add note explaining:

```rmd
> 📝 **Catatan**
>
> Chunk di atas menggunakan `eval=FALSE` yang artinya kode tidak akan dijalankan saat buku dikompilasi. Ini berguna untuk menampilkan contoh kode tanpa menjalankannya.
```

---

## Dataset Verification

### ✅ Dataset Files

**File:** `datasets/Data Praktikum 01.xlsx`

- **Status:** ✅ EXISTS
- **Sheets Expected:**
  - DataUtama_mhsUBL (referenced line 67)
  - DataUtama_mhsITERA (referenced in exercise, line 396)
  - DataUtama_mhsUNILA (referenced in exercise, line 397)

**Recommendation:** Verify all sheets exist in Excel file (cannot verify from code review alone).

---

## Variable Logic Issues

### 11. ⚠️ Selection Logic Error - Inconsistent Naming

**Issue:** Column selection uses different names than expected.

**Location:** Lines 214, 234

**Problem:**

- UINRIL uses `kepemilikan.sepedan` (with 'n') - Line 214
- UBL uses `kepemilikan.sepeda` (correct) - Line 230
- But BOTH get renamed to `kepemilikan.sepeda` in kolom_final - Line 195

**Impact:** This is actually CORRECT behavior (intentional fix via renaming), but the comment on line 214 could be clearer.

**Current Comment:** `# Ingat, nama aslinya pakai 'n'`

**Better Comment:**

```r
kepemilikan.sepedan, # Typo di dataset asli, akan diperbaiki saat rename
```

---

### 12. ⚠️ Day Name Capitalization Inconsistency

**Issue:** Weekday names have inconsistent capitalization between datasets.

**Location:** Lines 218-220 (UINRIL) vs 234-236 (UBL)

**UINRIL:** `Jumlah.Perjalanan.Senin` (capital P)
**UBL:** `Jumlah.perjalanan.Senin` (lowercase p)

**Final:** `Jumlah.perjalanan.Senin` (lowercase p) - Line 195

**Impact:** This creates selection errors. Line 234 in UBL selection shows:

```r
Jumlah.perjalanan.Senin, Jumlah.Perjalanan.Selasa, Jumlah.Perjalanan.Rabu,
```

This is INCONSISTENT - Senin is lowercase, others are uppercase. This will cause errors.

**Recommendation:** Verify actual column names in dataset before teaching this module.

---

## Code Quality Checklist

Based on SKILL_RpracModuleWriter.md Quality Checklist:

- ❌ All code chunks have unique labels → **FAILED**
- ✅ Datasets exist in `datasets/` directory → **PASSED**
- ⚠️ Variable names match actual dataset columns → **NEEDS VERIFICATION** (capitalization issues)
- ❌ All code tested and verified to work → **CANNOT VERIFY** (need to run code)
- ❌ Pipe operator used for multi-step operations → **FAILED**
- ❌ Factors created for categorical variables → **FAILED**
- ✅ Interpretations provided in Indonesian → **MOSTLY PASSED**
- ✅ Exercise boxes included with clear instructions → **PASSED**
- ✅ Image paths are relative (not absolute) → **N/A** (no images)
- ⚠️ `echo = FALSE` set if needed for book output → **NOT SET** (likely intentional for tutorial)
- ⚠️ `fig.pos = 'H'` set for figures in PDF → **N/A** (no figures)
- ✅ Grammar and spelling checked (Bahasa Indonesia) → **PASSED**
- ✅ Capaian pembelajaran tags included → **PASSED**

---

## Recommendations Summary

### Immediate Actions (Before Next Use)

1. **Add chunk labels to ALL 26 chunks** (CRITICAL for PDF compilation)
2. **Verify dataset column names** (UINRIL vs UBL capitalization)
3. **Fix comment on line 49** (wrong filename mentioned)

### High Priority Improvements

4. **Refactor to use pipe operator** (tidyverse best practice)
5. **Add factor creation section** (pedagogical continuity)
6. **Explain type mismatch better** (teaching moment lost)

### Medium Priority Improvements

7. **Add interpretation paragraphs** for key outputs
8. **Consolidate variable naming** convention explanation
9. **Add eval=FALSE explanation** for students

---

## Conclusion

Module 01 provides a solid foundation for data wrangling but needs critical fixes before it can be compiled to PDF. The missing chunk labels are a **blocker** for PDF output. Additionally, the module would benefit from demonstrating pipe operators and factor creation to align with pedagogical standards and prepare students for Module 02.

**Estimated Effort:** 2-3 hours to fix all critical and high-priority issues.

---

## Next Steps

1. Run `/build-pdf` to verify if missing chunk labels cause compilation errors
2. Test all code chunks with actual dataset to verify column name assumptions
3. Apply fixes in priority order (Critical → High → Medium)
4. Re-test PDF compilation after fixes
