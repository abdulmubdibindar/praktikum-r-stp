# ✅ LAPORAN VERIFIKASI FINAL - DATASET UBL (POST-FIX)

**Tanggal**: 10 Februari 2026  
**Status**: ✅ **Masalah delimiter BERHASIL diperbaiki!**

---

## 🎉 SUMMARY FIX

**Masalah**: Dataset UBL corrupt karena [`konversi_biaya_ubl.R`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/konversi_biaya_ubl.R) menggunakan `write.csv()` dengan delimiter **koma** (default), padaruhal file asli menggunakan **semicolon**.

**Solusi**: Reprocess dari backup dengan `readr::write_delim()` menggunakan delimiter **semicolon** (`;`).

**Hasil**: ✅ **379 baris utuh** (sebelumnya hanya 221 baris yang terbaca)

---

## 1️⃣ FAKULTAS DAN PRODI

### ✅ Konfirmasi: Anda Benar!

Dataset UBL **MEMILIKI** kolom `Fakultas` dan `Prodi` dalam format **TEXT**, bukan encoded!

**Fakultas UBL (6 kategori)**:

1. Fakultas Ekonomi dan Bisnis
2. Fakultas Hukum
3. Fakultas Ilmu Komputer
4. Fakultas Ilmu Sosial dan Politik
5. Fakultas Keguruan dan Ilmu Pendidikan
6. Fakultas Teknik

**Prodi UBL (12 kategori)**:

1. Administrasi Bisnis
2. Administrasi Publik
3. Akuntansi
4. Arsitektur
5. Ilmu Hukum
6. Ilmu Komunikasi
7. Informatika
8. Manajemen
9. Pendidikan Bahasa Inggris
10. Sistem Informasi
11. Teknik Mesin
12. Teknik Sipil

**Kesimpulan**: **Semua dataset (ITERA, UNILA, UBL, UINRIL) memiliki Fakultas dan Prodi dalam format TEXT!**

---

## 2️⃣ JENIS TEMPAT TINGGAL

### ✅ Dataset UBL Sekarang Bersih!

Setelah fix delimiter, kolom `jenis tempat tinggal` di UBL **HANYA berisi text kategoris** - tidak ada lagi nilai encoded (1,2,3,4,5)!

**Frekuensi di UBL (7 kategori)**:

1. Rumah pribadi/rumah keluarga (253)
2. Kos Sendiri (62)
3. Rumah bersama saudara (27)
4. Kos bersama-sama (22)
5. Rumah mengontrak bersama-sama (9)
6. Rumah mengontrak pribadi (5)
7. Asrama (1)

**✅ Perbandingan dengan dataset lain**:

| Dataset    | Rumah pribadi | Kos sendiri | Kos bersama | Rumah saudara | Mengontrak | Asrama |
| ---------- | ------------- | ----------- | ----------- | ------------- | ---------- | ------ |
| **ITERA**  | 63            | 200         | 25          | 21            | 108        | 11     |
| **UNILA**  | 121           | 82          | 43          | 57            | 82         | 10     |
| **UBL**    | 253           | 62          | 22          | 27            | 14         | 1      |
| **UINRIL** | 128           | 148         | 33          | 23            | 65         | 3      |

**Perbedaan minor dalam kapitalisasi dan spelling**:

- "Kos Sendiri" vs "Kos sendiri" vs "os sendiri" (typo UNILA)
- "Rumah mengontrak" vs "Rumah ngontrak"
- "Rumah Pribadi/Rumah Keluarga" vs "Rumah pribadi/rumah keluarga"

**✅ Standardisasi yang disetujui user (8 kategori)**:

1. "Kos sendiri"
2. "Kos bersama-sama"
3. "Rumah pribadi/rumah keluarga"
4. "Rumah bersama saudara"
5. "Rumah mengontrak sendiri"
6. "Rumah mengontrak bersama-sama"
7. "Asrama"
8. "Lainnya"

---

## 3️⃣ MISSING VALUES

### Dataset UBL

| Variabel                    | Missing Count | Missing % | Keputusan User            |
| --------------------------- | ------------- | --------- | ------------------------- |
| `kepemilikan mobil`         | 3             | 0.79%     | ✅ **Imputasi median**    |
| `kepemilikan sepeda`        | 1             | 0.26%     | ✅ **Imputasi median**    |
| `nama jalan tempat tinggal` | 4             | 1.06%     | Biarkan NA (tidak kritis) |
| `biaya.dalam.ribu2`         | 1             | 0.26%     | ✅ **DROP observasi**     |

### Summary Semua Dataset

| Dataset    | Variabel                           | Missing | Keputusan                |
| ---------- | ---------------------------------- | ------- | ------------------------ |
| **ITERA**  | `jarak..km.`                       | 1       | ✅ **Imputasi median**   |
| **UNILA**  | `jarak..km.`                       | 1       | ✅ **Imputasi median**   |
| **UNILA**  | `Jumlah.Perjalanan.*` (semua hari) | 1       | ✅ **DROP observasi**    |
| **UBL**    | `kepemilikan.mobil`                | 3       | ✅ **Imputasi median**   |
| **UBL**    | `kepemilikan.sepeda`               | 1       | ✅ **Imputasi median**   |
| **UINRIL** | -                                  | 0       | ✅ **Tidak ada missing** |

---

## 4️⃣ HASIL KONVERSI BIAYA

### Dataset UBL - biaya.dalam.ribu2

**Summary statistik**:

- **Min**: 0 ribu
- **Max**: 600 ribu
- **Mean**: 99.18 ribu
- **Median**: 70 ribu
- **Missing (NA)**: 1 (outlier "20 JUTA RUPIAH" yang di-drop)
- **Berhasil dikonversi**: 378 dari 379 observasi

✅ Konversi berhasil dengan baik!

---

## 📌 NEXT STEPS

Berdasarkan verifikasi ini, dapat dilanjutkan ke:

1. ✅ **Standardisasi variabel kategoris** (jenis.kelamin, tingkat.semester, uang.saku, kendaraan.utama, jenis.tempat.tinggal)
2. ✅ **Rename variabel** sesuai protokol (huruf kecil + titik separator)
3. ✅ **Handle missing values** sesuai keputusan user
4. ✅ **Convert data types** (numeric, factor ordinal/nominal)
5. ✅ **Apply cleaning protocol** ke semua 4 dataset

---

## ✅ KESIMPULAN

**Masalah delimiter SOLVED!** Dataset UBL sekarang:

- ✅ 379 baris utuh (tidak ada data hilang)
- ✅ Fakultas dan Prodi terdeteksi dengan benar (TEXT, bukan encoded)
- ✅ jenis.tempat.tinggal hanya berisi text kategoris (tidak ada nilai encoded 1-5 lagi!)
- ✅ Missing values teridentifikasi dengan jelas
- ✅ Konversi biaya berhasil (378/379)

**Siap untuk cleaning protocol selanjutnya!** 🚀

---

**File terkait**:

- Script fix: [`fix_ubl_readr_final.R`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/fix_ubl_readr_final.R)
- Script verifikasi: [`verifikasi_ulang_ubl.R`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/verifikasi_ulang_ubl.R)
- Hasil verifikasi: [`hasil_verifikasi_ulang_ubl.txt`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/hasil_verifikasi_ulang_ubl.txt)
- Dataset UBL (fixed): [`DataUtama_mhsUBL.csv`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/DataUtama_mhsUBL.csv)
