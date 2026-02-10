# Script Verifikasi Dataset UBL dengan Penanganan Quote yang Lebih Baik
library(dplyr)

cat("===========================================\n")
cat("VERIFIKASI ULANG DATASET UBL (KOMA + QUOTE)\n")
cat("===========================================\n\n")

# Baca dengan delimiter KOMA dan fill=TRUE untuk handle kolom yang tidak konsisten
data_ubl <- read.csv("datasets/olah_ulang/DataUtama_mhsUBL.csv",
    sep = ",",
    quote = '"',
    stringsAsFactors = FALSE,
    encoding = "UTF-8",
    fill = TRUE,
    comment.char = ""
)

cat("Dataset UBL (dengan delimiter koma)\n")
cat("-----------------------------------\n")
cat("Jumlah Baris:", nrow(data_ubl), "\n")
cat("Jumlah Variabel:", ncol(data_ubl), "\n\n")

cat("NAMA KOLOM:\n")
for (i in 1:length(names(data_ubl))) {
    cat(sprintf("%2d. %s\n", i, names(data_ubl)[i]))
}

cat("\n\nVERIFIKASI FAKULTAS DAN PRODI:\n")
cat("-----------------------------\n")

# Fakultas
if ("Fakultas" %in% names(data_ubl)) {
    cat("✅ Kolom FAKULTAS ditemukan!\n")
    cat("   Tipe data:", class(data_ubl$Fakultas), "\n")
    cat("   Sample 5 nilai:\n")
    for (i in 1:min(5, nrow(data_ubl))) {
        cat("     ", i, ":", data_ubl$Fakultas[i], "\n")
    }
    cat("   Unique values:", length(unique(data_ubl$Fakultas)), "\n\n")
} else {
    cat("❌ Kolom FAKULTAS tidak ditemukan\n\n")
}

# Prodi
if ("Prodi" %in% names(data_ubl)) {
    cat("✅ Kolom PRODI ditemukan!\n")
    cat("   Tipe data:", class(data_ubl$Prodi), "\n")
    cat("   Sample 5 nilai:\n")
    for (i in 1:min(5, nrow(data_ubl))) {
        cat("     ", i, ":", data_ubl$Prodi[i], "\n")
    }
    cat("   Unique values:", length(unique(data_ubl$Prodi)), "\n\n")
} else {
    cat("❌ Kolom PRODI tidak ditemukan\n\n")
}

# Jenis Tempat Tinggal
cat("VERIFIKASI JENIS TEMPAT TINGGAL:\n")
cat("--------------------------------\n")

cols_tinggal <- names(data_ubl)[grepl("jenis.*tempat.*tinggal", names(data_ubl), ignore.case = TRUE)]

if (length(cols_tinggal) > 0) {
    col_name <- cols_tinggal[1]
    cat("✅ Kolom ditemukan:", col_name, "\n")
    cat("   Tipe data:", class(data_ubl[[col_name]]), "\n")
    cat("   Sample 10 nilai:\n")
    for (i in 1:min(10, nrow(data_ubl))) {
        cat("     ", i, ":", data_ubl[[col_name]][i], "\n")
    }

    # Frekuensi
    cat("\n   FREKUENSI (Top 15):\n")
    freq <- table(data_ubl[[col_name]], useNA = "ifany")
    freq_df <- as.data.frame(freq)
    names(freq_df) <- c("Nilai", "Frekuensi")
    freq_df <- freq_df[order(-freq_df$Frekuensi), ]

    for (i in 1:min(15, nrow(freq_df))) {
        cat(sprintf("   %2d. %-50s : %3d\n", i, freq_df$Nilai[i], freq_df$Frekuensi[i]))
    }
    cat("\n   Total kategori unik:", nrow(freq_df), "\n")
} else {
    cat("❌ Kolom jenis.tempat.tinggal tidak ditemukan\n")
}

cat("\n✅ VERIFIKASI SELESAI\n")
