# Script Verifikasi Dataset Hasil Cleaning
library(readr)
library(dplyr)

cat("==================================================\n")
cat("VERIFIKASI DATASET HASIL CLEANING\n")
cat("==================================================\n\n")

# Function untuk verifikasi dataset
verify_dataset <- function(file_path, dataset_name) {
    cat("\n-------------------------------------------------\n")
    cat("Dataset:", dataset_name, "\n")
    cat("-------------------------------------------------\n")

    data <- read_delim(file_path,
        delim = ";",
        locale = locale(encoding = "UTF-8"),
        col_types = cols(.default = col_guess()),
        trim_ws = TRUE
    )

    cat("✓ Rows:", nrow(data), "\n")
    cat("✓ Columns:", ncol(data), "\n\n")

    cat("Struktur Kolom:\n")
    cat("---------------\n")
    str(data, max.level = 1, list.len = 30)

    cat("\n\nFaktor Levels:\n")
    cat("-------------\n")

    # Check jenis.kelamin
    if ("jenis.kelamin" %in% names(data)) {
        cat(" jenis.kelamin:", paste(levels(data$jenis.kelamin), collapse = ", "), "\n")
        cat("   Frekuensi:", paste(table(data$jenis.kelamin), collapse = ", "), "\n")
    }

    # Check tingkat.semester
    if ("tingkat.semester" %in% names(data)) {
        cat(" tingkat.semester:", paste(levels(data$tingkat.semester), collapse = ", "), "\n")
        cat("   Frekuensi:", paste(table(data$tingkat.semester), collapse = ", "), "\n")
    }

    # Check uang.saku
    if ("uang.saku" %in% names(data)) {
        cat(" uang.saku:", paste(levels(data$uang.saku), collapse = ", "), "\n")
        cat("   Frekuensi:", paste(table(data$uang.saku), collapse = ", "), "\n")
    }

    # Check kendaraan.utama
    if ("kendaraan.utama" %in% names(data)) {
        cat(" kendaraan.utama:", paste(levels(data$kendaraan.utama), collapse = ", "), "\n")
        cat("   Frekuensi:", paste(table(data$kendaraan.utama), collapse = ", "), "\n")
    }

    # Check jenis.tempat.tinggal
    if ("jenis.tempat.tinggal" %in% names(data)) {
        cat(" jenis.tempat.tinggal:", paste(levels(data$jenis.tempat.tinggal), collapse = ", "), "\n")
        cat("   Frekuensi:", paste(table(data$jenis.tempat.tinggal), collapse = ", "), "\n")
    }

    cat("\n")

    # Check missing values
    cat("Missing Values:\n")
    cat("---------------\n")
    missing_summary <- sapply(data, function(x) sum(is.na(x)))
    missing_summary <- missing_summary[missing_summary > 0]

    if (length(missing_summary) > 0) {
        for (i in 1:length(missing_summary)) {
            cat(" ", names(missing_summary)[i], ":", missing_summary[i], "\n")
        }
    } else {
        cat(" ✓ No missing values!\n")
    }

    cat("\n")

    return(data)
}

# Verifikasi semua dataset
data_itera <- verify_dataset("datasets/olah_ulang/cleaned/DataUtama_mhsITERA_clean.csv", "ITERA")
data_unila <- verify_dataset("datasets/olah_ulang/cleaned/DataUtama_mhsUNILA_clean.csv", "UNILA")
data_ubl <- verify_dataset("datasets/olah_ulang/cleaned/DataUtama_mhsUBL_clean.csv", "UBL")
data_uinril <- verify_dataset("datasets/olah_ulang/cleaned/DataUtama_mhsUINRIL_clean.csv", "UINRIL")

cat("\n==================================================\n")
cat("RINGKASAN FINAL\n")
cat("==================================================\n\n")

summary_df <- data.frame(
    Dataset = c("ITERA", "UNILA", "UBL", "UINRIL", "TOTAL"),
    Rows = c(
        nrow(data_itera), nrow(data_unila), nrow(data_ubl), nrow(data_uinril),
        nrow(data_itera) + nrow(data_unila) + nrow(data_ubl) + nrow(data_uinril)
    ),
    Columns = c(ncol(data_itera), ncol(data_unila), ncol(data_ubl), ncol(data_uinril), "-")
)

print(summary_df)

cat("\n✅ VERIFIKASI SELESAI!\n\n")
