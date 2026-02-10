# Laporan Hasil Konversi biaya.dalam.seminggu (UBL)

**Tanggal**: 10 Februari 2026  
**Status**: ✅ **BERHASIL**

---

## 📊 Ringkasan Konversi

| Metrik                  | Nilai                          |
| ----------------------- | ------------------------------ |
| **Total observasi**     | 379                            |
| **Berhasil dikonversi** | 378 (99.7%)                    |
| **Missing (NA)**        | 1 (0.3%)                       |
| **Backup file**         | `_backup_DataUtama_mhsUBL.csv` |
| **Log lengkap**         | `log_konversi_biaya_ubl.csv`   |

---

## 📈 Statistik Hasil Konversi

Semua nilai dalam satuan **RIBU RUPIAH**:

| Statistik    | Nilai (ribu) | Keterangan                           |
| ------------ | ------------ | ------------------------------------ |
| **Minimum**  | 0            | Valid (menumpang/tidak ada biaya)    |
| **Q1 (25%)** | 50           | 25% responden ≤ 50 ribu              |
| **Median**   | 70           | 50% responden ≤ 70 ribu              |
| **Mean**     | 99.18        | Rata-rata ~100 ribu/minggu           |
| **Q3 (75%)** | 120          | 75% responden ≤ 120 ribu             |
| **Maximum**  | 600          | Kemungkinan mahasiswa dari luar kota |

---

## ✅ Verifikasi Kasus Khusus

Semua kasus khusus telah dihandle sesuai keputusan user:

| Kasus                 | Before                                    | After | Status                      |
| --------------------- | ----------------------------------------- | ----- | --------------------------- |
| **Outlier ekstrem**   | `20 JUTA RUPIAH`                          | `NA`  | ✅ BUANG (sesuai instruksi) |
| **Satuan waktu**      | `19 menit`                                | `19`  | ✅ Convert ke 19 ribu       |
| **Tanpa biaya**       | `motor menumpang dengan teman`            | `0`   | ✅ Set ke 0                 |
| **Narasi panjang**    | `...850ribu`                              | `500` | ✅ Ambil 500 (bukan 850)    |
| **Keterangan detail** | `menggunakan sepeda motor bensin 30rb...` | `30`  | ✅ Ekstrak 30               |
| **Format singkat**    | `Biaya bensin dalam seminggu 50`          | `50`  | ✅ Ekstrak 50               |

---

## 📋 Contoh Konversi (Sample Random)

Berikut 20 contoh konversi yang dipilih secara acak:

| No  | Before     | After |
| --- | ---------- | ----- |
| 179 | `100 rb`   | 100   |
| 14  | `30 rb`    | 30    |
| 195 | `50 rb`    | 50    |
| 306 | `100rb`    | 100   |
| 118 | `20 rb`    | 20    |
| 299 | `150 ribu` | 150   |
| 229 | `100 rb`   | 100   |
| 244 | `245rb`    | 245   |
| 378 | `150 rb`   | 150   |
| 153 | `150 rb`   | 150   |
| 90  | `90`       | 90    |
| 91  | `40rb`     | 40    |
| 256 | `300 rb`   | 300   |
| 197 | `70 rb`    | 70    |
| 368 | `30 rb`    | 30    |
| 348 | `110 rb`   | 110   |
| 137 | `200 rb`   | 200   |
| 355 | `70 rb`    | 70    |
| 328 | `40 rb`    | 40    |
| 26  | `50k`      | 50    |

---

## 🔄 Perubahan pada Dataset

### File yang Diupdate:

✅ `DataUtama_mhsUBL.csv` - File utama dengan kolom baru `biaya.dalam.ribu2`

### Backup:

✅ `_backup_DataUtama_mhsUBL.csv` - Backup file original

### Log:

✅ `log_konversi_biaya_ubl.csv` - Log lengkap semua konversi (before-after)

---

## 🎯 Nama Variabel Baru

**Variabel lama**: `biaya.dalam.seminggu` (character, 105 format berbeda)  
**Variabel baru**: `biaya.dalam.ribu2` (numeric, dalam satuan ribu rupiah)

Nama disesuaikan dengan konvensi dataset lain (ITERA, UNILA, UINRIL) yang menggunakan `biaya.dalam.ribu2`.

---

## 📝 Catatan Teknis

### Metode Konversi:

1. **Kasus khusus** dihandle dengan pattern matching spesifik
2. **Rentang nilai** (100-150 rb) → diambil **rata-ratanya** (125)
3. **Format ribuan** (50.000) → dibagi 1000 menjadi (50)
4. **Format "k"** (50k) → dikonversi ke 50
5. **Narasi panjang** → ekstraksi angka sesuai kasus

### Missing Value (NA):

Hanya **1 datum** yang di-set NA:

- `"20 JUTA RUPIAH"` → outlier ekstrem 1000x lipat, di-BUANG sesuai instruksi

---

## ✨ Kesimpulan

✅ Konversi **99.7% berhasil** (378 dari 379 observasi)  
✅ Semua kasus khusus ditangani sesuai keputusan user  
✅ Statistik hasil masuk akal (median 70 ribu/minggu)  
✅ Data siap untuk analisis lebih lanjut

**Dataset UBL sekarang memiliki variabel `biaya.dalam.ribu2` yang konsisten dengan dataset lainnya!** 🎉
