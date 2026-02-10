# 📋 RINGKASAN KEPUTUSAN FINAL - MISSING VALUES HANDLING

**Tanggal**: 10 Februari 2026  
**Status**: ✅ **Semua keputusan sudah final**

---

## KEPUTUSAN FINAL PER VARIABEL

| Dataset    | Variabel                    | Missing            | Strategi               | Keterangan                   |
| ---------- | --------------------------- | ------------------ | ---------------------- | ---------------------------- |
| **ITERA**  | `jarak..km.`                | 1 (0.23%)          | ✅ **Imputasi median** | Nilai jarak kampus           |
| **UNILA**  | `jarak..km.`                | 1 (0.25%)          | ✅ **Imputasi median** | Nilai jarak kampus           |
| **UNILA**  | `Jumlah.Perjalanan.*`       | 1 obs (semua hari) | ✅ **DROP observasi**  | Missing di 7 kolom sekaligus |
| **UBL**    | `kepemilikan.mobil`         | 3 (0.79%)          | ✅ **Imputasi median** | 0 atau 1 (integer)           |
| **UBL**    | `kepemilikan.sepeda`        | 1 (0.26%)          | ✅ **Imputasi median** | 0 atau 1 (integer)           |
| **UBL**    | `biaya.dalam.ribu2`         | 1 (0.26%)          | ✅ **DROP observasi**  | NA dari outlier "20 JUTA"    |
| **UBL**    | `nama.jalan.tempat.tinggal` | 4 (1.06%)          | Biarkan NA             | Tidak kritis                 |
| **UINRIL** | -                           | 0                  | -                      | Tidak ada missing            |

---

## ESTIMASI OBSERVASI FINAL

Setelah semua cleaning:

| Dataset    | Observasi Awal | Drop  | Observasi Final |
| ---------- | -------------- | ----- | --------------- |
| **ITERA**  | 428            | 0     | **428**         |
| **UNILA**  | 395            | 1     | **394**         |
| **UBL**    | 379            | 1     | **378**         |
| **UINRIL** | 400            | 0     | **400**         |
| **TOTAL**  | **1,602**      | **2** | **1,600**       |

---

## IMPLEMENTASI IMPUTASI MEDIAN

### Untuk variabel numerik (`jarak.km`):

```r
# Contoh untuk ITERA
median_jarak <- median(data_itera$jarak.km, na.rm = TRUE)
data_itera$jarak.km[is.na(data_itera$jarak.km)] <- median_jarak
```

### Untuk variabel integer (`kepemilikan.mobil`, `kepemilikan.sepeda`):

```r
# Contoh untuk UBL kepemilikan.mobil
median_mobil <- median(as.numeric(data_ubl$kepemilikan.mobil), na.rm = TRUE)
data_ubl$kepemilikan.mobil[is.na(data_ubl$kepemilikan.mobil)] <- as.character(round(median_mobil))
```

### Untuk DROP observasi:

```r
# UNILA - drop jika semua jumlah perjalanan NA
cols_perjalanan <- c('Jumlah.Perjalanan.Senin', 'Jumlah.Perjalanan.Selasa',
                     'Jumlah.Perjalanan.Rabu', 'Jumlah.Perjalanan.Kamis',
                     'Jumlah.Perjalanan.Jumat', 'Jumlah.Perjalanan.Sabtu',
                     'Jumlah.Perjalanan.Minggu')
all_na <- rowSums(is.na(data_unila[cols_perjalanan])) == length(cols_perjalanan)
data_unila <- data_unila[!all_na, ]

# UBL - drop observasi dengan biaya.dalam.ribu2 = NA
data_ubl <- data_ubl[!is.na(data_ubl$biaya.dalam.ribu2), ]
```

---

## ✅ READY FOR IMPLEMENTATION

Keputusan sudah final dan siap diimplementasikan dalam master cleaning script!

**Next**: Buat master cleaning script yang mencakup:

1. ✅ Rename variabel (lowercase + dot separator)
2. ✅ Standardisasi nilai kategoris
3. ✅ Convert data types
4. ✅ Handle missing values (sesuai tabel di atas)
5. ✅ Remove unwanted columns (Timestamp, kelurahan ITERA)
6. ✅ Create final cleaned datasets

---

**Files Updated**:

- [`cleaning_protocol.md`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/cleaning_protocol.md) ✅
- [`laporan_verifikasi_final.md`](file:///c:/Users/LENOVO/praktikum-r-stp/datasets/olah_ulang/laporan_verifikasi_final.md) ✅
