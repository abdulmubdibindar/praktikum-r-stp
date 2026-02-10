# Data Cleaning Walkthrough

## Pembersihan Data Dataset Praktikum R-STP

**Tanggal**: 10 Februari 2026  
**Dataset**: DataUtama_mhsITERA.csv, DataUtama_mhsUNILA.csv, DataUtama_mhsUBL.csv, DataUtama_mhsUINRIL.csv  
**Lokasi**: `datasets/olah_ulang/`

---

## 📊 Fase 1: Diagnosa Struktur Data

### Ringkasan Umum

Analisis dilakukan terhadap keempat file dataset mahasiswa dari berbagai kampus di Lampung. Berikut adalah overview ukuran masing-masing dataset:

| Dataset    | Jumlah Baris | Jumlah Variabel | Format               |
| ---------- | ------------ | --------------- | -------------------- |
| **ITERA**  | 428          | 26              | CSV (delimiter: `;`) |
| **UNILA**  | 395          | 25              | CSV (delimiter: `;`) |
| **UBL**    | 379          | 26              | CSV (delimiter: `;`) |
| **UINRIL** | 400          | 25              | CSV (delimiter: `;`) |

**Total Observasi**: 1,602 responden  
**Total Variabel Unik**: ~27 variabel (dengan berbagai inkonsistensi penamaan)

---

### Variabel yang Konsisten di Keempat Dataset

Terdapat **13 variabel** yang muncul di semua dataset:

| Nama Variabel                            | Deskripsi Variabel                             | Keterangan Nilai                                                                                                                                                    |
| ---------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Kampus_PT`                              | Identifikasi kampus/perguruan tinggi           | **Nominal**: ITERA, UNILA, UBL, UINRIL (1 nilai per dataset)                                                                                                        |
| `Nomor.urut`                             | Nomor urut responden sebagai ID unik           | **Numerik**: Integer, range 1 sampai jumlah responden per dataset                                                                                                   |
| `Jenis.Kelamin`                          | Jenis kelamin responden                        | **Nominal** (encoded): `1` = ?, `2` = ? (perlu decode, 2 kategori)                                                                                                  |
| `Umur`                                   | Usia responden dalam kelompok kategori         | **Ordinal** (encoded): `1` - `8` (perlu decode, 6-8 kategori tergantung dataset)<br>Kemungkinan rentang: 17-18, 19-20, 21-22, 23-24, 25-26, 27+                     |
| `Fakultas`                               | Fakultas tempat mahasiswa berkuliah            | **Nominal** (encoded): `1` - `8` (perlu decode)<br>- ITERA: 3 kategori (FTIK, FTEIC, FST)<br>- UNILA: 8 kategori<br>- UBL: 6 kategori<br>- UINRIL: 6 kategori       |
| `Prodi`                                  | Program studi tempat mahasiswa berkuliah       | **Nominal** (encoded): Variabel tergantung kampus<br>- ITERA: 41 kategori<br>- UNILA: 67 kategori<br>- UBL: 12 kategori<br>- UINRIL: 32 kategori                    |
| `Tingkat.Semester`                       | Tingkat semester mahasiswa                     | **Ordinal**: `1` - `4` (Tingkat 1-4)<br>- ITERA: integer sederhana<br>- Lainnya: character dengan format "1 (Semester 1 - Semester 2)"                              |
| `Uang.Saku`                              | Uang saku mahasiswa per periode                | **Ordinal** (encoded): `1` - `5` (perlu decode)<br>Kemungkinan: < 1 jt, 1-2 jt, 2-3 jt, 3-4 jt, > 4 jt                                                              |
| `kepemilikan.mobil`                      | Jumlah mobil yang dimiliki keluarga            | **Numerik**: Integer 0-5, mayoritas 0 (tidak punya)                                                                                                                 |
| `kepemilikan.sepeda`                     | Jumlah sepeda yang dimiliki keluarga           | **Numerik**: Integer 0-6, mayoritas 0 (tidak punya)                                                                                                                 |
| `kendaraan.utama`                        | Kendaraan utama yang digunakan untuk ke kampus | **Nominal** (encoded): `1` - `7` (perlu decode)<br>Kemungkinan: Sepeda, Sepeda Motor, Mobil, Angkot, Ojek Online, Jalan Kaki, Lainnya                               |
| `alasan.pemilihan.lokasi.tempat.tinggal` | Alasan memilih lokasi tempat tinggal           | **Nominal**:<br>- ITERA: 306 kategori (teks bebas)<br>- UNILA: 79 kategori<br>- UBL: 8 kategori (sudah dikategorikan)<br>- UINRIL: 8 kategori (sudah dikategorikan) |
| `jarak..km.`                             | Jarak dari tempat tinggal ke kampus (dalam km) | **Numerik**: ⚠️ Saat ini bertipe character dengan koma desimal<br>Perlu konversi ke numeric, range 0-20+ km                                                         |

---

## ⚠️ Temuan Masalah Kritis

### 1. Inkonsistensi Nama Variabel

#### A. Variabel Kepemilikan Motor

| Dataset   | Nama Variabel         | Tipe    | Unique Values |
| --------- | --------------------- | ------- | ------------- |
| ITERA     | `kepemilikan.motor`   | integer | 4 (0-4)       |
| **UNILA** | **`Jumlah.motor`** ⚠️ | integer | 6 (0-6)       |
| UBL       | `kepemilikan.motor`   | integer | 6 (0-6)       |
| UINRIL    | `kepemilikan.motor`   | integer | 7 (0-7)       |

> **Masalah**: UNILA menggunakan nama yang berbeda untuk variabel yang sama.

---

#### B. Variabel Jenis Tempat Tinggal

| Dataset   | Nama Variabel                 | Kapitalisasi |
| --------- | ----------------------------- | ------------ |
| ITERA     | `jenis.tempat.tinggal`        | lowercase    |
| **UNILA** | **`Jenis.Tempat.Tinggal`** ⚠️ | Title Case   |
| UBL       | `jenis.tempat.tinggal`        | lowercase    |
| UINRIL    | `jenis.tempat.tinggal`        | lowercase    |

> **Masalah**: Inkonsistensi kapitalisasi yang akan menyebabkan error saat merging dataset.

---

#### C. Variabel Alamat Tempat Tinggal

| Dataset   | Nama Variabel               | Unique Values |
| --------- | --------------------------- | ------------- |
| ITERA     | `nama.jalan.tempat.tinggal` | 314           |
| **UNILA** | **`Alamat`** ⚠️             | 217           |
| UBL       | `nama.jalan.tempat.tinggal` | 325           |
| UINRIL    | `nama.jalan.tempat.tinggal` | 357           |

> **Masalah**: UNILA menggunakan nama yang berbeda untuk variabel yang sama.

---

#### D. Variabel Biaya Transportasi

| Dataset | Nama Variabel                 | Tipe          | Range       | Satuan         |
| ------- | ----------------------------- | ------------- | ----------- | -------------- |
| ITERA   | `biaya.dalam.ribu2`           | integer       | 0 - 400,000 | Ribu rupiah    |
| UNILA   | `biaya.dalam.ribu2`           | integer       | 0 - 400     | Ribu rupiah    |
| **UBL** | **`biaya.dalam.seminggu`** ⚠️ | **character** | 105 unique  | **Per minggu** |
| UINRIL  | `biaya.dalam.ribu2`           | integer       | 0 - 150     | Ribu rupiah    |

> **Masalah Ganda**:
>
> 1. UBL menggunakan nama variabel yang berbeda
> 2. UBL menggunakan tipe data character (bukan numeric)
> 3. UBL menggunakan periode berbeda (per minggu vs per hari/trip)

---

#### E. Variabel Jumlah Perjalanan Harian

**Inkonsistensi Kapitalisasi**:

| Dataset | Pattern Nama Variabel                                                     | Contoh                  |
| ------- | ------------------------------------------------------------------------- | ----------------------- |
| ITERA   | `Jumlah.perjalanan.Senin`                                                 | lowercase "perjalanan"  |
| UNILA   | `Jumlah.Perjalanan.Senin`                                                 | Title Case "Perjalanan" |
| UBL     | `Jumlah.perjalanan.Senin` (Senin)<br>`Jumlah.Perjalanan.Selasa` (lainnya) | **Mixed!** ⚠️           |
| UINRIL  | `Jumlah.Perjalanan.Senin`                                                 | Title Case "Perjalanan" |

**Inkonsistensi Nama Hari**:

| Hari   | ITERA                    | UNILA, UINRIL              | UBL                      |
| ------ | ------------------------ | -------------------------- | ------------------------ |
| Minggu | `Jumlah.perjalanan.Ahad` | `Jumlah.Perjalanan.Minggu` | `Jumlah.Perjalanan.Ahad` |

---

### 2. Masalah Tipe Data

#### A. Tingkat.Semester - Inkonsistensi Format

| Dataset | Tipe Data | Contoh Nilai                    | Unique Values |
| ------- | --------- | ------------------------------- | ------------- |
| ITERA   | integer   | `1`, `2`, `3`, `4`              | 4             |
| UNILA   | character | `"1 (Semester 1 - Semester 2)"` | 4             |
| UBL     | character | `"1 (Semester 1 - Semester 2)"` | 4             |
| UINRIL  | character | `"1 (Semester 1 - Semester 2)"` | 4             |

> **Masalah**: ITERA menggunakan integer sederhana, dataset lain menggunakan string deskriptif.

---

#### B. jarak..km. - KRITIS: Harus Dikonversi ke Numeric

| Dataset | Tipe Data        | Format       | Missing   | Contoh Nilai                 |
| ------- | ---------------- | ------------ | --------- | ---------------------------- |
| ITERA   | **character** ⚠️ | Koma desimal | 1 (0.23%) | `"6,69"`, `"2,82"`, `"5,17"` |
| UNILA   | **character** ⚠️ | Koma desimal | 1 (0.25%) | `"5,2"`, `"1,3"`, `"3,8"`    |
| UBL     | **character** ⚠️ | Koma desimal | 0 (0%)    | `"1"`, `"6"`, `"15"`         |
| UINRIL  | **character** ⚠️ | Koma desimal | 0 (0%)    | `"5,2"`, `"3,8"`, `"2,5"`    |

> **Masalah**:
>
> - Semua dataset menyimpan jarak sebagai character (string)
> - Menggunakan koma (`,`) sebagai separator desimal (European style)
> - Harus dikonversi ke numeric dengan mengganti koma menjadi titik

**Statistik Jarak (setelah konversi estimasi)**:

- ITERA: ~216 nilai unik, range 0-20+ km
- UNILA: ~62 nilai unik
- UBL: ~292 nilai unik (sangat bervariasi)
- UINRIL: ~245 nilai unik

---

#### C. Jumlah.perjalanan.Senin (UBL) - Mixed Type

| Dataset | Tipe untuk Senin | Tipe untuk Hari Lain |
| ------- | ---------------- | -------------------- |
| ITERA   | integer          | integer              |
| UNILA   | integer          | integer              |
| **UBL** | **character** ⚠️ | integer              |
| UINRIL  | integer          | integer              |

> **Masalah**: UBL memiliki tipe character untuk variabel Senin (ada nilai kosong sebagai string), sedangkan hari lain integer.

**Detail UBL `Jumlah.perjalanan.Senin`**:

- 9 unique values: `"0"`, `"2"`, `"3"`, `"4"`, dll + 43 empty strings
- Harus dikonversi ke integer dengan handling empty string → NA

---

### 3. Missing Values (Data Hilang)

#### Ringkasan Missing Data

| Dataset | Variabel                        | Jumlah Missing | Persentase | Strategi Imputasi          |
| ------- | ------------------------------- | -------------- | ---------- | -------------------------- |
| ITERA   | `jarak..km.`                    | 1              | 0.23%      | Mean/Median                |
| UNILA   | `jarak..km.`                    | 1              | 0.25%      | Mean/Median                |
| UNILA   | **Semua** `Jumlah.Perjalanan.*` | 1              | 0.25%      | Mode (responden yang sama) |
| UBL     | `kepemilikan.mobil`             | 3              | 0.79%      | Mode (0)                   |
| UBL     | `kepemilikan.sepeda`            | 1              | 0.26%      | Mode (0)                   |
| UBL     | `nama.jalan.tempat.tinggal`     | 4              | 1.06%      | "Tidak disebutkan"         |

**Observasi**:

- Missing values sangat minimal (<1% untuk semua kasus)
- UNILA: 1 responden tidak mengisi seluruh variabel jumlah perjalanan (7 variabel sekaligus)
- UBL: Beberapa responden tidak melengkapi data kendaraan dan alamat

---

### 4. Variabel dengan Encoding Numerik

Banyak variabel kategorikal masih menggunakan **kode numerik** daripada label deskriptif. Ini perlu di-decode berdasarkan metadata survey:

#### Variabel yang Perlu Decoding

1. **Jenis.Kelamin** - Nilai: `1`, `2`
   - Perlu mapping: `1 = "Laki-laki"`, `2 = "Perempuan"` (atau sebaliknya)

2. **Umur** - Nilai: `1` s.d. `8`
   - Perlu mapping ke rentang usia actual (mis: `1 = "17-18"`, `2 = "19-20"`, dll)

3. **Fakultas** - Nilai: `1` s.d. `8`
   - ITERA: 3 kategori (FTIK, FTEIC, FST)
   - UNILA: 8 kategori (berbeda per kampus)
   - UBL: 6 kategori
   - UINRIL: 6 kategori

4. **Uang.Saku** - Nilai: `1` s.d. `5`
   - Perlu mapping ke rentang uang saku (mis: `1 = "< 1 jt"`, `2 = "1-2 jt"`, dll)

5. **kendaraan.utama** - Nilai: `1` s.d. `7`
   - Kategori: Sepeda, Sepeda Motor Pribadi, Mobil Pribadi, Transportasi Online, Angkot, Jalan Kaki, dll

6. **jenis.tempat.tinggal** - Nilai: `1` s.d. `8`
   - Kategori: Kos, Rumah Pribadi, Kontrak, Asrama, dll

> **Catatan**: Decoding memerlukan **kamus mapping** dari metadata survey atau file codebook.

---

### 5. Variabel yang Tidak Konsisten Antar Dataset

#### Variabel yang Hanya Ada di Sebagian Dataset

| Variabel    | Dataset yang Memiliki | Keterangan                                |
| ----------- | --------------------- | ----------------------------------------- |
| `Timestamp` | ITERA, UNILA, UBL     | Waktu pengisian survey (tidak di UINRIL)  |
| `kelurahan` | ITERA, UBL, UINRIL    | Kelurahan tempat tinggal (tidak di UNILA) |

**Detail Variabel `Timestamp`**:

- ITERA: 424 unique values (dari 428 rows)
- UNILA: 253 unique values (dari 395 rows)
- UBL: 269 unique values (dari 379 rows)
- Format: `"DD/MM/YYYY HH:MM"`

**Detail Variabel `kelurahan`**:

- ITERA: 85 kategori unik
- UBL: 168 kategori unik
- UINRIL: 82 kategori unik
- Nilai: Nama kelurahan di Bandar Lampung (teks bebas, banyak variasi penulisan)

---

## 📋 Detail Variabel per Dataset

### Dataset ITERA (428 observasi)

**Variabel Demografis**:

1. `Timestamp` - Waktu pengisian
2. `Kampus_PT` - ITERA (konstan)
3. `Nomor.urut` - 1-429
4. `Jenis.Kelamin` - 2 kategori (210 & 218 responden)
5. `Umur` - 7 kategori (mayoritas kategori 5: 177 responden)
6. `Fakultas` - 3 kategori (FTIK, FTEIC, FST)
7. `Prodi` - 41 kategori (sangat bervariasi)
8. `Tingkat.Semester` - Integer 1-4 (mayoritas 4: 215 responden)
9. `Uang.Saku` - 5 kategori (mayoritas kategori 3: 228 responden)

**Variabel Kepemilikan Kendaraan**: 10. `kepemilikan.mobil` - 0-4 (mayoritas 0: 230 tidak punya) 11. `kepemilikan.motor` - 0-4 (mayoritas 1: 383 punya 1 unit) 12. `kepemilikan.sepeda` - 0-5 (mayoritas 0: 354 tidak punya) 13. `kendaraan.utama` - 7 kategori (mayoritas kategori 6: 259 responden - Sepeda Motor Pribadi)

**Variabel Tempat Tinggal**: 14. `kelurahan` - 85 kategori (mayoritas Tanjung Seneng: 63 responden) 15. `jenis.tempat.tinggal` - 7 kategori (mayoritas kategori 3: 200 - Kos Sendiri) 16. `nama.jalan.tempat.tinggal` - 314 alamat unik (teks bebas) 17. `alasan.pemilihan.lokasi.tempat.tinggal` - 306 alasan unik (mayoritas teks bebas)

**Variabel Perjalanan**: 18. `jarak..km.` - Character, 216 nilai unik, **1 missing** 19. `biaya.dalam.ribu2` - Integer 0-400,000 (median: 30,000)

**Variabel Jumlah Perjalanan Harian** (Integer 0-8): 20. `Jumlah.perjalanan.Senin` - Mayoritas: 3 perjalanan (181 responden) 21. `Jumlah.perjalanan.Selasa` - Mayoritas: 3 perjalanan (191 responden) 22. `Jumlah.perjalanan.Rabu` - Mayoritas: 3 perjalanan (209 responden) 23. `Jumlah.perjalanan.Kamis` - Mayoritas: 3 perjalanan (189 responden) 24. `Jumlah.perjalanan.Jumat` - Mayoritas: 3 perjalanan (160 responden) 25. `Jumlah.perjalanan.Sabtu` - Mayoritas: 0 perjalanan (221 responden) 26. `Jumlah.perjalanan.Ahad` - Mayoritas: 0 perjalanan (208 responden)

---

### Dataset UNILA (395 observasi)

**Perbedaan dari ITERA**:

- Tidak ada variabel `kelurahan`
- Variabel `Jumlah.motor` (bukan `kepemilikan.motor`)
- Variabel `Jenis.Tempat.Tinggal` (kapitalisasi berbeda)
- Variabel `Alamat` (bukan `nama.jalan.tempat.tinggal`)
- Variabel `Tingkat.Semester` bertipe character dengan format deskriptif
- Variabel `Jumlah.Perjalanan.Minggu` (bukan `Ahad`)
- **1 responden** tidak mengisi semua variabel jumlah perjalanan

**Rentang nilai biaya yang berbeda**:

- `biaya.dalam.ribu2`: 0-400 (mean: 74.12, median: 50)
- Jauh lebih rendah dari ITERA, kemungkinan satuan berbeda atau per trip

---

### Dataset UBL (379 observasi)

**Perbedaan Kritis**:

- Variabel `biaya.dalam.seminggu` (character, bukan numeric!)
- Variabel `Jumlah.perjalanan.Senin` bertipe character (ada empty strings)
- Missing values lebih banyak:
  - `kepemilikan.mobil`: 3 missing
  - `kepemilikan.sepeda`: 1 missing
  - `nama.jalan.tempat.tinggal`: 4 missing

**Variabel yang Sudah Dikategorikan dengan Baik**:

- `alasan.pemilihan.lokasi.tempat.tinggal` - Hanya 8 kategori (sudah dikelompokkan)

---

### Dataset UINRIL (400 observasi)

**Perbedaan**:

- Tidak ada variabel `Timestamp`
- Dataset paling "bersih" dengan hampir tidak ada missing values
- Variabel `biaya.dalam.ribu2` dengan range 0-150 (mean: 39.33, median: 40)

**Variabel yang Sudah Dikategorikan dengan Baik**:

- `alasan.pemilihan.lokasi.tempat.tinggal` - Hanya 8 kategori (sama seperti UBL)

---

## 🎯 Rekomendasi Strategi Data Cleaning

### Prioritas Tinggi (WAJIB)

#### 1. Standardisasi Nama Variabel

**Mapping yang Diusulkan**:

```r
# UNILA
Jumlah.motor → kepemilikan.motor
Jenis.Tempat.Tinggal → jenis.tempat.tinggal
Alamat → nama.jalan.tempat.tinggal
Jumlah.Perjalanan.Minggu → Jumlah.Perjalanan.Ahad

# UBL
biaya.dalam.seminggu → biaya.dalam.ribu2 (dengan konversi!)

# Semua dataset
Unifikasi kapitalisasi untuk variabel Jumlah.Perjalanan.*
```

---

#### 2. Konversi Tipe Data

**Jarak ke Kampus** (KRITIS):

```r
# Semua dataset
jarak..km. (character) → jarak.km (numeric)
# Langkah: gsub(",", ".", jarak..km.) |> as.numeric()
```

**Biaya Transportasi UBL**:

```r
# UBL - Perlu investigasi lebih lanjut
biaya.dalam.seminggu (character) → biaya.dalam.ribu2 (numeric)
# Catatan: Cek apakah perlu dibagi 7 atau ada konversi lain
```

**Tingkat Semester**:

```r
# UNILA, UBL, UINRIL
Tingkat.Semester (character) → extract angka → integer
# "1 (Semester 1 - Semester 2)" → 1
```

**Jumlah Perjalanan Senin (UBL)**:

```r
# UBL
Jumlah.perjalanan.Senin (character) → integer
# Empty string "" → NA
```

---

#### 3. Decode Variabel Kategorikal

> ⚠️ **MEMERLUKAN CODEBOOK/METADATA SURVEY**

Variabel yang perlu di-decode:

- `Jenis.Kelamin`: 1 → ?, 2 → ?
- `Umur`: 1-8 → Rentang usia
- `Fakultas`: 1-8 → Nama fakultas (berbeda per kampus!)
- `Uang.Saku`: 1-5 → Rentang uang saku
- `kendaraan.utama`: 1-7 → Jenis kendaraan
- `jenis.tempat.tinggal`: 1-8 → Jenis tempat tinggal

**Contoh dari data mentah yang terlihat**:

```
kendaraan.utama:
1 = Angkot/Angkutan Umum (?)
2 = Mobil Pribadi (?)
3 = Ojek Online/Transportasi Online
4 = Sepeda (?)
5 = Sepeda Motor Pribadi
6 = Jalan Kaki
7 = Lainnya (?)
```

---

### Prioritas Sedang

#### 4. Imputasi Missing Values

**Strategi per Variabel**:

| Variabel                          | Strategi               | Alasan                                              |
| --------------------------------- | ---------------------- | --------------------------------------------------- |
| `jarak..km.`                      | Mean/Median per kampus | Data numerik, distribusi mungkin berbeda per kampus |
| `Jumlah.Perjalanan.*` (UNILA)     | Mode per hari          | 1 responden, cocok pakai modus                      |
| `kepemilikan.mobil` (UBL)         | Mode = 0               | Mayoritas tidak punya mobil                         |
| `kepemilikan.sepeda` (UBL)        | Mode = 0               | Mayoritas tidak punya sepeda                        |
| `nama.jalan.tempat.tinggal` (UBL) | "Tidak disebutkan"     | Data kategorik/teks                                 |

---

#### 5. Standardisasi Format Tingkat.Semester

**Pilihan**:

- **Opsi A**: Ubah semua ke integer 1-4 (lebih mudah untuk analisis)
- **Opsi B**: Ubah semua ke format deskriptif (lebih mudah dibaca)
- **Opsi C**: Buat 2 variabel: `tingkat` (integer) dan `tingkat_label` (character)

**Rekomendasi**: Opsi A (integer) untuk efisiensi analisis.

---

### Prioritas Rendah (Opsional)

#### 6. Keputusan Variabel yang Tidak Konsisten

**Timestamp**:

- **Opsi A**: Pertahankan untuk ITERA, UNILA, UBL; set NA untuk UINRIL
- **Opsi B**: Buang semua (kurang relevan untuk analisis transportasi)
- **Rekomendasi**: Opsi B (buang)

**kelurahan**:

- **Opsi A**: Pertahankan untuk ITERA, UBL, UINRIL; set NA untuk UNILA
- **Opsi B**: Buang semua
- **Opsi C**: Standardisasi penulisan (preprocessing text)
- **Rekomendasi**: Opsi A (pertahankan dengan NA)

---

#### 7. Preprocessing Variabel Teks Bebas

Variabel yang bisa distandarisasi:

- `alasan.pemilihan.lokasi.tempat.tinggal` (ITERA, UNILA sangat bervariasi)
  - Gunakan clustering atau manual categorization seperti UBL/UINRIL (8 kategori)
- `kelurahan` (banyak inkonsistensi penulisan)
  - Standardisasi nama kelurahan

---

## 📝 Informasi Tambahan

### File yang Digunakan untuk Analisis

Script R untuk diagnosa: [`diagnosa_dataset.R`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/diagnosa_dataset.R)

**Source code**:

```r
# Fungsi untuk menganalisis dataset
analyze_dataset <- function(file_path, dataset_name) {
  # Baca data menggunakan delimiter semicolon
  data <- read.csv(file_path, sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8")

  # Analisis struktur per variabel
  # - Tipe data
  # - Missing values
  # - Unique values
  # - Kategorisasi (jika <= 20 unique values)
  # - Statistik deskriptif (untuk numerik)

  return(names(data))
}
```

### Output Lengkap

Laporan diagnosa mentah (teks) tersimpan di file ini yang telah diintegrasikan ke dalam walkthrough ini.

---

## 🚀 Langkah Selanjutnya

### Perlu Konfirmasi dari User

1. **Codebook/Metadata Survey**
   - Apakah tersedia file yang mendokumentasikan mapping kode numerik ke label?
   - Contoh: `1 = "Laki-laki"` atau `1 = "Perempuan"` untuk Jenis.Kelamin?

2. **Strategi Nama Variabel Akhir**
   - Setuju dengan standardisasi nama yang diusulkan?
   - Ada preferensi penamaan tertentu?

3. **Penanganan Biaya Transportasi UBL**
   - `biaya.dalam.seminggu` perlu dikonversi bagaimana?
   - Dibagi 7 untuk mendapat biaya harian?
   - Atau satuan berbeda?

4. **Variabel yang Akan Dipertahankan**
   - Apakah `Timestamp` perlu dipertahankan?
   - Apakah `kelurahan` perlu dipertahankan?

5. **Target Output**
   - Apakah akan di-merge menjadi 1 file besar?
   - Atau tetap terpisah dengan struktur konsisten?

### Persiapan Fase Cleaning

Setelah mendapat konfirmasi, saya akan:

1. Membuat script R untuk cleaning otomatis
2. Melakukan backup data original
3. Menjalankan cleaning bertahap dengan validasi
4. Generate laporan akhir hasil cleaning

---

**Status**: ⏸️ Menunggu feedback dan instruksi dari user

<!-- Bagian di bawah ini untuk catatan user -->

## 💬 Ruang Komentar User

Silakan tambahkan komentar, pertanyaan, atau instruksi Anda di bawah ini:

---
