# Analisis kolom biaya.dalam.seminggu dari UBL
data_ubl <- read.csv("datasets/olah_ulang/DataUtama_mhsUBL.csv", sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8")

# Analisis kolom biaya.dalam.seminggu
cat("ANALISIS KOLOM: biaya.dalam.seminggu\n")
cat("=====================================\n\n")

# Tipe data
cat("Tipe Data:", class(data_ubl$biaya.dalam.seminggu), "\n\n")

# Nilai unik dan frekuensinya
cat("NILAI UNIK DAN FREKUENSI:\n")
cat("-------------------------\n")
freq_table <- table(data_ubl$biaya.dalam.seminggu, useNA = "ifany")
freq_df <- as.data.frame(freq_table)
names(freq_df) <- c("Nilai", "Frekuensi")
freq_df <- freq_df[order(-freq_df$Frekuensi), ]

for (i in 1:nrow(freq_df)) {
    cat(sprintf("%3d. %-20s : %3d responden\n", i, freq_df$Nilai[i], freq_df$Frekuensi[i]))
}

cat("\n\nTOTAL NILAI UNIK:", nrow(freq_df), "\n")
cat("TOTAL OBSERVASI:", nrow(data_ubl), "\n")

# Analisis pola nilai
cat("\n\nANALISIS POLA NILAI:\n")
cat("--------------------\n")

# Cek nilai yang mengandung koma
nilai_koma <- grep(",", freq_df$Nilai, value = TRUE)
cat("Nilai dengan koma desimal:", length(nilai_koma), "nilai\n")

# Cek nilai yang hanya angka
nilai_angka <- grep("^[0-9]+$", freq_df$Nilai, value = TRUE)
cat("Nilai yang hanya angka bulat:", length(nilai_angka), "nilai\n")

# Cek nilai yang mengandung teks/karakter lain
nilai_teks <- freq_df$Nilai[!freq_df$Nilai %in% c(nilai_koma, nilai_angka)]
if (length(nilai_teks) > 0) {
    cat("\nNilai yang mengandung teks/karakter khusus:\n")
    for (v in nilai_teks) {
        cat("  -", v, "\n")
    }
}

# Konversi ke numerik dan lihat statistik
cat("\n\nSTATISTIK SETELAH KONVERSI KE NUMERIK:\n")
cat("---------------------------------------\n")
nilai_numeric <- as.numeric(gsub(",", ".", data_ubl$biaya.dalam.seminggu))
cat("Missing values setelah konversi:", sum(is.na(nilai_numeric)), "\n")
cat("Min:", min(nilai_numeric, na.rm = TRUE), "\n")
cat("Q1 (25%):", quantile(nilai_numeric, 0.25, na.rm = TRUE), "\n")
cat("Median:", median(nilai_numeric, na.rm = TRUE), "\n")
cat("Mean:", round(mean(nilai_numeric, na.rm = TRUE), 2), "\n")
cat("Q3 (75%):", quantile(nilai_numeric, 0.75, na.rm = TRUE), "\n")
cat("Max:", max(nilai_numeric, na.rm = TRUE), "\n")
