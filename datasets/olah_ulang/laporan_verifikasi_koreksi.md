# 📋 LAPORAN VERIFIKASI KOREKSI - VARIABEL YANG MEMERLUKAN KEPUTUSAN

**Tanggal**: 10 Februari 2026 (Diupdate)  
**Status**: ✅ **Dataset UBL berhasil dibaca dengan delimiter koma**

---

## ✅ KOREKSI: FAKULTAS DAN PRODI UBL

### Anda Benar! Dataset UBL **MEMILIKI** kolom Fakultas dan Prodi

Setelah membaca dengan delimiter koma (`,`), struktur dataset UBL:

| Dataset | Fakultas                     | Prodi                         | Catatan        |
| ------- | ---------------------------- | ----------------------------- | -------------- |
| **UBL** | ✅ **ADA** (6 kategori unik) | ✅ **ADA** (12 kategori unik) | Text kategoris |

**Sample nilai Fakultas UBL**:

1. "Fakultas Ilmu Sosial dan Politik"
2. "Fakultas Hukum"
3. "Fakultas Ekonomi dan Bisnis"
4. "Fakultas Teknik"
5. "Fakultas Ilmu Komputer"
6. "Fakultas Keguruan dan Ilmu Pendidikan"

**Sample nilai Prodi UBL**:

1. "Ilmu Komunikasi"
2. "Ilmu Hukum"
3. "Manajemen"
4. "Akuntansi"
5. dst... (12 unique values)

**Kesimpulan**: **Semua dataset (ITERA, UNILA, UBL, UINRIL) memiliki Fakultas dan Prodi dalam format TEXT, bukan encoded.**

---

## 🔍 TEMUAN BARU: JENIS TEMPAT TINGGAL DI UBL

### ⚠️ Dataset UBL memiliki ENCODED values untuk `jenis.tempat.tinggal`

**Frekuensi nilai di UBL**:

- **"2"**: 102 observasi
- **"1"**: 100 observasi
- **"3"**: 37 observasi
- **"Rumah pribadi/rumah keluarga"**: 33 observasi (text kategoris)
- **"4"**: 23 observasi
- **"Kos Sendiri"**: 12 observasi (text kategoris)
- **"Rumah bersama saudara"**: 7 observasi (text kategoris)
- **"5"**: 5 observasi
- **"Kos bersama-sama"**: 5 observasi (text kategoris)

**Total kategori unik**: 62 (campuran antara angka encoded dan text categories)

### 🤔 Interpretasi:

Dataset UBL memiliki **MIXED values**:

- Sebagian besar (262 dari 379 = 69%) menggunakan **ANGKA ENCODED** (1, 2, 3, 4, 5)
- Sebagian kecil (64 observasi = 17%) menggunakan **TEXT KATEGORIS**
- Sisanya adalah nilai-nilai aneh (jarak, biaya, nama jalan?)

**❓ KEPUTUSAN YANG DIPERLUKAN**:

- Apakah ada **CODEBOOK** untuk UBL yang menjelaskan mapping angka 1-5 ke kategori jenis tempat tinggal?
- Atau kita perlu **DECODE** berdasarkan pola di dataset lain?

---

## 📊 STANDARDISASI JENIS TEMPAT TINGGAL (Update)

### Dataset ITERA (7 kategori - TEXT):

1. Kos Sendiri (200)
2. Rumah mengontrak bersama-sama (107)
3. Rumah pribadi/rumah keluarga (63)
4. Kos bersama-sama (25)
5. Rumah bersama saudara (21)
6. Asrama (11)
7. Rumah mengontrak pribadi (1)

### Dataset UNILA (8 kategori - TEXT):

1. Rumah pribadi/rumah keluarga (121)
2. Kos sendiri (81) ← huruf kecil
3. Rumah bersama saudara (57)
4. Rumah ngontrak bersama-sama (47) ← variasi spelling
5. Kos bersama-sama (43)
6. Rumah ngontrak pribadi (35)
7. Asrama (10)
8. os sendiri (1) ← **TYPO untuk "Kos sendiri"**

### Dataset UBL (MIXED - Encoded + Text):

**Encoded (angka 1-5)**: 69% observasi  
**Text kategoris**: 17% observasi (sama seperti dataset lain)  
**Nilai aneh**: 14% observasi

### Dataset UINRIL (7 kategori - TEXT):

1. Kos Sendiri (148) ← kapitalisasi berbeda
2. Rumah Pribadi/Rumah Keluarga (128) ← kapitalisasi berbeda
3. Rumah Mengontrak Bersama-sama (63)
4. Kos Bersama-sama (33)
5. Rumah Bersama Saudara (23)
6. Asrama (3)
7. Rumah Mengontrak Pribadi (2)

### 🎯 USULAN STANDARDISASI (approved oleh user):

**8 kategori standar**:

1. **"Kos sendiri"**
2. **"Kos bersama-sama"**
3. **"Rumah pribadi/rumah keluarga"**
4. **"Rumah bersama saudara"**
5. **"Rumah mengontrak sendiri"**
6. **"Rumah mengontrak bersama-sama"**
7. **"Asrama"**
8. **"Lainnya"**

**⚠️ UNTUK UBL**: Perlu decode angka 1-5 ke kategori yang sesuai. **Codebook diperlukan.**

---

## 📋 MISSING VALUES - UPDATE KEPUTUSAN

Berdasarkan feedback user:

| Dataset   | Variabel                           | Missing | Keputusan User            |
| --------- | ---------------------------------- | ------- | ------------------------- |
| **ITERA** | `jarak..km.`                       | 1       | ✅ **Imputasi median**    |
| **UNILA** | `jarak..km.`                       | 1       | ✅ **Imputasi median**    |
| **UNILA** | `Jumlah.Perjalanan.*` (semua hari) | 1       | ✅ **DROP observasi**     |
| **UBL**   | `kepemilikan.mobil`                | 3       | ✅ **DROP observasi**     |
| **UBL**   | `kepemilikan.sepeda`               | 1       | ✅ **DROP observasi**     |
| **UBL**   | `nama.jalan.tempat.tinggal`        | 4       | Biarkan NA (tidak kritis) |

---

## 🚨 PERTANYAAN KRITIS UNTUK USER

### 1. Codebook untuk Jenis Tempat Tinggal UBL

Dataset UBL menggunakan **angka encoded (1-5)** untuk nilai `jenis.tempat.tinggal`.

**❓ Apakah ada codebook yang menjelaskan mapping berikut?**

Kemungkinan mapping (berdasarkan frekuensi dan pola dataset lain):

- `1` = ? (100 observasi)
- `2` = ? (102 observasi)
- `3` = ? (37 observasi)
- `4` = ? (23 observasi)
- `5` = ? (5 observasi)

**Atau** kita perlu **manual inspect** untuk menentukan mapping?

### 2. Variabel Encode Lainnya

Berdasarkan [`cleaning_protocol.md`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/cleaning_protocol.md), ada beberapa variabel yang masih **perlu di-decode**:

- `Jenis.Kelamin` (1 = Laki-laki, 2 = Perempuan) ✅ **Sudah jelas**
- `Umur` (angka coded 1-8) → **Perlu codebook**
- `Tingkat.Semester` (1-4) → **Sudah dijelaskan di protocol**
- `Uang.Saku` (angka coded 1-5) → **Perlu codebook**
- `kendaraan.utama` (angka coded 1-7) → **Perlu codebook**
- `alasan.pemilihan.lokasi.tempat.tinggal` → di UBL sudah dikategorikan (8 kat), yang lain free text

**❓ Apakah ada codebook untuk variabel-variabel di atas?**

---

## ✅ SUMMARY KEPUTUSAN FINAL

**Yang sudah clear**:

1. ✅ Kategorisasi jenis tempat tinggal → 8 kategori standar
2. ✅ Missing `jarak.km` → Imputasi median
3. ✅ Missing kepemilikan kendaraan → DROP observasi
4. ✅ Missing jumlah perjalanan UNILA → DROP observasi

**Yang masih perlu**:

1. ❓ **Codebook** untuk decode variabel encoded
2. ❓ **Mapping** angka 1-5 untuk `jenis.tempat.tinggal` di UBL

---

**Silakan berikan codebook atau instruksi manual mapping untuk melanjutkan!** 🙏
