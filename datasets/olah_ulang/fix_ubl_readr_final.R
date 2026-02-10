# Script Fix UBL menggunakan readr (PALING ROBUST!)
library(readr)
library(dplyr)

cat("===========================================\n")
cat("FIX UBL MENGGUNAKAN READR (READ + WRITE)\n")
cat("===========================================\n\n")

# 1. Baca dengan readr (lebih toleran)
cat("Step 1: Membaca _backup file dengan readr...\n")

data_ubl <- read_delim("datasets/olah_ulang/_backup_DataUtama_mhsUBL.csv",
    delim = ";",
    locale = locale(encoding = "UTF-8"),
    col_types = cols(.default = col_character()),
    na = c("", "NA"),
    trim_ws = TRUE,
    escape_double = TRUE,
    escape_backslash = FALSE,
    quote = '"'
)

cat("  ✓ File berhasil dibaca\n")
cat("  - Jumlah baris:", nrow(data_ubl), "\n")
cat("  - Jumlah variabel:", ncol(data_ubl), "\n\n")

# 2. Konversi biaya
cat("Step 2: Melakukan konversi biaya...\n")

konversi_biaya_seminggu <- function(nilai_asli) {
    nilai_clean <- tolower(trimws(as.character(nilai_asli)))

    if (is.na(nilai_clean) || nilai_clean == "") {
        return(NA)
    }

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

# Hapus kolom biaya.dalam.ribu2 jika sudah ada
if ("biaya.dalam.ribu2" %in% names(data_ubl)) {
    data_ubl <- data_ubl %>% select(-biaya.dalam.ribu2)
}

# Konversi
biaya_col_name <- names(data_ubl)[grepl("biaya.*dalam.*seminggu", names(data_ubl), ignore.case = TRUE)]

if (length(biaya_col_name) > 0) {
    data_ubl$biaya.dalam.ribu2 <- sapply(data_ubl[[biaya_col_name[1]]], konversi_biaya_seminggu)
    cat("  ✓ Konversi berhasil\n")
    cat("  - Total observasi:", nrow(data_ubl), "\n")
    cat("  - Berhasil dikonversi:", sum(!is.na(data_ubl$biaya.dalam.ribu2)), "\n")
    cat("  - Missing (NA):", sum(is.na(data_ubl$biaya.dalam.ribu2)), "\n\n")
} else {
    cat("  ! Kolom biaya.dalam.seminggu tidak ditemukan!\n\n")
}

# 3. Simpan dengan readr (LEBIH ROBUST!)
cat("Step 3: Menyimpan dengan readr::write_delim...\n")

write_delim(data_ubl,
    "datasets/olah_ulang/DataUtama_mhsUBL.csv",
    delim = ";",
    na = "",
    quote = "needed", # Only quote when needed
    escape = "double",
    eol = "\n",
    col_names = TRUE
)

cat("  ✓ File berhasil disimpan dengan semicolon delimiter\n\n")

# 4. Verifikasi SEGERA
cat("Step 4: Verifikasi hasil...\n")

data_verify <- read_delim("datasets/olah_ulang/DataUtama_mhsUBL.csv",
    delim = ";",
    locale = locale(encoding = "UTF-8"),
    col_types = cols(.default = col_character()),
    trim_ws = TRUE
)

cat("  Hasil verifikasi:\n")
cat("  - Jumlah baris SEBELUM:", nrow(data_ubl), "\n")
cat("  - Jumlah baris SESUDAH:", nrow(data_verify), "\n")

if (nrow(data_verify) == nrow(data_ubl)) {
    cat("  ✅ SUKSES! Jumlah baris sama\n")
} else {
    cat("  ❌ WARNING! Ada", abs(nrow(data_ubl) - nrow(data_verify)), "baris yang berbeda\n")
}

cat("  - Jumlah variabel:", ncol(data_verify), "\n")
cat("  - Kolom Fakultas ada:", "Fakultas" %in% names(data_verify), "\n")
cat("  - Kolom Prodi ada:", "Prodi" %in% names(data_verify), "\n")
cat("  - Kolom biaya.dalam.ribu2 ada:", "biaya.dalam.ribu2" %in% names(data_verify), "\n\n")

# Sample jenis.tempat.tinggal
if ("jenis tempat tinggal" %in% names(data_verify)) {
    cat("  Sample jenis tempat tinggal (10 nilai):\n")
    for (i in 1:min(10, nrow(data_verify))) {
        cat("    ", i, ":", data_verify$`jenis tempat tinggal`[i], "\n")
    }

    # Frekuensi
    cat("\n  Frekuensi jenis tempat tinggal (Top 10):\n")
    freq <- table(data_verify$`jenis tempat tinggal`, useNA = "ifany")
    freq_sorted <- sort(freq, decreasing = TRUE)

    for (i in 1:min(10, length(freq_sorted))) {
        cat(sprintf("    %2d. %-40s : %3d\n", i, names(freq_sorted)[i], freq_sorted[i]))
    }
}

# Hapus file comeback jika ada
if (file.exists("datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv")) {
    file.remove("datasets/olah_ulang/DataUtama_mhsUBL_comeback.csv")
    cat("\n  ✓ File comeback dihapus\n")
}

cat("\n✅ PROSES SELESAI!\n")
