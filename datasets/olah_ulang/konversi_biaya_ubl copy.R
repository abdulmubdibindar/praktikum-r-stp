# Script Konversi biaya.dalam.seminggu untuk UBL
# Berdasarkan approval user pada rencana_konversi_biaya_ubl.md

library(dplyr)

# Baca data
data_ubl <- read.csv("datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv",
    sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8"
)

cat("=== KONVERSI BIAYA.DALAM.SEMINGGU ===\n")
cat("Dataset: UBL\n")
cat("Total observasi:", nrow(data_ubl), "\n\n")

# Fungsi konversi berdasarkan keputusan user
konversi_biaya_seminggu <- function(nilai_asli) {
    # Simpan nilai asli
    nilai_clean <- tolower(trimws(as.character(nilai_asli)))

    # KASUS KHUSUS BERDASARKAN KEPUTUSAN USER:

    # 1. "20 JUTA RUPIAH" -> BUANG (set NA)
    if (grepl("juta", nilai_clean, ignore.case = TRUE)) {
        return(NA)
    }

    # 2. "19 menit" -> 19 ribu
    if (grepl("^19 menit", nilai_clean)) {
        return(19)
    }

    # 3. "motor menumpang dengan teman" -> 0
    if (grepl("menumpang|nebeng|teman", nilai_clean) && !grepl("[0-9]", nilai_clean)) {
        return(0)
    }

    # 4. Narasi panjang spesifik dengan 850ribu -> ambil 500
    if (grepl("jika di akumulasikan.*850", nilai_clean)) {
        return(500)
    }

    # 5. "menggunakan sepeda motor bensin 30rb" -> 30
    if (grepl("menggunakan sepeda motor bensin 30", nilai_clean)) {
        return(30)
    }

    # 6. "Biaya bensin dalam seminggu 50" -> 50
    if (grepl("biaya bensin dalam seminggu 50", nilai_clean)) {
        return(50)
    }

    # 7. Kasus dengan kata-kata tapi ada angka di akhir
    if (grepl("seminggu [0-9]+ rb", nilai_clean)) {
        angka <- as.numeric(gsub(".*seminggu ([0-9]+) rb.*", "\\1", nilai_clean))
        return(angka)
    }

    # EKSTRAKSI ANGKA UMUM
    # Hapus semua text kecuali angka dan tanda pemisah
    nilai_angka <- gsub("[^0-9., -]", "", nilai_clean)

    # Ekstrak semua angka
    angka_list <- as.numeric(unlist(strsplit(nilai_angka, "[^0-9.,]+")))
    angka_list <- angka_list[!is.na(angka_list)]

    if (length(angka_list) == 0) {
        return(NA)
    }

    # RENTANG NILAI (ada 2 angka dengan tanda '-') -> RATA-RATA
    if (grepl("-", nilai_clean) && length(angka_list) >= 2) {
        # Ambil 2 angka pertama untuk range
        return(mean(angka_list[1:2]))
    }

    # Jika lebih dari 2 angka (narasi panjang), ambil yang pertama sebagai default
    # kecuali sudah ditangani di kasus khusus
    if (length(angka_list) > 2) {
        return(angka_list[1])
    }

    # Jika hanya 1 angka
    nilai_num <- angka_list[1]

    # Handle format "50.000" (dengan titik ribuan) -> 50
    if (nilai_num >= 1000) {
        nilai_num <- nilai_num / 1000
    }

    return(nilai_num)
}

# Simpan nilai asli
data_ubl$biaya_asli <- data_ubl$biaya.dalam.seminggu

# Lakukan konversi
cat("Melakukan konversi...\n")
data_ubl$biaya.dalam.ribu2 <- sapply(data_ubl$biaya.dalam.seminggu, konversi_biaya_seminggu)

# Laporan hasil konversi
cat("\n=== HASIL KONVERSI ===\n")
cat("Total data:", nrow(data_ubl), "\n")
cat("Berhasil dikonversi:", sum(!is.na(data_ubl$biaya.dalam.ribu2)), "\n")
cat("Missing (NA):", sum(is.na(data_ubl$biaya.dalam.ribu2)), "\n\n")

# Statistik hasil
cat("STATISTIK HASIL (dalam ribu rupiah):\n")
cat("Min:", min(data_ubl$biaya.dalam.ribu2, na.rm = TRUE), "\n")
cat("Q1:", quantile(data_ubl$biaya.dalam.ribu2, 0.25, na.rm = TRUE), "\n")
cat("Median:", median(data_ubl$biaya.dalam.ribu2, na.rm = TRUE), "\n")
cat("Mean:", round(mean(data_ubl$biaya.dalam.ribu2, na.rm = TRUE), 2), "\n")
cat("Q3:", quantile(data_ubl$biaya.dalam.ribu2, 0.75, na.rm = TRUE), "\n")
cat("Max:", max(data_ubl$biaya.dalam.ribu2, na.rm = TRUE), "\n\n")

# Sample before-after untuk verifikasi
cat("=== SAMPLE BEFORE-AFTER (20 contoh acak) ===\n")
set.seed(123)
sample_idx <- sample(1:nrow(data_ubl), min(20, nrow(data_ubl)))
sample_df <- data.frame(
    No = sample_idx,
    Before = data_ubl$biaya_asli[sample_idx],
    After = data_ubl$biaya.dalam.ribu2[sample_idx]
)
print(sample_df, row.names = FALSE)

# Kasus-kasus khusus yang dihandle
cat("\n\n=== VERIFIKASI KASUS KHUSUS ===\n")

kasus_khusus <- list(
    "20 JUTA" = grep("juta", data_ubl$biaya_asli, ignore.case = TRUE, value = TRUE)[1],
    "19 menit" = grep("19 menit", data_ubl$biaya_asli, ignore.case = TRUE, value = TRUE)[1],
    "menumpang" = grep("menumpang", data_ubl$biaya_asli, ignore.case = TRUE, value = TRUE)[1],
    "850 ribu" = grep("850", data_ubl$biaya_asli, ignore.case = TRUE, value = TRUE)[1],
    "30rb seminggu" = grep("30rb sekitar", data_ubl$biaya_asli, ignore.case = TRUE, value = TRUE)[1],
    "bensin 50" = grep("bensin dalam seminggu 50", data_ubl$biaya_asli, ignore.case = TRUE, value = TRUE)[1]
)

for (nama in names(kasus_khusus)) {
    if (!is.na(kasus_khusus[[nama]])) {
        idx <- which(data_ubl$biaya_asli == kasus_khusus[[nama]])[1]
        cat(sprintf(
            "%s:\n  Before: %s\n  After: %s\n\n",
            nama,
            data_ubl$biaya_asli[idx],
            data_ubl$biaya.dalam.ribu2[idx]
        ))
    }
}

# Simpan hasil
cat("\n=== MENYIMPAN HASIL ===\n")

# Backup original
backup_file <- "datasets/olah_ulang/_backup_DataUtama_mhsUBL.csv"
file.copy("datasets/olah_ulang/DataUtama_mhsUBL_2ndprocess.csv", backup_file, overwrite = TRUE)
cat("Backup disimpan ke:", backup_file, "\n")

# Hapus kolom temporary
data_ubl$biaya_asli <- NULL

# Update nama kolom dari biaya.dalam.seminggu -> biaya.dalam.ribu2
# Simpan file baru
write.csv(data_ubl, "datasets/olah_ulang/DataUtama_mhsUBL.csv",
    row.names = FALSE, fileEncoding = "UTF-8"
)
cat("File updated disimpan ke: datasets/olah_ulang/DataUtama_mhsUBL.csv\n")

# Buat log konversi lengkap
log_df <- data.frame(
    Original = data_ubl$biaya.dalam.seminggu,
    Converted = data_ubl$biaya.dalam.ribu2,
    Is_Converted = !is.na(data_ubl$biaya.dalam.ribu2)
)
write.csv(log_df, "datasets/olah_ulang/log_konversi_biaya_ubl.csv",
    row.names = FALSE, fileEncoding = "UTF-8"
)
cat("Log konversi disimpan ke: datasets/olah_ulang/log_konversi_biaya_ubl.csv\n")

cat("\n✓ KONVERSI SELESAI!\n")
