# 📋 LAPORAN PRE-CLEANING - VARIABEL YANG MEMERLUKAN KEPUTUSAN USER

**Tanggal**: 10 Februari 2026  
**Tujuan**: Mendata variabel yang perlu koreksi/keputusan sebelum pembersihan final

---

## 1️⃣ VERIFIKASI: FAKULTAS DAN PRODI

### ✅ Konfirmasi Anda Benar!

Saya telah salah menilai - **Fakultas** dan **Prodi** **TIDAK di-encode**, semuanya berupa **text/string**:

| Dataset    | Fakultas (sample)                             | Prodi (sample)                             |
| ---------- | --------------------------------------------- | ------------------------------------------ |
| **ITERA**  | "FTIK", "FTIK", "FTIK"                        | "Perencanaan Wilayah dan Kota"             |
| **UNILA**  | "Fakultas Teknik", "FakultasEkonomidanbisnis" | "Teknik Mesin", "Akuntansi"                |
| **UBL**    | ❌ **TIDAK ADA** (kolom NULL)                 | ❌ **TIDAK ADA** (kolom NULL)              |
| **UINRIL** | "Syariah", "Syariah", "Tarbiyah dan Keguruan" | "Hukum Keluarga", "Pendidikan Agama Islam" |

**⚠️ CATATAN PENTING**: Dataset **UBL tidak memiliki kolom Fakultas dan Prodi**!

---

## 2️⃣ NILAI KATEGORIS: JENIS TEMPAT TINGGAL

### Dataset ITERA (7 kategori):

1. Kos Sendiri (200)
2. Rumah mengontrak bersama-sama (107)
3. Rumah pribadi/rumah keluarga (63)
4. Kos bersama-sama (25)
5. Rumah bersama saudara (21)
6. Asrama (11)
7. Rumah mengontrak pribadi (1)

### Dataset UNILA (8 kategori):

1. Rumah pribadi/rumah keluarga (121)
2. Kos sendiri (81) ← **huruf kecil berbeda dengan ITERA**
3. Rumah bersama saudara (57)
4. Rumah ngontrak bersama-sama (47) ← **"ngontrak" vs "mengontrak"**
5. Kos bersama-sama (43)
6. Rumah ngontrak pribadi (35)
7. Asrama (10)
8. **os sendiri** (1) ← **⚠️ TYPO!**

### Dataset UBL:

⚠️ **DATA CORRUPT**: Kolom `jenis.tempat.tinggal` di UBL **tercampur dengan seluruh data row** (masalah parsing CSV yang serius!)

**Contoh nilai UBL yang corrupt**:

```
"01/05/2024 19:55,UBL,1,Perempuan,21,Fakultas Ilmu Sosial dan Politik,Ilmu Komunikasi,4..."
```

Ini **BUKAN** nilai jenis tempat tinggal, tapi **entire row data!**

### Dataset UINRIL (7 kategori):

1. Kos Sendiri (148)
2. Rumah Pribadi/Rumah Keluarga (128) ← **Kapitalisasi berbeda**
3. Rumah Mengontrak Bersama-sama (63)
4. Kos Bersama-sama (33) ← **Kapitalisasi berbeda**
5. Rumah Bersama Saudara (23)
6. Asrama (3)
7. Rumah Mengontrak Pribadi (2)

### 🎯 USULAN STANDARDISASI:

Berdasarkan analisis, saya usulkan **8 kategori standar** berikut:

1. **"Kos sendiri"** (huruf kecil)
2. **"Kos bersama-sama"**
3. **"Rumah pribadi/rumah keluarga"**
4. **"Rumah bersama saudara"**
5. **"Rumah mengontrak sendiri"** (gabung "Rumah mengontrak pribadi" + "Rumah ngontrak pribadi")
6. **"Rumah mengontrak bersama-sama"** (gabung "Rumah mengontrak bersama-sama" + "Rumah ngontrak bersama-sama")
7. **"Asrama"**
8. **"Lainnya"** (untuk nilai yang tidak bisa dikategorikan)

**❓ KEPUTUSAN YANG DIPERLUKAN:**

- Apakah kategorisasi di atas sudah sesuai?
- Bagaimana menangani data UBL yang corrupt?

---

## 3️⃣ MISSING VALUES DETAIL

### ITERA (428 observasi):

- `jarak..km.`: **1 missing** (0.23%)

### UNILA (395 observasi):

- `jarak..km.`: **1 missing** (0.25%)
- `Jumlah.Perjalanan.Senin`: **1 missing** (0.25%)
- `Jumlah.Perjalanan.Selasa`: **1 missing** (0.25%)
- `Jumlah.Perjalanan.Rabu`: **1 missing** (0.25%)
- `Jumlah.Perjalanan.Kamis`: **1 missing** (0.25%)
- `Jumlah.Perjalanan.Jumat`: **1 missing** (0.25%)
- `Jumlah.Perjalanan.Sabtu`: **1 missing** (0.25%)
- `Jumlah.Perjalanan.Minggu`: **1 missing** (0.25%)

**✅ Konfirmasi**: Ada **1 responden** UNILA yang **tidak mengisi semua variabel jumlah perjalanan** (semua hari kosong).  
**Index observasi yang akan di-drop**: Baris ke-**2** (sesuai instruksi Anda)

### UBL (379 observasi):

- `kepemilikan.mobil`: **3 missing** (0.79%)
- `kepemilikan.sepeda`: **1 missing** (0.26%)
- `nama.jalan.tempat.tinggal`: **4 missing** (1.06%)

### UINRIL (400 observasi):

✅ **Tidak ada missing values**

---

### 🎯 USULAN PENANGANAN:

| Dataset   | Variabel                           | Jumlah Missing | Usulan                                                     |
| --------- | ---------------------------------- | -------------- | ---------------------------------------------------------- |
| **ITERA** | `jarak..km.`                       | 1              | **Imputasi median** atau **drop observasi** (pilihan user) |
| **UNILA** | `jarak..km.`                       | 1              | **Imputasi median** atau **drop observasi** (pilihan user) |
| **UNILA** | `Jumlah.Perjalanan.*` (semua hari) | 1              | ✅ **DROP OBSERVASI** (sudah sesuai instruksi)             |
| **UBL**   | `kepemilikan.mobil`                | 3              | **Imputasi mode** (nilai paling sering: 0 atau 1)          |
| **UBL**   | `kepemilikan.sepeda`               | 1              | **Imputasi mode** (nilai paling sering: 0 atau 1)          |
| **UBL**   | `nama.jalan.tempat.tinggal`        | 4              | **Biarkan NA** (alamat tidak kritis untuk analisis)        |

**❓ KEPUTUSAN YANG DIPERLUKAN:**

- Untuk missing di `jarak..km.`: Imputasi median atau drop observasi?
- Untuk missing di `kepemilikan.mobil` dan `kepemilikan.sepeda`: Imputasi mode atau drop?

---

## 4️⃣ MISSING JUMLAH PERJALANAN PER HARI - DETAIL

### ITERA:

✅ Tidak ada missing di variabel jumlah perjalanan

### UNILA:

- **1 observasi** missing di **SEMUA** variabel jumlah perjalanan (Senin-Minggu)
- **Index baris**: 2
- ✅ **Akan di-DROP** sesuai instruksi

### UBL:

❌ **Tidak ada kolom jumlah perjalanan ditemukan** karena dataset corrupt (masalah parsing CSV)

### UINRIL:

✅ Tidak ada missing di variabel jumlah perjalanan

**⚠️ CATATAN KRITIS**: Dataset UBL mengalami **masalah parsing CSV yang serius** - perlu di-reload atau di-fix manual.

---

## ⚠️ MASALAH KRITIS YANG DITEMUKAN

### 🔴 DATASET UBL CORRUPT!

Dataset UBL mengalami **masalah parsing CSV yang serius**:

- Kolom `jenis.tempat.tinggal` berisi **entire row data** instead of nilai kategori
- Kolom `Fakultas` dan `Prodi` **NULL** (tidak ada data)
- Kemungkinan ada masalah dengan **delimiter** atau **quote character** dalam file CSV

**❓ KEPUTUSAN YANG DIPERLUKAN:**

- Apakah file CSV UBL perlu di-reload ulang?
- Atau ada file backup yang lebih baik?

---

## 📌 RINGKASAN KEPUTUSAN YANG DIPERLUKAN

1. ✅ **Jenis Tempat Tinggal**: Apakah kategorisasi standar yang saya usulkan sudah sesuai?
2. ❓ **Missing jarak.km** (ITERA + UNILA): Imputasi median atau drop?
3. ❓ **Missing kepemilikan kendaraan** (UBL): Imputasi mode atau drop?
4. ✅ **Missing jumlah perjalanan** (UNILA): DROP observasi (sudah sesuai)
5. 🔴 **URGENT - Dataset UBL Corrupt**: Perlu reload file CSV?

---

**File laporan lengkap tersimpan di**: [`laporan_precleaning.txt`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/laporan_precleaning.txt)

Silakan koreksi dan beri keputusan untuk item-item di atas! 🙏
