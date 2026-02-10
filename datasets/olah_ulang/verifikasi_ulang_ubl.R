# Script Verifikasi Ulang SEMUA Variabel Dataset UBL
# Setelah fix dengan delimiter semicolon yang benar

library(readr)
library(dplyr)

cat("==================================================\n")
cat("VERIFIKASI ULANG DATASET UBL (POST-FIX)\n")
cat("==================================================\n\n")

# Baca dengan delimiter SEMICOLON
data_ubl <- read_delim("datasets/olah_ulang/DataUtama_mhsUBL.csv",
    delim = ";",
    locale = locale(encoding = "UTF-8"),
    col_types = cols(.default = col_character()),
    trim_ws = TRUE
)

cat("DATASET INFO:\n")
cat("-------------\n")
cat("Jumlah baris:", nrow(data_ubl), "\n")
cat("Jumlah variabel:", ncol(data_ubl), "\n\n")

cat("NAMA KOLOM:\n")
for (i in 1:length(names(data_ubl))) {
    cat(sprintf("%2d. %s\n", i, names(data_ubl)[i]))
}

cat("\n\n")
cat("==================================================\n")
cat("1️⃣ VERIFIKASI: FAKULTAS DAN PRODI\n")
cat("==================================================\n\n")

if ("Fakultas" %in% names(data_ubl)) {
    cat("✅ Kolom FAKULTAS ditemukan!\n")
    cat("   Tipe data: character\n")
    cat("   Unique values:", length(unique(data_ubl$Fakultas)), "\n")
    cat("   Sample 5 nilai:\n")
    for (i in 1:min(5, nrow(data_ubl))) {
        cat("     ", i, ":", data_ubl$Fakultas[i], "\n")
    }

    cat("\n   Semua unique values:\n")
    unique_fak <- sort(unique(data_ubl$Fakultas))
    for (i in 1:length(unique_fak)) {
        cat("     ", i, ":", unique_fak[i], "\n")
    }
} else {
    cat("❌ Kolom FAKULTAS tidak ditemukan\n")
}

cat("\n")

if ("Prodi" %in% names(data_ubl)) {
    cat("✅ Kolom PRODI ditemukan!\n")
    cat("   Tipe data: character\n")
    cat("   Unique values:", length(unique(data_ubl$Prodi)), "\n")
    cat("   Sample 5 nilai:\n")
    for (i in 1:min(5, nrow(data_ubl))) {
        cat("     ", i, ":", data_ubl$Prodi[i], "\n")
    }

    cat("\n   Semua unique values:\n")
    unique_prodi <- sort(unique(data_ubl$Prodi))
    for (i in 1:length(unique_prodi)) {
        cat("     ", i, ":", unique_prodi[i], "\n")
    }
} else {
    cat("❌ Kolom PRODI tidak ditemukan\n")
}

cat("\n\n")
cat("==================================================\n")
cat("2️⃣ VERIFIKASI: JENIS TEMPAT TINGGAL\n")
cat("==================================================\n\n")

cols_tinggal <- names(data_ubl)[grepl("jenis.*tempat.*tinggal", names(data_ubl), ignore.case = TRUE)]

if (length(cols_tinggal) > 0) {
    col_name <- cols_tinggal[1]
    cat("✅ Kolom ditemukan:", col_name, "\n")
    cat("   Sample 10 nilai:\n")
    for (i in 1:min(10, nrow(data_ubl))) {
        cat(sprintf("     %2d: %s\n", i, data_ubl[[col_name]][i]))
    }

    # Frekuensi
    cat("\n   FREKUENSI NILAI (Semua kategori):\n")
    freq <- table(data_ubl[[col_name]], useNA = "ifany")
    freq_df <- as.data.frame(freq)
    names(freq_df) <- c("Nilai", "Frekuensi")
    freq_df <- freq_df[order(-freq_df$Frekuensi), ]

    for (i in 1:nrow(freq_df)) {
        cat(sprintf("   %2d. %-50s : %3d\n", i, freq_df$Nilai[i], freq_df$Frekuensi[i]))
    }

    cat("\n   Total kategori unik:", nrow(freq_df), "\n")

    # Cek apakah ada nilai encoded (pure numbers)
    nilai_numeric <- data_ubl[[col_name]][!is.na(data_ubl[[col_name]])]
    nilai_numeric <- nilai_numeric[grepl("^[0-9]+$", nilai_numeric)]

    if (length(nilai_numeric) > 0) {
        cat("\n   ⚠️ Ditemukan", length(nilai_numeric), "nilai ENCODED (pure angka):\n")
        freq_num <- table(nilai_numeric)
        for (i in 1:length(freq_num)) {
            cat(sprintf('      Angka "%s": %d observasi\n', names(freq_num)[i], freq_num[i]))
        }
    } else {
        cat("\n   ✅ Tidak ada nilai encoded - semua text kategoris\n")
    }
} else {
    cat("❌ Kolom jenis.tempat.tinggal tidak ditemukan\n")
}

cat("\n\n")
cat("==================================================\n")
cat("3️⃣ VERIFIKASI: MISSING VALUES\n")
cat("==================================================\n\n")

missing_summary <- data.frame(
    Variabel = character(),
    Missing_Count = integer(),
    Missing_Pct = numeric(),
    stringsAsFactors = FALSE
)

for (i in 1:ncol(data_ubl)) {
    missing_count <- sum(is.na(data_ubl[[i]]) | data_ubl[[i]] == "" | data_ubl[[i]] == " ")

    if (missing_count > 0) {
        missing_pct <- round(missing_count / nrow(data_ubl) * 100, 2)
        missing_summary <- rbind(
            missing_summary,
            data.frame(
                Variabel = names(data_ubl)[i],
                Missing_Count = missing_count,
                Missing_Pct = missing_pct
            )
        )
    }
}

if (nrow(missing_summary) > 0) {
    cat("Variabel dengan missing values:\n\n")
    for (i in 1:nrow(missing_summary)) {
        cat(sprintf(
            "%2d. %-40s : %3d (%5.2f%%)\n",
            i,
            missing_summary$Variabel[i],
            missing_summary$Missing_Count[i],
            missing_summary$Missing_Pct[i]
        ))
    }
} else {
    cat("✅ Tidak ada missing values di semua variabel!\n")
}

cat("\n\n")
cat("==================================================\n")
cat("4️⃣ VERIFIKASI: BIAYA.DALAM.RIBU2 (Hasil Konversi)\n")
cat("==================================================\n\n")

if ("biaya.dalam.ribu2" %in% names(data_ubl)) {
    cat("✅ Kolom biaya.dalam.ribu2 ditemukan!\n")

    biaya_numeric <- as.numeric(data_ubl$biaya.dalam.ribu2)

    cat("   Summary statistik:\n")
    cat("   - Min:", min(biaya_numeric, na.rm = TRUE), "\n")
    cat("   - Max:", max(biaya_numeric, na.rm = TRUE), "\n")
    cat("   - Mean:", round(mean(biaya_numeric, na.rm = TRUE), 2), "\n")
    cat("   - Median:", median(biaya_numeric, na.rm = TRUE), "\n")
    cat("   - Missing (NA):", sum(is.na(biaya_numeric)), "\n")
    cat("   - Non-missing:", sum(!is.na(biaya_numeric)), "\n")
} else {
    cat("❌ Kolom biaya.dalam.ribu2 tidak ditemukan\n")
}

cat("\n\n✅ VERIFIKASI SELESAI\n")
