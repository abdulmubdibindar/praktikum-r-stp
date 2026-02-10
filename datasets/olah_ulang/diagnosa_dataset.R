# Script Diagnosa Dataset
# Menganalisis struktur data dari keempat file CSV

# Fungsi untuk menganalisis dataset
analyze_dataset <- function(file_path, dataset_name) {
    cat("\n========================================\n")
    cat("DATASET:", dataset_name, "\n")
    cat("========================================\n\n")

    # Baca data menggunakan delimiter semicolon
    data <- read.csv(file_path, sep = ";", stringsAsFactors = FALSE, encoding = "UTF-8")

    # Informasi umum
    cat("Jumlah Baris:", nrow(data), "\n")
    cat("Jumlah Variabel:", ncol(data), "\n\n")

    # Analisis per variabel
    cat("DETAIL VARIABEL:\n")
    cat("----------------\n\n")

    for (i in 1:ncol(data)) {
        var_name <- names(data)[i]
        var_data <- data[[i]]

        cat(i, ". Variabel:", var_name, "\n")

        # Tipe data
        cat("   - Tipe Data:", class(var_data)[1], "\n")

        # Missing values
        n_missing <- sum(is.na(var_data) | var_data == "" | var_data == " ")
        cat("   - Missing Values:", n_missing, "(", round(n_missing / nrow(data) * 100, 2), "% )\n")

        # Unique values
        n_unique <- length(unique(var_data[!is.na(var_data) & var_data != "" & var_data != " "]))
        cat("   - Unique Values:", n_unique, "\n")

        # Cek apakah nominal/categorical
        if (n_unique <= 20 || is.character(var_data)) {
            cat("   - Kategori/Nilai Unik:\n")
            freq_table <- table(var_data, useNA = "ifany")
            freq_df <- as.data.frame(freq_table)
            names(freq_df) <- c("Nilai", "Frekuensi")

            for (j in 1:min(nrow(freq_df), 20)) {
                cat("     *", freq_df$Nilai[j], ":", freq_df$Frekuensi[j], "\n")
            }

            if (nrow(freq_df) > 20) {
                cat("     ... dan", nrow(freq_df) - 20, "kategori lainnya\n")
            }
        } else {
            # Untuk numerik
            numeric_data <- suppressWarnings(as.numeric(var_data))
            if (sum(!is.na(numeric_data)) > 0) {
                cat("   - Min:", min(numeric_data, na.rm = TRUE), "\n")
                cat("   - Max:", max(numeric_data, na.rm = TRUE), "\n")
                cat("   - Mean:", round(mean(numeric_data, na.rm = TRUE), 2), "\n")
                cat("   - Median:", median(numeric_data, na.rm = TRUE), "\n")
            }
        }

        cat("\n")
    }

    return(names(data))
}

# Path ke datasets
datasets <- list(
    ITERA = "datasets/olah_ulang/DataUtama_mhsITERA.csv",
    UNILA = "datasets/olah_ulang/DataUtama_mhsUNILA.csv",
    UBL = "datasets/olah_ulang/DataUtama_mhsUBL.csv",
    UINRIL = "datasets/olah_ulang/DataUtama_mhsUINRIL.csv"
)

# Analisis setiap dataset dan simpan nama variabel
all_vars <- list()
for (name in names(datasets)) {
    if (file.exists(datasets[[name]])) {
        all_vars[[name]] <- analyze_dataset(datasets[[name]], name)
    } else {
        cat("File tidak ditemukan:", datasets[[name]], "\n")
    }
}

# Analisis variabel yang sama
cat("\n========================================\n")
cat("VARIABEL YANG TERMUAT DI SEMUA DATASET\n")
cat("========================================\n\n")

common_vars <- Reduce(intersect, all_vars)
cat("Variabel yang ada di KEEMPAT dataset:\n")
for (var in common_vars) {
    cat(" -", var, "\n")
}

cat("\n\nVARIABEL YANG TERMUAT DI BEBERAPA DATASET:\n")
cat("-------------------------------------------\n\n")

all_unique_vars <- unique(unlist(all_vars))
for (var in all_unique_vars) {
    datasets_with_var <- names(all_vars)[sapply(all_vars, function(x) var %in% x)]
    if (length(datasets_with_var) > 1 && length(datasets_with_var) < 4) {
        cat(var, ":", paste(datasets_with_var, collapse = ", "), "\n")
    }
}
