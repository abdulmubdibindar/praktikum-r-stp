---
name: rprac-module-writer
description: Skill for writing and maintaining R Bookdown practical modules for statistics courses. Use when creating or updating RMarkdown (.Rmd) module files that teach statistics to Indonesian university students. Covers data wrangling, descriptive statistics, visualizations, hypothesis testing, correlation, and regression using tidyverse/ggplot2. Ensures modules follow pedagogical structure, Bookdown standards, and use proper datasets from the datasets/ directory.
---

# R Praktikum Module Writer

This skill guides the creation and maintenance of R Markdown practical module files for statistics education in Bahasa Indonesia.

## Core Principles

### 1. Pedagogical Structure (pembuat-langkah.md)

Every module must follow this 5-step flow:

1. **Ceritakan ikhtisar kasus** - Narrate overview of the case/problem
2. **Jelaskan cara memperoleh data** - Explain how to obtain and store data
3. **Jelaskan paket yang akan digunakan** - Explain packages to be used
4. **Buat langkah-langkah yang dapat langsung diikuti** - Create step-by-step instructions
5. **Sertakan kotak latihan (`.rmdexercise`)** - Include exercise boxes for practice

### 2. Technical Standards (r-bookdown-standards.md)

**Chunk Labeling:**

- Always give unique labels to every code chunk
- Prevents LaTeX compilation failures in PDF output
- Format: `{r chunk-label-here}`

**Figure/Table Paths:**

- Use `knitr::include_graphics()` for images
- All paths relative to project root
- Example: `images/diagram.png` not `C:/Users/...`

**Dependency Management:**

- Check if `renv` is active before adding new libraries
- Never use absolute paths for libraries

**Knitr Options:**

- Set `echo = FALSE` by default unless instructed otherwise
- Set `fig.pos = 'H'` for PDF outputs (prevents floating figures)

### 3. Dataset Integration

**Available Datasets:**
All datasets are in `datasets/` directory:

- `DataUtama_mhsITERA.csv`
- `DataUtama_mhsUNILA.csv`
- `DataUtama_mhsUBL.csv`
- `DataUtama_mhsUINRIL.csv`
- Excel files: `Data Praktikum 02.xlsx`, `Data Praktikum 03.xlsx`, etc.

**Required Steps:**

1. **Check dataset validity** - Use `view_file()` to inspect datasets before writing code
2. **Verify variable names** - Check exact column names with `colnames()`
3. **Test logic** - Ensure transformations work with actual data structure
4. **Document quirks** - Note any data-specific issues (e.g., "Laki-Laki" vs "Laki-laki")

## Workflow Reference

### Build Commands

**HTML Build** (see `.agent/workflows/build-html.md`):

```bash
# turbo
echo "bookdown::clean_book(TRUE)" | radian
echo "bookdown::render_book('index.Rmd', 'bookdown::gitbook')" | radian
```

**PDF Build** (see `.agent/workflows/build-pdf.md`):

```bash
# turbo
echo "bookdown::clean_book(TRUE)" | radian
echo "tinytex::install_tinytex(); bookdown::render_book('index.Rmd', 'bookdown::pdf_book')" | radian
```

## Module Structure Template

### Module Header

```rmd
# Modul-X: [Judul Modul]

Setelah mempelajari modul ini, Anda diharapkan dapat [capaian pembelajaran] [STP-X.Y]{.capaian}

---

[Pengantar modul yang menjelaskan konteks dan tujuan pembelajaran]
```

### Section Organization

**1. Persiapan (Preparation)**

- Load required libraries (`tidyverse`, `openxlsx`, `gtsummary`, etc.)
- Explain purpose of each package

**2. Mengimpor Dataset (Import Dataset)**

- Define file and sheet variables
- Import with `read.xlsx()` or `read.csv()`
- Show preview with `head()` or `glimpse()`

**3. Merapikan Dataset (Data Wrangling)**

- Rename variables with `rename()`
- Check missing values with `is.na()` and `colSums()`
- Remove missing values with `drop_na()`
- Create factors with `factor()` for categorical variables
- Use pipe operator (`|>`) for chaining operations

**4. Analisis [Topik] (Analysis)**

- Step-by-step statistical operations
- Show code with explanations
- Display results (tables, plots)
- Provide interpretations in Indonesian

**5. Exercise Boxes**

```rmd
::: {.rmdexercise}
**Aktivitas Mandiri X: [Judul] [STP-X.Y]**

1. [Instruksi langkah pertama]
2. [Instruksi langkah kedua]
3. [Dan seterusnya]
:::
```

## Code Patterns from Existing Modules

### Data Import Pattern

```r
# Mengeset variabel tersendiri untuk nama file nama sheet
file.dibaca <- "datasets/Data Praktikum 02.xlsx"
sheet.ubl <- "DataUtama_mhsUBL"

# Mengimpor file menjadi dataset
data.ubl <- read.xlsx(file.dibaca, sheet = sheet.ubl)
```

### Pipe Operator Usage

```r
# PREFERRED: Chaining with pipe operator
data.ubl <- data.ubl |>
  rename(biaya.dalam.sepekan = biaya.dalam.seminggu) |>
  rename(Jumlah.Perjalanan.Senin = Jumlah.perjalanan.Senin) |>
  rename(jarak = `jarak.(km)`) |>
  drop_na()
```

### Factor Creation Pattern

```r
# Define factor levels
jk <- c("Laki-Laki", "Perempuan")
tingkat <- c("1 (Semester 1 – Semester 2)",
             "2 (Semester 3 – Semester 4)",
             "3 (Semester 5 - Semester 6)",
             "4 (Semester 7 - Semester 8)")

# Apply to dataset
data.ubl <- data.ubl |>
  mutate(Jenis.Kelamin = factor(Jenis.Kelamin, levels = jk),
         Tingkat.Semester = factor(Tingkat.Semester,
                                   levels = tingkat,
                                   ordered = TRUE))
```

### ggplot2 Visualization Pattern

```r
# Basic bar chart
ggplot(data.ubl.cleaned) +
  geom_bar(mapping = aes(x = Tingkat.Semester),
           fill = "skyblue", color = "black") +
  labs(
    title = "Distribusi Mahasiswa Berdasarkan Tingkat Semester",
    x = "Tingkat Semester",
    y = "Jumlah Mahasiswa"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

### Descriptive Statistics Pattern

```r
# Using gtsummary
data.ubl |>
  tbl_summary(include = c(Jenis.Kelamin, Fakultas, Tingkat.Semester)) |>
  as_flex_table()

# For numeric variables with custom statistics
data.ubl |>
  tbl_summary(
    include = c(kepemilikan.mobil, jarak),
    type = list(kepemilikan.mobil ~ "continuous"),
    statistic = list(
      kepemilikan.mobil ~ "{median} ({p25}, {p75})",
      jarak ~ "{mean} ({sd})"
    )
  ) |>
  as_flex_table()
```

## Custom Blocks

### Note Block (Pengenalan)

```rmd
::: {.rmdnote}
**Pengenalan [Konsep Baru]**

[Penjelasan konsep dengan contoh]
:::
```

### Exercise Block

```rmd
::: {.rmdexercise}
**Aktivitas Mandiri X: [Judul] [STP-X.Y]**

[Instruksi yang jelas dan terstruktur]
:::
```

### Case Study Block

```rmd
::: {.rmdkasus}
**Studi Kasus: [Judul]**

[Deskripsi kasus dan pertanyaan analisis]
:::
```

## Common Topics Covered

1. **Data Terstruktur** - Reading, structure, basic operations
2. **Statistik Deskriptif** - Mean, median, SD, IQV, percentiles
3. **Visualisasi Data** - ggplot2 (bar, lollipop, pie, treemap, histogram, boxplot, scatter)
4. **Distribusi & Interval Kepercayaan** - Normal distribution, confidence intervals
5. **Uji Hipotesis** - t-test, chi-square, ANOVA
6. **Korelasi** - Nominal/ordinal (Cramér's V, Spearman) and metric (Pearson)
7. **Regresi Linear** - Simple and multiple regression
8. **Komponen Prinsip** - PCA analysis

## Quality Checklist

Before finalizing a module:

- [ ] All code chunks have unique labels
- [ ] Datasets exist in `datasets/` directory
- [ ] Variable names match actual dataset columns
- [ ] All code tested and verified to work
- [ ] Pipe operator used for multi-step operations
- [ ] Factors created for categorical variables
- [ ] Interpretations provided in Indonesian
- [ ] Exercise boxes included with clear instructions
- [ ] Image paths are relative (not absolute)
- [ ] `echo = FALSE` set if needed for book output
- [ ] `fig.pos = 'H'` set for figures in PDF
- [ ] Grammar and spelling checked (Bahasa Indonesia)
- [ ] Capaian pembelajaran tags included [STP-X.Y]{.capaian}

## Error Prevention

**Common Pitfalls:**

1. **Case sensitivity** - "Laki-Laki" vs "Laki-laki" in factors
2. **Special characters** - Use backticks for variables like `jarak.(km)`
3. **Missing values** - Always check and handle with `drop_na()`
4. **Chunk labels** - Duplicates cause LaTeX compilation failures
5. **Dataset paths** - Verify file exists before writing import code
6. **Factor order** - Ordinal variables need `ordered = TRUE`

## Example: Creating a New Module

**Task:** Create a module on correlation analysis.

**Steps:**

1. **Research Dataset**

   ```r
   view_file("datasets/Data Praktikum 06.xlsx")
   # Check what variables are available
   ```

2. **Define Structure**
   - Persiapan (load packages: tidyverse, openxlsx, gtsummary)
   - Import data
   - Data wrangling
   - Correlation analysis (nominal/ordinal)
   - Correlation analysis (metric)
   - Exercises

3. **Write Module Following Template**

   ```rmd
   # Modul-6: Korelasi Nominal dan Ordinal

   Setelah mempelajari modul ini...

   ## Persiapan
   ...
   ```

4. **Test Code Incrementally**
   - Run each chunk in RStudio
   - Verify outputs match expectations

5. **Add Exercises**
   - Minimum 2-3 exercise boxes
   - Progressive difficulty
   - Clear instructions

6. **Build and Verify**
   ```bash
   /build-html
   ```

## Integration with Existing Project

**Related Files:**

- `.agent/rules/pembuat-langkah.md` - Pedagogical structure
- `.agent/rules/r-bookdown-standards.md` - Technical standards
- `.agent/workflows/build-html.md` - HTML build process
- `.agent/workflows/build-pdf.md` - PDF build process
- `datasets/` - All data files
- `index.Rmd` - Main book index
- `_bookdown.yml` - Book configuration

**Typical Workflow:**

1. User requests module creation/update
2. Check datasets for validity
3. Write/update .Rmd file following this skill
4. Test code chunks
5. Build HTML to verify
6. Build PDF to verify LaTeX compatibility
7. Commit changes to Git

## Remember

- **Students are first-year, second-semester** - Keep explanations clear
- **Language is Bahasa Indonesia** - Use proper Indonesian terminology
- **Practical focus** - Every concept needs hands-on practice
- **Real datasets** - Use actual student survey data from local universities
- **Step-by-step** - Never skip intermediate steps
- **Interpretations matter** - Always explain what results mean in context
