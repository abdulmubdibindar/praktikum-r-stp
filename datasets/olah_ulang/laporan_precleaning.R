# Script untuk Laporan Pre-Cleaning
# Menganalisis variabel yang perlu dilaporkan sebelum cleaning

library(dplyr)

cat("===========================================\n")
cat("LAPORAN PRE-CLEANING UNTUK VERIFIKASI USER\n")
cat("===========================================\n\n")

# Baca semua dataset
datasets <- list(
    ITERA = read.csv("datasets/olah_ulang/DataUtama_mhsITERA.csv", sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8"),
    UNILA = read.csv("datasets/olah_ulang/DataUtama_mhsUNILA.csv", sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8"),
    UBL = read.csv("datasets/olah_ulang/DataUtama_mhsUBL.csv", sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8"),
    UINRIL = read.csv("datasets/olah_ulang/DataUtama_mhsUINRIL.csv", sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8")
)

# ===================================================================
# LAPORAN 1: VERIFIKASI FAKULTAS DAN PRODI (encoded atau text?)
# ===================================================================

cat("LAPORAN 1: VERIFIKASI TIPE DATA FAKULTAS DAN PRODI\n")
cat("===================================================\n\n")

for (nama in names(datasets)) {
    data <- datasets[[nama]]
    cat("Dataset:", nama, "\n")
    cat("-------------------\n")

    # Fakultas
    cat("FAKULTAS:\n")
    cat("  Tipe data:", class(data$Fakultas), "\n")
    cat("  Sample 5 nilai pertama:\n")
    for (i in 1:min(5, nrow(data))) {
        cat("    [", i, "]", data$Fakultas[i], "\n")
    }
    cat("  Unique values (total):", length(unique(data$Fakultas)), "\n\n")

    # Prodi
    cat("PRODI:\n")
    cat("  Tipe data:", class(data$Prodi), "\n")
    cat("  Sample 5 nilai pertama:\n")
    for (i in 1:min(5, nrow(data))) {
        cat("    [", i, "]", data$Prodi[i], "\n")
    }
    cat("  Unique values (total):", length(unique(data$Prodi)), "\n\n")
    cat("\n")
}

# ===================================================================
# LAPORAN 2: NILAI KATEGORIS JENIS TEMPAT TINGGAL
# ===================================================================

cat("\n\n")
cat("LAPORAN 2: NILAI KATEGORIS JENIS TEMPAT TINGGAL\n")
cat("================================================\n\n")

jenistinggal_all <- list()

for (nama in names(datasets)) {
    data <- datasets[[nama]]

    # Cari nama kolom yang sesuai
    col_names <- names(data)
    col_jenis_tinggal <- col_names[grepl("jenis.*tempat.*tinggal", col_names, ignore.case = TRUE)]

    if (length(col_jenis_tinggal) > 0) {
        col_name <- col_jenis_tinggal[1]
        cat("Dataset:", nama, "(kolom:", col_name, ")\n")
        cat("-------------------\n")

        freq <- table(data[[col_name]], useNA = "ifany")
        freq_df <- as.data.frame(freq)
        names(freq_df) <- c("Nilai", "Frekuensi")
        freq_df <- freq_df[order(-freq_df$Frekuensi), ]

        for (i in 1:nrow(freq_df)) {
            cat(sprintf("  %2d. %-50s : %3d\n", i, freq_df$Nilai[i], freq_df$Frekuensi[i]))
        }

        jenistinggal_all[[nama]] <- unique(data[[col_name]])
        cat("\n")
    }
}

# Gabungan semua nilai unik
cat("\nSEMUA NILAI UNIK DARI KEEMPAT DATASET:\n")
cat("---------------------------------------\n")
all_values <- unique(unlist(jenistinggal_all))
all_values <- sort(all_values)
for (i in 1:length(all_values)) {
    cat(sprintf("%2d. %s\n", i, all_values[i]))
}

# ===================================================================
# LAPORAN 3: MISSING VALUES DETAIL
# ===================================================================

cat("\n\n")
cat("LAPORAN 3: MISSING VALUES DETAIL\n")
cat("=================================\n\n")

for (nama in names(datasets)) {
    data <- datasets[[nama]]
    cat("Dataset:", nama, "(", nrow(data), "observasi )\n")
    cat("-------------------\n")

    # Cek missing per kolom
    has_missing <- FALSE

    for (col in names(data)) {
        n_missing <- sum(is.na(data[[col]]) | data[[col]] == "" | data[[col]] == " ")

        if (n_missing > 0) {
            has_missing <- TRUE
            pct <- round(n_missing / nrow(data) * 100, 2)
            cat(sprintf("  %-40s : %3d missing (%5.2f%%)\n", col, n_missing, pct))
        }
    }

    if (!has_missing) {
        cat("  ✓ Tidak ada missing values\n")
    }

    cat("\n")
}

# ===================================================================
# LAPORAN 4: MISSING DI JUMLAH PERJALANAN PER HARI (detail)
# ===================================================================

cat("\n\n")
cat("LAPORAN 4: MISSING DI JUMLAH PERJALANAN PER HARI\n")
cat("=================================================\n\n")

for (nama in names(datasets)) {
    data <- datasets[[nama]]
    cat("Dataset:", nama, "\n")
    cat("-------------------\n")

    # Cari kolom jumlah perjalanan
    cols_perjalanan <- names(data)[grepl("jumlah.*perjalanan", names(data), ignore.case = TRUE)]

    if (length(cols_perjalanan) > 0) {
        cat("Kolom yang ditemukan:", length(cols_perjalanan), "\n")
        for (col in cols_perjalanan) {
            cat("  -", col, "\n")
        }
        cat("\n")

        # Cek missing per kolom
        for (col in cols_perjalanan) {
            n_missing <- sum(is.na(data[[col]]) | data[[col]] == "" | data[[col]] == " ")
            if (n_missing > 0) {
                cat("  Missing di", col, ":", n_missing, "\n")
            }
        }

        # Cek observasi yang missing di SEMUA kolom perjalanan
        missing_all <- rep(TRUE, nrow(data))
        for (col in cols_perjalanan) {
            missing_all <- missing_all & (is.na(data[[col]]) | data[[col]] == "" | data[[col]] == " ")
        }
        n_missing_all <- sum(missing_all)

        cat("\n  Observasi yang missing di SEMUA variabel perjalanan:", n_missing_all, "\n")

        if (n_missing_all > 0) {
            cat("  Index observasi yang akan di-drop:\n")
            idx <- which(missing_all)
            for (i in idx) {
                cat("    - Baris", i, "\n")
            }
        }
    } else {
        cat("  Tidak ada kolom jumlah perjalanan ditemukan\n")
    }

    cat("\n")
}

cat("\n=== LAPORAN SELESAI ===\n")
