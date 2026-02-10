# Script Fix UBL dengan Penanganan Quote yang Lebih Aman
library(dplyr)

cat("===========================================\n")
cat("FIX UBL - PENANGANAN QUOTE YANG LEBIH AMAN\n")
cat("===========================================\n\n")

# Cek apakah file comeback masih ada
if (!file.exists("datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv")) {
    cat("ERROR: File comeback sudah dihapus!\n")
    cat("Menggunakan backup yang lain...\n")

    # Gunakan file backup yang original
    if (file.exists("datasets/olah_ulang/_backup_DataUtama_mhsUBL.csv")) {
        file.copy(
            "datasets/olah_ulang/_backup_DataUtama_mhsUBL.csv",
            "datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv"
        )
        cat("  ✓ Menggunakan _backup_DataUtama_mhsUBL.csv\n\n")
    } else {
        stop("Tidak ada file backup yang tersedia!")
    }
}

# 1. Baca file COMEBACK dengan delimiter SEMICOLON
cat("Step 1: Membaca file comeback...\n")
data_ubl <- read.csv("datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv",
    sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8",
    quote = '"'
)

cat("  ✓ File comeback berhasil dibaca\n")
cat("  - Jumlah baris:", nrow(data_ubl), "\n")
cat("  - Jumlah variabel:", ncol(data_ubl), "\n\n")

# 2. Fungsi konversi biaya
konversi_biaya_seminggu <- function(nilai_asli) {
    nilai_clean <- tolower(trimws(as.character(nilai_asli)))

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

    nilai_angka <- gsub("[^0-9., -]", "", nilai_clean)
    angka_list <- as.numeric(unlist(strsplit(nilai_angka, "[^0-9.,]+")))
    angka_list <- angka_list[!is.na(angka_list)]

    if (length(angka_list) == 0) {
        return(NA)
    }

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

# 3. Lakukan konversi
cat("Step 2: Melakukan konversi biaya...\n")

if (!"biaya.dalam.ribu2" %in% names(data_ubl)) {
    data_ubl$biaya.dalam.ribu2 <- sapply(data_ubl$biaya.dalam.seminggu, konversi_biaya_seminggu)
    cat("  ✓ Konversi berhasil\n")
} else {
    cat("  ! Kolom biaya.dalam.ribu2 sudah ada, skip konversi\n")
}

cat("  - Total observasi:", nrow(data_ubl), "\n")
cat("  - Berhasil dikonversi:", sum(!is.na(data_ubl$biaya.dalam.ribu2)), "\n")
cat("  - Missing (NA):", sum(is.na(data_ubl$biaya.dalam.ribu2)), "\n\n")

# 4. Simpan dengan METODE YANG LEBIH AMAN
cat("Step 3: Menyimpan dengan write.table (quote pada string saja)...\n")

write.table(data_ubl,
    "datasets/olah_ulang/DataUtama_mhsUBL.csv",
    sep = ";",
    row.names = FALSE,
    quote = TRUE, # Quote semua untuk keamanan
    na = "",
    qmethod = "double", # Escape quote dengan double quote
    fileEncoding = "UTF-8"
)

cat("  ✓ File berhasil disimpan\n\n")

# 5. Verifikasi SEGERA
cat("Step 4: Verifikasi hasil...\n")

data_verify <- read.csv("datasets/olah_ulang/DataUtama_mhsUBL.csv",
    sep = ";",
    stringsAsFactors = FALSE,
    encoding = "UTF-8",
    quote = '"',
    na.strings = c("", "NA")
)

cat("  Hasil verifikasi:\n")
cat("  - Jumlah baris SEBELUM:", nrow(data_ubl), "\n")
cat("  - Jumlah baris SESUDAH:", nrow(data_verify), "\n")

if (nrow(data_verify) == nrow(data_ubl)) {
    cat("  ✅ SUKSES! Jumlah baris sama\n")
} else {
    cat("  ❌ WARNING! Ada", nrow(data_ubl) - nrow(data_verify), "baris yang hilang\n")
}

cat("  - Jumlah variabel:", ncol(data_verify), "\n")
cat("  - Kolom Fakultas ada:", "Fakultas" %in% names(data_verify), "\n")
cat("  - Kolom Prodi ada:", "Prodi" %in% names(data_verify), "\n")

# Sample jenis.tempat.tinggal
if ("jenis.tempat.tinggal" %in% names(data_verify)) {
    cat("\n  Sample jenis.tempat.tinggal (10 nilai):\n")
    for (i in 1:min(10, nrow(data_verify))) {
        cat("    ", i, ":", data_verify$jenis.tempat.tinggal[i], "\n")
    }

    # Frekuensi
    cat("\n  Frekuensi jenis.tempat.tinggal:\n")
    freq <- table(data_verify$jenis.tempat.tinggal, useNA = "ifany")
    freq_sorted <- sort(freq, decreasing = TRUE)

    for (i in 1:min(10, length(freq_sorted))) {
        cat(sprintf("    %2d. %-40s : %3d\n", i, names(freq_sorted)[i], freq_sorted[i]))
    }
}

cat("\n✅ VERIFIKASI SELESAI!\n")
