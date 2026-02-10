# 🧹 Panduan Lengkap: Data Cleaning Journey - Dataset Kampus Bandar Lampung

**Panduan Edukatif untuk Pemula**  
**Proyek**: Praktikum R - Sistem Transportasi  
**Datasets**: ITERA, UNILA, UBL, UINRIL  
**Level**: Pemula hingga Menengah

---

## 📚 Daftar Isi

1. [Pengenalan Data Cleaning](#1-pengenalan-data-cleaning)
2. [Memahami Masalah](#2-memahami-masalah)
3. [Langkah 1: Diagnosa Dataset](#3-langkah-1-diagnosa-dataset)
4. [Langkah 2: Membuat Cleaning Protocol](#4-langkah-2-membuat-cleaning-protocol)
5. [Langkah 3: Standardisasi Nama Variabel](#5-langkah-3-standardisasi-nama-variabel)
6. [Langkah 4: Konversi Tipe Data](#6-langkah-4-konversi-tipe-data)
7. [Langkah 5: Standardisasi Nilai Kategoris](#7-langkah-5-standardisasi-nilai-kategoris)
8. [Langkah 6: Menangani Missing Values](#8-langkah-6-menangani-missing-values)
9. [Langkah 7: Menghapus Kolom Tidak Perlu](#9-langkah-7-menghapus-kolom-tidak-perlu)
10. [Langkah 8: Membuat Master Script](#10-langkah-8-membuat-master-script)
11. [Langkah 9: Verifikasi Hasil](#11-langkah-9-verifikasi-hasil)
12. [Troubleshooting Umum](#12-troubleshooting-umum)
13. [Best Practices](#13-best-practices)

---

## 1. Pengenalan Data Cleaning

### Apa itu Data Cleaning?

**Data Cleaning** (pembersihan data) adalah proses memperbaiki atau menghapus data yang tidak akurat, tidak lengkap, tidak relevan, duplikat, atau tidak terformat dengan benar dari dataset.

### Mengapa Data Cleaning Penting?

> **"Garbage In, Garbage Out"** - Jika data input-nya buruk, hasil analisis juga akan buruk.

Data cleaning penting karena:

1. **Akurasi Analisis**: Data yang bersih menghasilkan analisis yang lebih akurat
2. **Konsistensi**: Data dari berbagai sumber perlu diseragamkan
3. **Efisiensi**: Data yang terstruktur lebih mudah dianalisis
4. **Reliabilitas**: Hasil yang dapat dipercaya untuk pengambilan keputusan

### Tahapan Umum Data Cleaning

```
1. Diagnosa     → Pahami masalah dalam data
2. Planning     → Buat rencana pembersihan
3. Execution    → Jalankan proses cleaning
4. Verification → Verifikasi hasil cleaning
```

---

## 2. Memahami Masalah

### 📋 Konteks Proyek

Kita memiliki **4 dataset survei transportasi mahasiswa** dari 4 universitas di Bandar Lampung:

- **ITERA** (Institut Teknologi Sumatera) - 428 responden
- **UNILA** (Universitas Lampung) - 395 responden
- **UBL** (Universitas Bandar Lampung) - 379 responden
- **UINRIL** (UIN Raden Intan Lampung) - 400 responden

**Total**: 1,602 responden

### 🔴 Masalah yang Ditemukan

#### 1. **Nama Variabel Tidak Konsisten**

```
ITERA:  "Jenis Kelamin", "Fakultas", "Prodi"
UNILA:  "Jenis.Kelamin", "fakultas", "prodi"
UBL:    "jenis.kelamin", "Fakultas", "Prodi"
UINRIL: "Jenis Kelamin", "FAKULTAS", "PRODI"
```

#### 2. **Nilai Kategoris Bervariasi**

```
Jenis Kelamin:
- "Laki-laki" vs "Laki - Laki" vs "L" vs "1"
- "Perempuan" vs "P" vs "2"

Tingkat Semester:
- "Semester 1 - 2" vs "1" vs "Semester 1" vs "1-2"
```

#### 3. **Tipe Data Tidak Sesuai**

```r
jarak <- "5,5"      # Harusnya numeric: 5.5
usia <- "20 tahun"  # Harusnya numeric: 20
```

#### 4. **Missing Values**

```
ITERA:  1 missing di jarak.km
UNILA:  1 missing di jarak.km, 1 observasi semua jumlah perjalanan NA
UBL:    3 missing di kepemilikan.mobil, 1 di kepemilikan.sepeda, 4 di alamat
```

#### 5. **Encoding Issues (UTF-8)**

Karakter khusus yang tidak terbaca menyebabkan error saat processing.

#### 6. **Delimiter Issues (UBL)**

File CSV UBL menggunakan koma tetapi ada data yang mengandung koma, menyebabkan parsing error.

---

## 3. Langkah 1: Diagnosa Dataset

### 🔍 Tujuan

Memahami struktur dan masalah dalam setiap dataset sebelum membersihkan.

### 📝 Script Diagnosa

Buat file `diagnosa_dataset.R`:

```r
# =============================================================================
# SCRIPT DIAGNOSA DATASET
# =============================================================================

library(readr)

# Function untuk diagnosa satu dataset
diagnosa_dataset <- function(file_path, dataset_name) {
  cat("\n========================================\n")
  cat("Dataset:", dataset_name, "\n")
  cat("========================================\n\n")

  # Baca data
  data <- read_delim(file_path,
                     delim = ";",
                     col_types = cols(.default = col_character()))

  # 1. Dimensi data
  cat("1. DIMENSI\n")
  cat("   Rows:", nrow(data), "\n")
  cat("   Columns:", ncol(data), "\n\n")

  # 2. Nama kolom
  cat("2. NAMA KOLOM\n")
  print(names(data))
  cat("\n")

  # 3. Tipe data
  cat("3. TIPE DATA\n")
  print(sapply(data, class))
  cat("\n")

  # 4. Missing values
  cat("4. MISSING VALUES\n")
  missing_summary <- sapply(data, function(x) sum(is.na(x)))
  missing_summary <- missing_summary[missing_summary > 0]

  if (length(missing_summary) > 0) {
    print(missing_summary)
  } else {
    cat("   Tidak ada missing values!\n")
  }
  cat("\n")

  # 5. Sample data (5 baris pertama)
  cat("5. SAMPLE DATA (5 baris pertama)\n")
  print(head(data, 5))
  cat("\n")

  return(data)
}

# Diagnosa semua dataset
data_itera <- diagnosa_dataset("datasets/olah_ulang/DataUtama_mhsITERA.csv", "ITERA")
data_unila <- diagnosa_dataset("datasets/olah_ulang/DataUtama_mhsUNILA.csv", "UNILA")
data_ubl <- diagnosa_dataset("datasets/olah_ulang/DataUtama_mhsUBL.csv", "UBL")
data_uinril <- diagnosa_dataset("datasets/olah_ulang/DataUtama_mhsUINRIL.csv", "UINRIL")
```

### 💡 Penjelasan Kode

**1. `read_delim()` dengan `col_types = cols(.default = col_character())`**

Mengapa? Karena kita ingin membaca SEMUA kolom sebagai character dulu untuk melihat isinya tanpa konversi otomatis yang mungkin salah.

**2. `sapply(data, class)`**

Memeriksa tipe data setiap kolom. Ini penting untuk tahu kolom mana yang perlu dikonversi.

**3. `sapply(data, function(x) sum(is.na(x)))`**

Menghitung jumlah missing values di setiap kolom. Ini membantu kita merencanakan strategi handling.

### ✅ Output yang Diharapkan

```
========================================
Dataset: ITERA
========================================

1. DIMENSI
   Rows: 428
   Columns: 26

2. NAMA KOLOM
 [1] "Timestamp"           "Kampus_PT"
 [3] "Jenis Kelamin"       "Umur"
 [5] "Fakultas"            "Prodi"
 ...

3. TIPE DATA
         Timestamp          Kampus_PT     Jenis Kelamin
       "character"        "character"        "character"
...

4. MISSING VALUES
   jarak..km.
            1
```

---

## 4. Langkah 2: Membuat Cleaning Protocol

### 📋 Apa itu Cleaning Protocol?

**Cleaning Protocol** adalah dokumen yang berisi **aturan-aturan** untuk membersihkan data. Ini seperti "resep" yang harus diikuti agar hasil cleaning konsisten.

### 📄 Contoh Cleaning Protocol

Buat file `cleaning_protocol.md`:

```markdown
# Data Cleaning Protocol

## 1. Standardisasi Nama Variabel

**Aturan**: Semua nama variabel harus lowercase dengan dot separator (.)

| Nama Asli               | Nama Baru               |
| ----------------------- | ----------------------- |
| Jenis Kelamin           | jenis.kelamin           |
| Tingkat Semester        | tingkat.semester        |
| kepemilikan mobil       | jumlah.mobil            |
| jarak (km)              | jarak.km                |
| Jumlah Perjalanan Senin | jumlah.perjalanan.senin |

## 2. Konversi Tipe Data

| Variabel      | Tipe Asli | Tipe Baru |
| ------------- | --------- | --------- |
| usia          | character | numeric   |
| jarak.km      | character | numeric   |
| jumlah.mobil  | character | numeric   |
| jenis.kelamin | character | factor    |

## 3. Standardisasi Nilai Kategoris

### jenis.kelamin (2 levels)

- "Laki-laki" ← ["Laki-laki", "L", "1", "laki", "Laki - laki"]
- "Perempuan" ← ["Perempuan", "P", "2", "perempuan"]

### tingkat.semester (4 levels, ordered)

1. "Semester 1 - 2" ← ["1", "Semester 1", "Semester 2", "1-2"]
2. "Semester 3 - 4" ← ["2", "Semester 3", "Semester 4", "3-4"]
3. "Semester 5 - 6" ← ["3", "Semester 5", "Semester 6", "5-6"]
4. "Semester 7 - 8 ke atas" ← ["4", "Semester 7", "Semester 8", "7-8"]

## 4. Handling Missing Values

| Variabel             | Dataset | Strategi         | Alasan                     |
| -------------------- | ------- | ---------------- | -------------------------- |
| jarak.km             | ITERA   | Impute median    | Missing < 1%, non-critical |
| jarak.km             | UNILA   | Impute median    | Missing < 1%, non-critical |
| jumlah.mobil         | UBL     | Impute median    | Missing < 1%, non-critical |
| jumlah.sepeda        | UBL     | Impute median    | Missing < 1%, non-critical |
| jumlah.perjalanan.\* | UNILA   | Drop observation | Semua hari missing (1 obs) |
| biaya.dalam.ribu     | UBL     | Drop observation | Outlier invalid (1 obs)    |
| alamat               | UBL     | Keep as NA       | Non-critical variable      |

## 5. Kolom yang Dihapus

- `Timestamp`: Tidak diperlukan untuk analisis
- `kelurahan`: Tidak diperlukan (ITERA, UBL, UINRIL)
- `biaya.dalam.seminggu.raw`: Sudah dikonversi ke biaya.dalam.ribu
```

### 💡 Mengapa Protocol Penting?

1. **Konsistensi**: Semua orang mengikuti aturan yang sama
2. **Dokumentasi**: Keputusan cleaning tercatat dengan jelas
3. **Reproducibility**: Proses bisa diulang dengan hasil yang sama
4. **Transparansi**: Orang lain bisa memahami apa yang dilakukan

---

## 5. Langkah 3: Standardisasi Nama Variabel

### 🎯 Tujuan

Membuat semua nama variabel konsisten: **lowercase + dot separator**

### 📝 Kenapa Penting?

```r
# Inkonsisten = Sulit!
data$Jenis.Kelamin  # Dataset A
data$jenis_kelamin  # Dataset B
data$`Jenis Kelamin`  # Dataset C (perlu backtick!)

# Konsisten = Mudah!
data$jenis.kelamin  # Semua dataset sama
```

### 💻 Implementasi

```r
# Function: Rename variabel
rename_variables <- function(data, dataset_name) {
  cat("  → Renaming variables to lowercase...\n")

  # Mapping nama variabel
  rename_map <- c(
    "Timestamp" = "timestamp",
    "Kampus_PT" = "kampus",
    "Nomor urut" = "nomor.urut",
    "Nomor.urut" = "nomor.urut",
    "Jenis Kelamin" = "jenis.kelamin",
    "Jenis.Kelamin" = "jenis.kelamin",
    "Umur" = "usia",
    "Fakultas" = "fakultas",
    "Prodi" = "prodi",
    "Tingkat Semester" = "tingkat.semester",
    "Tingkat.Semester" = "tingkat.semester",
    "Uang Saku" = "uang.saku",
    "Uang.Saku" = "uang.saku",
    "kepemilikan mobil" = "jumlah.mobil",
    "kepemilikan.mobil" = "jumlah.mobil",
    "Jumlah.motor" = "jumlah.motor",
    "kepemilikan motor" = "jumlah.motor",
    "kepemilikan.motor" = "jumlah.motor",
    "kepemilikan sepeda" = "jumlah.sepeda",
    "kepemilikan.sepeda" = "jumlah.sepeda",
    "kendaraan utama" = "kendaraan.utama",
    "kendaraan.utama" = "kendaraan.utama",
    "jenis tempat tinggal" = "jenis.tempat.tinggal",
    "jenis.tempat.tinggal" = "jenis.tempat.tinggal",
    "nama jalan tempat tinggal" = "alamat",
    "nama.jalan.tempat.tinggal" = "alamat",
    "jarak (km)" = "jarak.km",
    "jarak..km." = "jarak.km",
    "alasan pemilihan lokasi tempat tinggal" = "alasan.lokasi",
    "alasan.pemilihan.lokasi.tempat.tinggal" = "alasan.lokasi",
    "biaya dalam seminggu" = "biaya.dalam.seminggu.raw",
    "biaya.dalam.seminggu" = "biaya.dalam.seminggu.raw",
    "biaya.dalam.ribu" = "biaya.dalam.ribu",
    "biaya.dalam.ribu2" = "biaya.dalam.ribu",
    "Jumlah perjalanan Senin" = "jumlah.perjalanan.senin",
    "Jumlah.perjalanan.Senin" = "jumlah.perjalanan.senin",
    "Jumlah Perjalanan Selasa" = "jumlah.perjalanan.selasa",
    "Jumlah.Perjalanan.Selasa" = "jumlah.perjalanan.selasa"
    # ... dan seterusnya untuk hari lainnya
  )

  # Apply renaming
  old_names <- names(data)
  new_names <- old_names

  for (i in 1:length(old_names)) {
    if (old_names[i] %in% names(rename_map)) {
      new_names[i] <- rename_map[old_names[i]]
    }
  }

  names(data) <- new_names

  cat("    ✓", sum(old_names != new_names), "variables renamed\n")
  return(data)
}

# Contoh penggunaan
data_clean <- rename_variables(data_itera, "ITERA")
```

### 💡 Penjelasan Kode

**1. Named Vector untuk Mapping**

```r
rename_map <- c("Nama Lama" = "nama.baru")
```

Ini seperti kamus: kunci (nama lama) → nilai (nama baru).

**2. Loop untuk Mengganti Nama**

```r
for (i in 1:length(old_names)) {
  if (old_names[i] %in% names(rename_map)) {
    new_names[i] <- rename_map[old_names[i]]
  }
}
```

Cek setiap nama lama, jika ada di mapping, ganti dengan nama baru.

**3. Assignment ke names()**

```r
names(data) <- new_names
```

Langsung assign nama kolom baru ke dataframe.

### ✅ Hasil

```
✓ 18 variables renamed
```

Nama kolom sekarang konsisten!

---

## 6. Langkah 4: Konversi Tipe Data

### 🎯 Tujuan

Mengubah tipe data dari character ke tipe yang sesuai (numeric, factor, dll).

### 📝 Kenapa Penting?

```r
# Character = Tidak bisa dihitung
mean("5.5")  # Error!

# Numeric = Bisa dihitung
mean(5.5)  # OK! = 5.5
```

### 💻 Implementasi: Konversi jarak.km

**Masalah**: Jarak ditulis dengan koma "5,5" bukan "5.5"

```r
# Function: Convert jarak.km ke numeric
convert_jarak_km <- function(data) {
  cat("  → Converting jarak.km to numeric...\n")

  if ("jarak.km" %in% names(data)) {
    # Replace comma dengan period
    data$jarak.km <- gsub(",", ".", data$jarak.km)

    # Convert ke numeric
    data$jarak.km <- as.numeric(data$jarak.km)

    cat("    ✓ jarak.km converted\n")
  } else {
    cat("    ! jarak.km not found\n")
  }

  return(data)
}
```

### 💡 Penjelasan: `gsub()`

```r
gsub(",", ".", "5,5")
# Hasil: "5.5"

# Pattern: gsub(pattern, replacement, x)
# - pattern: apa yang mau diganti (",")
# - replacement: diganti dengan apa (".")
# - x: di string mana ("5,5")
```

### 💻 Implementasi: Konversi Semua Numeric

```r
# Function: Convert numeric columns
convert_numeric_columns <- function(data) {
  cat("  → Converting numeric columns...\n")

  numeric_cols <- c(
    "usia",
    "jumlah.mobil",
    "jumlah.motor",
    "jumlah.sepeda",
    "jarak.km",
    "biaya.dalam.ribu",
    "jumlah.perjalanan.senin",
    "jumlah.perjalanan.selasa",
    "jumlah.perjalanan.rabu",
    "jumlah.perjalanan.kamis",
    "jumlah.perjalanan.jumat",
    "jumlah.perjalanan.sabtu",
    "jumlah.perjalanan.minggu"
  )

  for (col in numeric_cols) {
    if (col %in% names(data)) {
      data[[col]] <- as.numeric(data[[col]])
    }
  }

  cat("    ✓ Numeric columns converted\n")
  return(data)
}
```

### 💡 Penjelasan: `data[[col]]`

```r
# Double bracket [[]] untuk akses kolom dinamis
col <- "usia"
data[[col]]  # Sama dengan data$usia

# Single bracket [] untuk subset
data[col]    # Hasilnya data frame, bukan vector
```

### ⚠️ Warning: NA Introduction

Saat konversi, jika ada nilai yang tidak bisa dikonversi, hasilnya NA:

```r
as.numeric("20 tahun")
# Warning: NAs introduced by coercion
# Hasil: NA
```

Solusi: **Bersihkan dulu** sebelum konversi!

```r
x <- "20 tahun"
x <- gsub(" tahun", "", x)  # Hapus " tahun"
as.numeric(x)  # Hasil: 20
```

---

## 7. Langkah 5: Standardisasi Nilai Kategoris

### 🎯 Tujuan

Menyeragamkan nilai-nilai kategoris dan mengkonversi ke **factor** dengan level yang konsisten.

### 📝 Kenapa Menggunakan Factor?

**Factor** adalah tipe data khusus untuk variabel kategoris dengan **level** yang terbatas.

```r
# Character - Tidak ada level
jk <- c("Laki-laki", "Perempuan", "Laki-laki")
class(jk)  # "character"

# Factor - Punya level
jk_factor <- factor(jk, levels = c("Laki-laki", "Perempuan"))
class(jk_factor)  # "factor"
levels(jk_factor)  # "Laki-laki" "Perempuan"
```

**Keuntungan Factor**:

1. Analisis lebih cepat
2. Plotting otomatis urut sesuai level
3. Validasi data (hanya menerima nilai dalam level)

### 💻 Implementasi: jenis.kelamin

```r
# Function: Standardize jenis.kelamin
standardize_jenis_kelamin <- function(data) {
  cat("  → Standardizing jenis.kelamin...\n")

  if ("jenis.kelamin" %in% names(data)) {
    data$jenis.kelamin <- trimws(data$jenis.kelamin)

    # Mapping dengan case_when
    data$jenis.kelamin <- case_when(
      data$jenis.kelamin == "1" ~ "Laki-laki",
      data$jenis.kelamin == "2" ~ "Perempuan",
      grepl("laki", data$jenis.kelamin, ignore.case = TRUE) ~ "Laki-laki",
      grepl("perempuan", data$jenis.kelamin, ignore.case = TRUE) ~ "Perempuan",
      TRUE ~ data$jenis.kelamin
    )

    # Convert to factor
    data$jenis.kelamin <- factor(data$jenis.kelamin,
                                  levels = c("Laki-laki", "Perempuan"))

    cat("    ✓ jenis.kelamin standardized\n")
  }

  return(data)
}
```

### 💡 Penjelasan: `case_when()`

`case_when()` dari paket `dplyr` adalah versi powerful dari `ifelse()`:

```r
case_when(
  kondisi1 ~ hasil1,
  kondisi2 ~ hasil2,
  TRUE ~ hasil_default
)

# Contoh
x <- c("1", "L", "Laki-laki", "Perempuan", "2")

case_when(
  x == "1" ~ "Laki-laki",
  x == "2" ~ "Perempuan",
  grepl("laki", x, ignore.case = TRUE) ~ "Laki-laki",
  grepl("perempuan", x, ignore.case = TRUE) ~ "Perempuan",
  TRUE ~ x
)
# Hasil: "Laki-laki" "Laki-laki" "Laki-laki" "Perempuan" "Perempuan"
```

### 💡 Penjelasan: `grepl()`

`grepl()` = **grep** + **logical** (TRUE/FALSE)

```r
grepl(pattern, x, ignore.case = TRUE)

# Contoh
grepl("laki", "Laki-laki", ignore.case = TRUE)  # TRUE
grepl("laki", "Perempuan", ignore.case = TRUE)  # FALSE

# ignore.case untuk case-insensitive
grepl("laki", "LAKI-LAKI", ignore.case = TRUE)  # TRUE
```

### 💻 Implementasi: tingkat.semester (Ordered Factor)

```r
# Function: Standardize tingkat.semester
standardize_tingkat_semester <- function(data) {
  cat("  → Standardizing tingkat.semester...\n")

  if ("tingkat.semester" %in% names(data)) {
    # Fix UTF-8 encoding
    data$tingkat.semester <- enc2utf8(as.character(data$tingkat.semester))
    data$tingkat.semester <- iconv(data$tingkat.semester, "UTF-8", "UTF-8", sub = "")
    data$tingkat.semester <- trimws(data$tingkat.semester)

    # Mapping
    data$tingkat.semester <- case_when(
      data$tingkat.semester == "1" ~ "Semester 1 - 2",
      grepl("1.*2|semester 1|semester 2", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 1 - 2",
      data$tingkat.semester == "2" ~ "Semester 3 - 4",
      grepl("3.*4|semester 3|semester 4", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 3 - 4",
      data$tingkat.semester == "3" ~ "Semester 5 - 6",
      grepl("5.*6|semester 5|semester 6", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 5 - 6",
      data$tingkat.semester == "4" ~ "Semester 7 - 8 ke atas",
      grepl("7.*8|semester 7|semester 8|ke atas", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 7 - 8 ke atas",
      TRUE ~ data$tingkat.semester
    )

    # Convert to ORDERED factor
    data$tingkat.semester <- factor(data$tingkat.semester,
                                     levels = c(
                                       "Semester 1 - 2",
                                       "Semester 3 - 4",
                                       "Semester 5 - 6",
                                       "Semester 7 - 8 ke atas"
                                     ),
                                     ordered = TRUE)

    cat("    ✓ tingkat.semester standardized\n")
  }

  return(data)
}
```

### 💡 Penjelasan: Ordered Factor

**Ordered Factor** = Factor dengan urutan yang bermakna

```r
# Factor biasa
kendaraan <- factor(c("Motor", "Mobil", "Jalan kaki"))
kendaraan > "Motor"  # Error! Tidak bisa dibandingkan

# Ordered factor
semester <- factor(c("Semester 1 - 2", "Semester 5 - 6", "Semester 3 - 4"),
                   levels = c("Semester 1 - 2", "Semester 3 - 4", "Semester 5 - 6"),
                   ordered = TRUE)

semester[1] < semester[2]  # TRUE (Semester 1-2 < Semester 5-6)
```

### 💡 Penjelasan: UTF-8 Encoding Fix

**Masalah**: Karakter non-ASCII kadang menyebabkan error

```r
# Error: input string 2 is invalid UTF-8
trimws("Semester 1 – 2")  # Em dash (–) vs hyphen (-)
```

**Solusi**: Fix encoding sebelum processing

```r
# 1. Convert ke UTF-8
x <- enc2utf8(as.character(x))

# 2. Clean invalid UTF-8
x <- iconv(x, "UTF-8", "UTF-8", sub = "")

# 3. Baru trim
x <- trimws(x)
```

---

## 8. Langkah 6: Menangani Missing Values

### 🎯 Tujuan

Mengatasi missing values (NA) dengan strategi yang tepat.

### 📝 Strategi Umum

| Strategi          | Kapan Digunakan                            | Contoh                                     |
| ----------------- | ------------------------------------------ | ------------------------------------------ |
| **Drop**          | Missing banyak atau variabel tidak penting | Drop observasi dengan semua travel days NA |
| **Impute Mean**   | Data numerik, distribusi normal            | Usia, tinggi badan                         |
| **Impute Median** | Data numerik, ada outlier                  | Jarak, biaya                               |
| **Impute Mode**   | Data kategoris                             | Jenis kelamin, kendaraan                   |
| **Keep as NA**    | Non-critical, tidak mengganggu analisis    | Alamat, nomor telepon                      |

### 💻 Implementasi: Impute Median

```r
# Strategi: Impute median untuk jarak.km (ITERA & UNILA)
if (dataset_name %in% c("ITERA", "UNILA") && "jarak.km" %in% names(data)) {
  # Hitung median dari data yang tidak NA
  median_jarak <- median(data$jarak.km, na.rm = TRUE)

  # Hitung jumlah missing
  n_missing <- sum(is.na(data$jarak.km))

  if (n_missing > 0) {
    # Replace NA dengan median
    data$jarak.km[is.na(data$jarak.km)] <- median_jarak

    cat("    ✓ jarak.km:", n_missing, "missing values imputed with median =",
        median_jarak, "\n")
  }
}
```

### 💡 Penjelasan: Median vs Mean

**Kenapa Median?**

```r
# Data dengan outlier
jarak <- c(1, 2, 3, 4, 5, 100)  # 100 adalah outlier

mean(jarak)    # 19.17 (dipengaruhi outlier)
median(jarak)  # 3.5 (tidak terpengaruh outlier)
```

Median lebih **robust** terhadap outlier!

### 💡 Penjelasan: `na.rm = TRUE`

```r
x <- c(1, 2, NA, 4, 5)

mean(x)              # NA (jika ada NA, hasilnya NA)
mean(x, na.rm = TRUE)  # 3 (remove NA dulu baru hitung)

# na.rm = NA Remove
```

### 💻 Implementasi: Drop Observations

```r
# Strategi: Drop observasi dengan ALL jumlah perjalanan missing (UNILA)
if (dataset_name == "UNILA") {
  cols_perjalanan <- grep("jumlah\\.perjalanan\\.", names(data), value = TRUE)

  if (length(cols_perjalanan) > 0) {
    # Identifikasi baris dengan SEMUA perjalanan NA
    all_na <- rowSums(is.na(data[cols_perjalanan])) == length(cols_perjalanan)
    n_drop <- sum(all_na)

    if (n_drop > 0) {
      # Drop baris tersebut
      data <- data[!all_na, ]
      cat("    ✓", n_drop, "observations dropped (all jumlah.perjalanan missing)\n")
    }
  }
}
```

### 💡 Penjelasan: `rowSums()` + `is.na()`

```r
# Contoh data
df <- data.frame(
  senin = c(2, NA, NA),
  selasa = c(3, NA, 1),
  rabu = c(1, NA, 2)
)

# Hitung jumlah NA per baris
rowSums(is.na(df))
# Hasil: 0 3 0
#        ^  ^ ^
#        |  | +-- Baris 3: 0 NA
#        |  +---- Baris 2: 3 NA (semua kolom NA!)
#        +------- Baris 1: 0 NA

# Identifikasi baris dengan SEMUA kolom NA
rowSums(is.na(df)) == ncol(df)
# Hasil: FALSE TRUE FALSE
#         ^     ^    ^
#         |     |    +-- Baris 3: Tidak semua NA
#         |     +------- Baris 2: SEMUA NA!
#         +------------- Baris 1: Tidak semua NA
```

---

## 9. Langkah 7: Menghapus Kolom Tidak Perlu

### 🎯 Tujuan

Menghapus kolom yang tidak diperlukan untuk analisis.

### 💻 Implementasi

```r
# Function: Remove unwanted columns
remove_unwanted_columns <- function(data, dataset_name) {
  cat("  → Removing unwanted columns...\n")

  # Kolom yang akan dihapus
  cols_to_remove <- c("timestamp", "biaya.dalam.seminggu.raw", "kelurahan")

  # Cek kolom mana yang ada di dataset
  cols_exist <- cols_to_remove[cols_to_remove %in% names(data)]

  if (length(cols_exist) > 0) {
    # Hapus kolom dengan select(-kolom)
    data <- data %>% select(-all_of(cols_exist))

    cat("    ✓", length(cols_exist), "columns removed:",
        paste(cols_exist, collapse = ", "), "\n")
  } else {
    cat("    ! No columns to remove\n")
  }

  return(data)
}
```

### 💡 Penjelasan: `select()` dan `-`

```r
library(dplyr)

# Pilih kolom yang mau diambil
data %>% select(kampus, usia, jarak.km)

# Pilih kolom yang mau DIHAPUS (minus/-)
data %>% select(-timestamp, -kelurahan)

# Hapus kolom dinamis dengan all_of()
cols_to_remove <- c("timestamp", "kelurahan")
data %>% select(-all_of(cols_to_remove))
```

### 💡 Penjelasan: Pipe Operator `%>%`

**Pipe** (`%>%`) dari paket `dplyr` membuat kode lebih **readable**:

```r
# Tanpa pipe - nested, baca dari dalam ke luar
filtered_data <- filter(select(data, usia, jarak.km), usia > 18)

# Dengan pipe - sequential, baca dari kiri ke kanan
data %>%
  select(usia, jarak.km) %>%
  filter(usia > 18)
```

Cara baca: "data, **LALU** select, **LALU** filter"

---

## 10. Langkah 8: Membuat Master Script

### 🎯 Tujuan

Menggabungkan semua function menjadi satu script yang dapat **otomatis** memproses semua dataset.

### 📁 Struktur Script

```
master_cleaning.R
├── 1. Load Libraries
├── 2. Helper Functions
│   ├── rename_variables()
│   ├── convert_jarak_km()
│   ├── standardize_jenis_kelamin()
│   ├── standardize_tingkat_semester()
│   ├── standardize_uang_saku()
│   ├── standardize_kendaraan_utama()
│   ├── standardize_jenis_tempat_tinggal()
│   ├── handle_missing_values()
│   └── remove_unwanted_columns()
├── 3. Main Cleaning Function
│   └── clean_dataset()
├── 4. Execution
│   ├── Clean ITERA
│   ├── Clean UNILA
│   ├── Clean UBL
│   └── Clean UINRIL
└── 5. Generate Summary
```

### 💻 Main Cleaning Function

```r
# =============================================================================
# MAIN CLEANING FUNCTION
# =============================================================================

clean_dataset <- function(file_path, dataset_name, output_path) {
  cat("\n=================================================\n")
  cat("CLEANING DATASET:", dataset_name, "\n")
  cat("=================================================\n\n")

  # Step 1: Read data
  cat("Step 1: Reading data...\n")
  data <- read_delim(file_path,
                     delim = ";",
                     locale = locale(encoding = "UTF-8"),
                     col_types = cols(.default = col_character()),
                     trim_ws = TRUE)

  cat("  ✓ Rows:", nrow(data), "\n")
  cat("  ✓ Columns:", ncol(data), "\n\n")

  # Step 2: Rename variables
  cat("Step 2: Renaming variables...\n")
  data <- rename_variables(data, dataset_name)
  cat("\n")

  # Step 3: Convert data types
  cat("Step 3: Converting data types...\n")
  data <- convert_jarak_km(data)
  data <- convert_jumlah_perjalanan(data)
  data <- convert_numeric_columns(data)
  cat("\n")

  # Step 4: Standardize categorical variables
  cat("Step 4: Standardizing categorical variables...\n")
  data <- standardize_jenis_kelamin(data)
  data <- standardize_tingkat_semester(data)
  data <- standardize_uang_saku(data)
  data <- standardize_kendaraan_utama(data)
  data <- standardize_jenis_tempat_tinggal(data)
  cat("\n")

  # Step 5: Handle missing values
  cat("Step 5: Handling missing values...\n")
  data <- handle_missing_values(data, dataset_name)
  cat("\n")

  # Step 6: Remove unwanted columns
  cat("Step 6: Removing unwanted columns...\n")
  data <- remove_unwanted_columns(data, dataset_name)
  cat("\n")

  # Step 7: Save cleaned data
  cat("Step 7: Saving cleaned data...\n")
  write_delim(data,
              output_path,
              delim = ";",
              na = "",
              quote = "needed",
              escape = "double")

  cat("  ✓ Saved to:", output_path, "\n")
  cat("  ✓ Final rows:", nrow(data), "\n")
  cat("  ✓ Final columns:", ncol(data), "\n")

  cat("\n✅ CLEANING COMPLETED FOR", dataset_name, "\n")

  return(data)
}
```

### 💻 Execution

```r
# =============================================================================
# EXECUTE CLEANING FOR ALL DATASETS
# =============================================================================

# Ensure output directory exists
if (!dir.exists("datasets/olah_ulang/cleaned")) {
  dir.create("datasets/olah_ulang/cleaned")
}

# Clean ITERA
data_itera <- clean_dataset(
  "datasets/olah_ulang/DataUtama_mhsITERA.csv",
  "ITERA",
  "datasets/olah_ulang/cleaned/DataUtama_mhsITERA_clean.csv"
)

# Clean UNILA
data_unila <- clean_dataset(
  "datasets/olah_ulang/DataUtama_mhsUNILA.csv",
  "UNILA",
  "datasets/olah_ulang/cleaned/DataUtama_mhsUNILA_clean.csv"
)

# Clean UBL
data_ubl <- clean_dataset(
  "datasets/olah_ulang/DataUtama_mhsUBL.csv",
  "UBL",
  "datasets/olah_ulang/cleaned/DataUtama_mhsUBL_clean.csv"
)

# Clean UINRIL
data_uinril <- clean_dataset(
  "datasets/olah_ulang/DataUtama_mhsUINRIL.csv",
  "UINRIL",
  "datasets/olah_ulang/cleaned/DataUtama_mhsUINRIL_clean.csv"
)

# =============================================================================
# GENERATE SUMMARY REPORT
# =============================================================================

cat("\n")
cat("=================================================\n")
cat("CLEANING SUMMARY\n")
cat("=================================================\n\n")

summary_df <- data.frame(
  Dataset = c("ITERA", "UNILA", "UBL", "UINRIL", "TOTAL"),
  Rows = c(
    nrow(data_itera), nrow(data_unila), nrow(data_ubl), nrow(data_uinril),
    nrow(data_itera) + nrow(data_unila) + nrow(data_ubl) + nrow(data_uinril)
  ),
  Columns = c(ncol(data_itera), ncol(data_unila), ncol(data_ubl), ncol(data_uinril), "-")
)

print(summary_df)

cat("\n✅ ALL DATASETS CLEANED SUCCESSFULLY!\n")
```

### 💡 Best Practice: Modular Functions

**Kenapa pakai banyak function kecil?**

1. **Readability**: Mudah dibaca dan dipahami
2. **Reusability**: Function bisa dipakai lagi
3. **Testing**: Mudah test satu function
4. **Debugging**: Mudah cari bug
5. **Maintenance**: Mudah update

```r
# ❌ Bad: Satu function besar
clean_everything <- function(data) {
  # 500 baris kode...
}

# ✅ Good: Banyak function kecil
data %>%
  rename_variables() %>%
  convert_types() %>%
  standardize_categoricals() %>%
  handle_missing() %>%
  remove_columns()
```

---

## 11. Langkah 9: Verifikasi Hasil

### 🎯 Tujuan

Memastikan proses cleaning berhasil dan data sudah sesuai ekspektasi.

### 💻 Script Verifikasi

```r
# =============================================================================
# SCRIPT VERIFIKASI HASIL CLEANING
# =============================================================================

library(readr)
library(dplyr)

# Function untuk verifikasi dataset
verify_dataset <- function(file_path, dataset_name) {
  cat('\n-------------------------------------------------\n')
  cat('Dataset:', dataset_name, '\n')
  cat('-------------------------------------------------\n')

  # Baca data
  data <- read_delim(file_path,
                     delim = ';',
                     locale = locale(encoding = 'UTF-8'),
                     col_types = cols(.default = col_guess()))

  # 1. Dimensi
  cat('✓ Rows:', nrow(data), '\n')
  cat('✓ Columns:', ncol(data), '\n\n')

  # 2. Struktur
  cat('Struktur Kolom:\n')
  cat('---------------\n')
  str(data, max.level = 1)

  # 3. Factor Levels
  cat('\n\nFaktor Levels:\n')
  cat('-------------\n')

  factor_vars <- c('jenis.kelamin', 'tingkat.semester', 'uang.saku',
                   'kendaraan.utama', 'jenis.tempat.tinggal')

  for (var in factor_vars) {
    if (var %in% names(data) && is.factor(data[[var]])) {
      cat(' ', var, '(', nlevels(data[[var]]), 'levels ):\n')
      cat('   ', paste(levels(data[[var]]), collapse = ', '), '\n')
      cat('   Frekuensi:', paste(table(data[[var]]), collapse = ', '), '\n\n')
    }
  }

  # 4. Missing Values
  cat('Missing Values:\n')
  cat('---------------\n')
  missing_summary <- sapply(data, function(x) sum(is.na(x)))
  missing_summary <- missing_summary[missing_summary > 0]

  if (length(missing_summary) > 0) {
    for (i in 1:length(missing_summary)) {
      cat(' ', names(missing_summary)[i], ':', missing_summary[i], '\n')
    }
  } else {
    cat(' ✓ No missing values!\n')
  }

  cat('\n')
  return(data)
}

# Verifikasi semua dataset
data_itera <- verify_dataset('datasets/olah_ulang/cleaned/DataUtama_mhsITERA_clean.csv', 'ITERA')
data_unila <- verify_dataset('datasets/olah_ulang/cleaned/DataUtama_mhsUNILA_clean.csv', 'UNILA')
data_ubl <- verify_dataset('datasets/olah_ulang/cleaned/DataUtama_mhsUBL_clean.csv', 'UBL')
data_uinril <- verify_dataset('datasets/olah_ulang/cleaned/DataUtama_mhsUINRIL_clean.csv', 'UINRIL')
```

### 📊 Checklist Verifikasi

| Item               | What to Check                 | Expected                                      |
| ------------------ | ----------------------------- | --------------------------------------------- |
| **Rows**           | Jumlah baris setelah cleaning | ITERA: 428, UNILA: 394, UBL: 378, UINRIL: 400 |
| **Columns**        | Jumlah kolom                  | Semua 24 kolom                                |
| **Data Types**     | Tipe data setiap kolom        | Numeric untuk angka, Factor untuk kategoris   |
| **Factor Levels**  | Level factor sesuai protocol  | jenis.kelamin: 2, tingkat.semester: 4, dll    |
| **Missing Values** | Jumlah NA minimal             | Target: 0 untuk variabel kritis               |
| **Value Ranges**   | Range nilai wajar             | Usia: 17-30, Jarak: 0-50 km                   |

### ✅ Hasil Verifikasi yang Baik

```
-------------------------------------------------
Dataset: ITERA
-------------------------------------------------
✓ Rows: 428
✓ Columns: 24

Faktor Levels:
-------------
  jenis.kelamin ( 2 levels ):
    Laki-laki, Perempuan
    Frekuensi: 210, 218

  tingkat.semester ( 4 levels ):
    Semester 1 - 2, Semester 3 - 4, Semester 5 - 6, Semester 7 - 8 ke atas
    Frekuensi: 37, 67, 109, 215

Missing Values:
---------------
  ✓ No missing values!
```

---

## 12. Troubleshooting Umum

### ❌ Error 1: `input string X is invalid UTF-8`

**Penyebab**: Karakter khusus dengan encoding salah

**Solusi**:

```r
# Tambahkan di awal function standardize
data$variable <- enc2utf8(as.character(data$variable))
data$variable <- iconv(data$variable, "UTF-8", "UTF-8", sub = "")
data$variable <- trimws(data$variable)
```

---

### ❌ Error 2: `NAs introduced by coercion`

**Penyebab**: Nilai tidak bisa dikonversi ke numeric

**Solusi**:

```r
# Cek dulu nilai yang bermasalah
unique(data$variable[is.na(as.numeric(data$variable))])

# Bersihkan sebelum konversi
data$variable <- gsub("[^0-9.]", "", data$variable)
data$variable <- as.numeric(data$variable)
```

---

### ❌ Error 3: `object 'variable' not found`

**Penyebab**: Nama variabel salah atau belum di-rename

**Solusi**:

```r
# Cek nama variabel yang ada
names(data)

# Atau cek apakah variabel ada
if ("variable" %in% names(data)) {
  # Process...
}
```

---

### ❌ Error 4: `subscript out of bounds`

**Penyebab**: Index melebihi panjang vector/data frame

**Solusi**:

```r
# Cek panjang dulu
if (length(x) >= 10) {
  x[10]  # Aman
}

# Atau gunakan safe indexing
x[min(10, length(x))]
```

---

### ❌ Error 5: CSV Delimiter Issues

**Penyebab**: Data mengandung delimiter (misal koma di dalam nilai)

**Solusi**:

```r
# Gunakan readr dengan quote handling
library(readr)

data <- read_delim(file,
                   delim = ";",
                   quote = "\"",
                   escape_double = TRUE)

# Atau perbaiki quoting saat write
write_delim(data,
            file,
            delim = ";",
            quote = "needed",
            escape = "double")
```

---

## 13. Best Practices

### ✅ 1. Backup Data Asli

**SELALU** backup sebelum cleaning!

```r
# Buat folder backup
if (!dir.exists("datasets/backup")) {
  dir.create("datasets/backup")
}

# Copy file asli
file.copy("datasets/data.csv",
          "datasets/backup/data_original.csv")
```

---

### ✅ 2. Dokumentasi Keputusan

Catat **SEMUA** keputusan cleaning:

```r
# ❌ Bad
data$usia[data$usia > 100] <- NA

# ✅ Good
# Decision: Set usia > 100 to NA (assume data entry error)
# Date: 2026-02-10
# By: Research Team
data$usia[data$usia > 100] <- NA
```

---

### ✅ 3. Reproducibility

Buat script yang bisa dijalankan ulang:

```r
# ✅ Good: Full path, no manual steps
source("R/cleaning_functions.R")
data <- read_csv("data/raw/dataset.csv")
data_clean <- clean_data(data)
write_csv(data_clean, "data/cleaned/dataset_clean.csv")
```

---

### ✅ 4. Validation Checks

Tambahkan assertion untuk validasi:

```r
# Cek jumlah baris tidak berubah drastis
stopifnot(nrow(data_clean) > 0.9 * nrow(data_raw))

# Cek kolom penting ada
stopifnot(all(c("usia", "jarak.km") %in% names(data_clean)))

# Cek range nilai wajar
stopifnot(all(data_clean$usia >= 17 & data_clean$usia <= 30, na.rm = TRUE))
```

---

### ✅ 5. Version Control

Gunakan Git untuk tracking changes:

```bash
git init
git add master_cleaning.R
git commit -m "Initial cleaning script"

# Setelah update
git add master_cleaning.R
git commit -m "Added UTF-8 encoding fix"
```

---

### ✅ 6. Modular Code

Pecah kode menjadi function-function kecil:

```r
# ✅ Good: Modular
data %>%
  rename_vars() %>%
  clean_strings() %>%
  convert_types() %>%
  handle_missing()

# ❌ Bad: Monolithic
clean_all_data <- function(data) {
  # 500 lines of code...
}
```

---

### ✅ 7. Progress Messages

Berikan feedback saat processing:

```r
cat("Processing", dataset_name, "...\n")
cat("  ✓ Loaded", nrow(data), "rows\n")
cat("  ✓ Cleaned", n_cleaned, "values\n")
cat("  ✓ Saved to", output_file, "\n")
```

---

### ✅ 8. Error Handling

Tangani error dengan gracefully:

```r
# ✅ Good: Try-catch
result <- tryCatch({
  read_csv(file)
}, error = function(e) {
  cat("Error reading file:", e$message, "\n")
  return(NULL)
})

if (is.null(result)) {
  cat("Skipping this file...\n")
}
```

---

## 🎓 Kesimpulan

Selamat! Anda telah mempelajari **lengkap** proses data cleaning profesional!

### 📝 Ringkasan yang Dipelajari

1. ✅ **Diagnosa dataset** - Memahami masalah
2. ✅ **Membuat protocol** - Planning yang matang
3. ✅ **Standardisasi nama** - Konsistensi variabel
4. ✅ **Konversi tipe data** - Numeric, factor, dll
5. ✅ **Standardisasi kategoris** - Mapping dan factor levels
6. ✅ **Handle missing values** - Impute, drop, keep
7. ✅ **Hapus kolom** - Remove yang tidak perlu
8. ✅ **Master script** - Automasi penuh
9. ✅ **Verifikasi** - Quality assurance
10. ✅ **Troubleshooting** - Solve common errors
11. ✅ **Best practices** - Professional workflow

### 🚀 Next Steps

Sekarang data Anda sudah **bersih** dan siap untuk:

1. **Exploratory Data Analysis (EDA)**

   ```r
   summary(data_clean)
   hist(data_clean$usia)
   table(data_clean$jenis.kelamin)
   ```

2. **Data Visualization**

   ```r
   library(ggplot2)
   ggplot(data_clean, aes(x = jarak.km)) +
     geom_histogram()
   ```

3. **Statistical Analysis**

   ```r
   t.test(jarak.km ~ jenis.kelamin, data = data_clean)
   cor.test(data_clean$usia, data_clean$jarak.km)
   ```

4. **Modeling**
   ```r
   model <- lm(jarak.km ~ usia + kendaraan.utama, data = data_clean)
   ```

### 📚 Resources Lanjutan

- [R for Data Science](https://r4ds.had.co.nz/) - buku komprehensif
- [Data Cleaning with R](https://cran.r-project.org/doc/contrib/de_Jonge+van_der_Loo-Introduction_to_data_cleaning_with_R.pdf) - panduan mendalam
- [dplyr cheatsheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-transformation.pdf) - quick reference

### 💪 Practice Makes Perfect!

Data cleaning adalah **skill** yang berkembang dengan **practice**. Semakin banyak dataset yang Anda bersihkan, semakin mahir Anda!

**Happy Cleaning! 🧹✨**

---

**Dibuat oleh**: Antigravity AI Agent  
**Tanggal**: 10 Februari 2026  
**Proyek**: Praktikum R - Sistem Transportasi  
**Versi**: 1.0
