# Rencana Konversi Variabel `biaya.dalam.seminggu` (UBL)

## 📊 Hasil Analisis

**Dataset**: DataUtama_mhsUBL.csv  
**Variabel**: `biaya.dalam.seminggu`  
**Total Observasi**: 379 responden  
**Total Nilai Unik**: 105 variasi berbeda

---

## 🔍 Temuan Masalah

### 1. Format Nilai yang Sangat Bervariasi

Data mengandung campuran format yang tidak konsisten:

| Kategori                        | Contoh                                     | Frekuensi                    |
| ------------------------------- | ------------------------------------------ | ---------------------------- |
| **Angka + "rb"** (banyak spasi) | `50 rb`, `100 rb`, `70 rb`                 | 43 + 31 + 23 = **Mayoritas** |
| **Angka + "rb"** (tanpa spasi)  | `100rb`, `50rb`, `70rb`                    | Cukup sering                 |
| **Angka + "ribu"**              | `30 ribu`, `150 ribu`, `200 ribu`          | Beberapa                     |
| **Angka saja**                  | `50`, `40`, `150`, `200`                   | 10 nilai (14 responden)      |
| **Rentang nilai**               | `100 - 150 rb`, `50- 80 rb`                | 5 kasus                      |
| **Nilai dengan keterangan**     | `100 rb untuk ongkos`, `50 rb bensin`      | Beberapa                     |
| **Format khusus**               | `50k`, `50.000 rb perminggu`               | Jarang                       |
| **Nilai ekstrem/salah**         | `20 JUTA RUPIAH` ⚠️                        | 1 kasus (outlier)            |
| **Nilai tidak valid**           | `19 menit`, `motor menumpang dengan teman` | 2-3 kasus                    |
| **Narasi panjang**              | `jika di akumulasikan untuk bensin...`     | 1 kasus                      |

---

## 🎯 Rencana Konversi

### Strategi Konversi Bertahap

#### **Tahap 1: Ekstraksi Angka dari Teks**

**Metode**:

1. Hapus semua huruf, kata-kata (rb, ribu, k, dll)
2. Hapus keterangan tambahan (untuk ongkos, bensin, dll)
3. Ekstrak angka pertama yang ditemukan
4. Replace titik/koma dengan standar desimal

**Contoh Konversi**:

```r
"50 rb"              → 50
"100rb"              → 100
"30 ribu"            → 30
"50.000 rb"          → 50  # Asumsi satuan ribu
"50k"                → 50  # k = ribu
"100 - 150 rb"       → 100 # Ambil nilai minimum
"50- 80 rb"          → 50  # Ambil nilai minimum
"100 rb untuk ongkos" → 100
```

---

#### **Tahap 2: Penanganan Kasus Khusus**

| Nilai Original                      | Nilai Konversi                             | Justifikasi                                                      |
| ----------------------------------- | ------------------------------------------ | ---------------------------------------------------------------- |
| `0`                                 | `0`                                        | Valid - tidak ada biaya (menumpang, jalan kaki, dll)             |
| `50`, `40`, `150`, dll (angka saja) | Tetap (asumsi ribu)                        | Konsisten dengan nilai mayoritas                                 |
| `20 JUTA RUPIAH`                    | `NA` atau `20000`                          | ⚠️ **PERLU KEPUTUSAN**: Outlier ekstrem, kemungkinan salah input |
| `19 menit`                          | `NA`                                       | Invalid - bukan satuan uang                                      |
| `motor menumpang dengan teman`      | `0`                                        | Tidak ada biaya transportasi                                     |
| Narasi panjang dengan angka         | Ekstrak angka utama                        | Misal: `850` dari narasi panjang                                 |
| Rentang nilai (min-max)             | Ambil nilai **minimum** atau **rata-rata** | ⚠️ **PERLU KEPUTUSAN**                                           |

---

#### **Tahap 3: Standarisasi Satuan**

**Asumsi**:

- Semua nilai dalam satuan **RIBU RUPIAH** (per minggu)
- Nilai `50 rb` = 50 ribu = 50,000 rupiah
- Nilai `50.000 rb` = 50 ribu (titik sebagai separator ribuan)

**Output akhir**: Numerik dalam satuan **ribu rupiah**

---

## 📋 Kasus-Kasus yang Memerlukan Keputusan User

### 🔴 KRITIS - Perlu Keputusan

**1. Rentang Nilai (Range)**

Ada 5 kasus dengan rentang, contoh:

- `100 - 150 rb`
- `50- 80 rb`
- `55 - 60 rb`
- `250 -300 rb`
- `100 sampai 200 rb`

**Pilihan**:

- **Opsi A**: Ambil nilai **MINIMUM** (lebih konservatif) → `100 - 150 rb` = `100`
- **Opsi B**: Ambil nilai **RATA-RATA** (lebih representatif) → `100 - 150 rb` = `125`
- **Opsi C**: Set sebagai **NA** (hilangkan, karena ambigu)

**Rekomendasi saya**: **Opsi B** (rata-rata), karena lebih representatif.

---

**2. Outlier Ekstrem: "20 JUTA RUPIAH"**

Nilai ini **1000x lipat** lebih besar dari median (50 ribu).

**Pilihan**:

- **Opsi A**: Set sebagai **NA** (anggap salah input)
- **Opsi B**: Koreksi manual menjadi **200** ribu (asumsi typo, harusnya 200rb)
- **Opsi C**: Pertahankan sebagai **20,000** (20 juta dalam ribu)

**Rekomendasi saya**: **Opsi A** (set NA), karena kemungkinan besar salah input/typo.

---

**3. Nilai dengan Narasi Panjang**

Contoh:

- `jika di akumulasikan untuk bensin mobil saja bisa 500ribu seminggu, untuk makan 50ribu 1hari, jika 7hari maka 350ribu jadi total seminggu 850ribu`
- `menggunakan sepeda motor bensin 30rb sekitar seminggu`
- `Biaya bensin dalam seminggu 50`

**Pilihan**:

- **Opsi A**: Ekstrak angka **terakhir** yang disebutkan (asumsi itu total akhir)
- **Opsi B**: Ekstrak angka **pertama** yang disebutkan
- **Opsi C**: Manual review per kasus

**Rekomendasi saya**: **Opsi A** (angka terakhir), karena biasanya itu total kesimpulan.

Untuk kasus di atas:

- Narasi panjang → `850` (total akhir yang disebutkan)
- `menggunakan sepeda motor bensin 30rb sekitar seminggu` → `30`
- `Biaya bensin dalam seminggu 50` → `50`

---

**4. Nilai "0" dan "motor menumpang dengan teman"**

**Pilihan**:

- **Opsi A**: Set sebagai **0** (valid - tidak ada biaya)
- **Opsi B**: Set sebagai **NA** (anggap tidak menjawab)

**Rekomendasi saya**: **Opsi A** (set 0), karena menunjukkan tidak ada biaya transportasi.

---

## 💻 Preview Kode Konversi

```r
# Fungsi konversi biaya.dalam.seminggu
konversi_biaya_seminggu <- function(nilai_asli) {
  # Simpan nilai asli untuk log
  nilai_clean <- tolower(trimws(nilai_asli))

  # Kasus khusus: narasi tanpa biaya
  if (grepl("menumpang|nebeng|gratis|teman", nilai_clean, ignore.case = TRUE)) {
    return(0)
  }

  # Kasus khusus: nilai tidak valid
  if (grepl("menit|jam|hari", nilai_clean, ignore.case = TRUE) &
      !grepl("[0-9]+ rb|ribu", nilai_clean)) {
    return(NA)
  }

  # Kasus khusus: outlier ekstrem
  if (grepl("juta", nilai_clean, ignore.case = TRUE)) {
    return(NA)  # Atau set ke nilai tertentu sesuai keputusan user
  }

  # Ekstrak semua angka dari string
  angka_list <- as.numeric(unlist(regmatches(nilai_clean,
                                               gregexpr("[0-9]+\\.?[0-9]*", nilai_clean))))

  if (length(angka_list) == 0) {
    return(NA)
  }

  # Jika ada rentang (2 angka), ambil rata-rata
  if (length(angka_list) == 2) {
    return(mean(angka_list))
  }

  # Jika lebih dari 2 angka (narasi panjang), ambil yang terakhir
  if (length(angka_list) > 2) {
    return(tail(angka_list, 1))
  }

  # Jika hanya 1 angka
  nilai_num <- angka_list[1]

  # Handle format seperti "50.000" (dengan titik ribuan) menjadi 50
  if (nilai_num > 1000) {
    nilai_num <- nilai_num / 1000
  }

  return(nilai_num)
}
```

---

## 📊 Hasil Konversi Estimasi

Berdasarkan konversi dengan kode di atas:

| Statistik        | Nilai (dalam ribu rupiah)                    |
| ---------------- | -------------------------------------------- |
| **Min**          | 0                                            |
| **Q1 (25%)**     | ~50                                          |
| **Median**       | ~70                                          |
| **Mean**         | ~100                                         |
| **Q3 (75%)**     | ~150                                         |
| **Max**          | ~600 (atau lebih tergantung handling narasi) |
| **NA (missing)** | ~5-10 kasus                                  |

---

## ✅ Checklist Keputusan yang Diperlukan

Silakan konfirmasi keputusan Anda untuk kasus-kasus berikut:

- [ ] **Rentang nilai**: Ambil minimum, rata-rata, atau set NA?
  - Saya usulkan: **Rata-rata**

- [ ] **Outlier "20 JUTA RUPIAH"**: Set NA, koreksi ke 200, atau pertahankan?
  - Saya usulkan: **Set NA**

- [ ] **Narasi panjang**: Ambil angka pertama, terakhir, atau manual?
  - Saya usulkan: **Angka terakhir** (asumsi total)

- [ ] **Nilai "0" dan text tanpa angka**: Set 0 atau NA?
  - Saya usulkan: **Set 0** untuk yang jelas menunjukkan tidak ada biaya

- [ ] **Format "50.000 rb"**: Asumsi titik sebagai separator ribuan?
  - Saya usulkan: **Ya**, convert ke 50

---

## 🚀 Langkah Setelah Approval

Setelah Anda approve rencana ini:

1. Saya akan jalankan konversi dengan kode di atas
2. Generate laporan detail hasil konversi (before-after)
3. Simpan backup data original
4. Update dataset UBL dengan kolom baru `biaya.transportasi` (numerik)
5. Buat log konversi untuk tracking

**Apakah rencana konversi ini sudah sesuai? Silakan komentari bagian yang perlu direvisi!**
