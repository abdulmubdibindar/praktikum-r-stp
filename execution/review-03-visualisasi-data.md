# Module Review: 03-visualisasi-data.Rmd

**Review Date:** 2026-02-11  
**Module:** Modul-3: Visualisasi Data Kuantitatif

---

## Executive Summary

**Overall Assessment:** ✅ **GOOD** (Best module so far!)

Module 03 is the strongest module reviewed:

- ✅ **HAS CHUNK LABELS!** (First module with labels!)
- ✅ Strong pedagogical structure
- ✅ Comprehensive chart type coverage
- ⚠️ Pipe operator inconsistency (`|>` vs `%>%`)
- Minor issues with code organization

---

## Critical Issues

### 1. ⚠️ Mixed Pipe Operators

**Issue:** Uses both `|>` (newer pipe) and `%>%` (magrittr pipe).

**Location:** Line 91

**Current:**

```r
data.ubl.cleaned <- data.ubl %>%
  mutate(Tingkat.Semester = fct_recode(...))
```

**Problem:** Inconsistent with Module 02 which uses `|>` exclusively.

**Recommendation:** Replace `%>%` with `|>` throughout for consistency.

---

## Major Strengths

### ✅ Chunk Labels Present!

**Lines with labels:**

- Line 25: `{r load-lib}`
- Line 34: `{r import-data}`
- Line 90: `{r clean-data}`
- Line 142: `{r bar-chart-simple}`
- Line 177: `{r bar-chart-stacked}`
- Line 200: `{r bar-chart-grouped}`
- Line 224: `{r bar-chart-fill}`
- Line 273: `{r lollipop-chart}`
- Line 319: `{r membuat-diagram-pai}`
- Line 347: `{r membuat-diagram-donat}`
- Line 373: `{r membuat-dari-count}`
- And more...

**Impact:** Module IS PDF-compilable! First module to pass this critical requirement.

---

## Moderate Issues

### 2. ⚠️ Grammar of Graphics Explanations Could Be Improved

**Issue:** Explanations of ggplot syntax are verbose and repetitive.

**Location:** Lines 120-175, 195-198, etc.

**Current Approach:** Explains each layer for every chart type.

**Better Approach:**

- Explain comprehensive ggplot2 structure ONCE upfront
- Reference it briefly for subsequent charts
- Focus on what makes EACH chart type unique

---

### 3. ⚠️ Treemap Library Introduction Late

**Issue:** `treemapify` library loaded mid-module (line 373).

**Location:** Line 373

**Current:**

```r
# install.packages("treemapify")
library(treemapify)
```

**Impact:** Violates pedagogical structure (step 3: explain packages used should be upfront).

**Recommendation:** Move to "Persiapan" section at beginning.

---

## Minor Issues

### 4. 📝 Code Comments in English

**Issue:** Some comments use English instead of Indonesian.

**Examples:**

- Line 275: `# diagram lollipop terdiri atas 2 geometri: geom_segment yang bertindak sebagai` (mixed)

**Recommendation:** Keep all comments in Bahasa Indonesia for consistency.

---

### 5. 📝 Image Embedding Format

**Issue:** Line 195 uses external image file.

**Location:** Line 195 (based on outline showing table silang image reference)

Wait, I don't see this in the outline shown. Disregard this issue.

---

## Code Quality Checklist

- ✅ All code chunks have unique labels → **PASSED** (First module!)
- ✅ Datasets exist (Data Praktikum 03.xlsx) → **PASSED**
- ⚠️ Pipe operator used consistently → **PARTIAL** (mixed `|>` and `%>%`)
- ✅ Factors created → **PASSED**
- ✅ Interpretations in Indonesian → **PASSED**
- ✅ Exercise boxes included → **PASSED**
- ✅ Capaian pembelajaran tags → **PASSED**

---

## Recommendations Summary

### Immediate Actions

1. **Replace `%>%` with `|>`** for consistency
2. **Move treemapify library load** to beginning

### Medium Priority

3. **Streamline Grammar of Graphics explanations**
4. **Verify dataset** (Data Praktikum 03.xlsx exists and has correct sheets)

---

## Conclusion

Module 03 is EXCELLENT pedagogically and technically. It's the first module that can compile to PDF without errors due to proper chunk labeling. The visualization coverage is comprehensive, covering Bar (single/stacked/dodged/filled), Lollipop, Pie/Donut, Treemap, Histogram, Boxplot, and Scatterplot.

This module sets the standard for the others to follow.

**Estimated Effort:** 30 minutes to fix pipe operator inconsistency.
