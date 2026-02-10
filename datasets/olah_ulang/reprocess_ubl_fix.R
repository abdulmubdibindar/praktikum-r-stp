# Script Reprocessing UBL Dataset dengan Delimiter yang Benar
# Menggunakan file comeback dan save dengan delimiter semicolon

library(dplyr)

cat("===========================================\n")
cat("REPROCESSING DATASET UBL DENGAN FIX\n")
cat("===========================================\n\n")

# 1. Baca file COMEBACK dengan delimiter SEMICOLON
cat("Step 1: Membaca file comeback...\n")
data_ubl <- read.csv("datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv",
    sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8"
)

cat("  ✓ File comeback berhasil dibaca\n")
cat("  - Jumlah baris:", nrow(data_ubl), "\n")
cat("  - Jumlah variabel:", ncol(data_ubl), "\n\n")

# 2. Fungsi konversi biaya (sama seperti sebelumnya)
cat("Step 2: Menyiapkan fungsi konversi biaya...\n")

konversi_biaya_seminggu <- function(nilai_asli) {
    nilai_clean <- tolower(trimws(as.character(nilai_asli)))

    # KASUS KHUSUS BERDASARKAN KEPUTUSAN USER:
    if (grepl("juta", nilai_clean, ignore.case = TRUE)) {
        return(NA)
    }

    if (grepl("^19 menit", nilai_clean)) {
        return(19)
    }

    if (grepl("menumpang|nebeng|teman", nilai_clean) && !grepl("[0-9]", nilai_clean)) {
        return(0)
    }

    if (grepl("jika di akumulasikan.*850", nilai_clean)) {
        return(500)
    }

    if (grepl("menggunakan sepeda motor bensin 30", nilai_clean)) {
        return(30)
    }

    if (grepl("biaya bensin dalam seminggu 50", nilai_clean)) {
        return(50)
    }

    if (grepl("seminggu [0-9]+ rb", nilai_clean)) {
        angka <- as.numeric(gsub(".*seminggu ([0-9]+) rb.*", "\\1", nilai_clean))
        return(angka)
    }

    # EKSTRAKSI ANGKA UMUM
    nilai_angka <- gsub("[^0-9., -]", "", nilai_clean)
    angka_list <- as.numeric(unlist(strsplit(nilai_angka, "[^0-9.,]+")))
    angka_list <- angka_list[!is.na(angka_list)]

    if (length(angka_list) == 0) {
        return(NA)
    }

    # RENTANG NILAI -> RATA-RATA
    if (grepl("-", nilai_clean) && length(angka_list) >= 2) {
        return(mean(angka_list[1:2]))
    }

    if (length(angka_list) > 2) {
        return(angka_list[1])
    }

    nilai_num <- angka_list[1]

    if (nilai_num >= 1000) {
        nilai_num <- nilai_num / 1000
    }

    return(nilai_num)
}

cat("  ✓ Fungsi konversi siap\n\n")

# 3. Lakukan konversi biaya
cat("Step 3: Melakukan konversi biaya...\n")

# Check apakah kolom biaya.dalam.ribu2 sudah ada (dari konversi sebelumnya)
if ("biaya.dalam.ribu2" %in% names(data_ubl)) {
    cat("  ! Kolom biaya.dalam.ribu2 sudah ada, akan diupdate ulang\n")
} else {
    cat("  - Membuat kolom baru biaya.dalam.ribu2\n")
}

data_ubl$biaya.dalam.ribu2 <- sapply(data_ubl$biaya.dalam.seminggu, konversi_biaya_seminggu)

cat("  ✓ Konversi berhasil\n")
cat("  - Berhasil dikonversi:", sum(!is.na(data_ubl$biaya.dalam.ribu2)), "dari", nrow(data_ubl), "\n")
cat("  - Missing (NA):", sum(is.na(data_ubl$biaya.dalam.ribu2)), "\n\n")

# 4. Simpan kembali dengan DELIMITER SEMICOLON
cat("Step 4: Menyimpan ke DataUtama_mhsUBL.csv dengan delimiter semicolon...\n")

write.table(data_ubl,
    "datasets/olah_ulang/DataUtama_mhsUBL.csv",
    sep = ";",
    row.names = FALSE,
    quote = TRUE,
    fileEncoding = "UTF-8"
)

cat("  ✓ File berhasil disimpan dengan delimiter semicolon\n\n")

# 5. Hapus file comeback
cat("Step 5: Menghapus file comeback...\n")
file.remove("datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv")
cat("  ✓ File comeback dihapus\n\n")

# 6. Verifikasi hasil
cat("Step 6: Verifikasi hasil...\n")
cat("  Membaca ulang file yang baru disimpan...\n")

data_verify <- read.csv("datasets/olah_ulang/DataUtama_mhsUBL.csv",
    sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8"
)

cat("  ✓ Verifikasi berhasil!\n")
cat("  - Jumlah baris:", nrow(data_verify), "\n")
cat("  - Jumlah variabel:", ncol(data_verify), "\n")
cat("  - Kolom Fakultas ada:", "Fakultas" %in% names(data_verify), "\n")
cat("  - Kolom Prodi ada:", "Prodi" %in% names(data_verify), "\n")
cat("  - Kolom jenis.tempat.tinggal ada:", "jenis.tempat.tinggal" %in% names(data_verify), "\n")

# Sample check jenis.tempat.tinggal
if ("jenis.tempat.tinggal" %in% names(data_verify)) {
    cat("\n  Sample jenis.tempat.tinggal (5 nilai pertama):\n")
    for (i in 1:min(5, nrow(data_verify))) {
        cat("    ", i, ":", data_verify$jenis.tempat.tinggal[i], "\n")
    }
}

cat("\n✅ REPROCESSING SELESAI!\n")
