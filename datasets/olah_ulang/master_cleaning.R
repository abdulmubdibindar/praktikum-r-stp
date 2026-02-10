# =============================================================================
# MASTER DATA CLEANING SCRIPT
# =============================================================================
# Script untuk membersihkan dan standardisasi 4 dataset:
# - ITERA, UNILA, UBL, UINRIL
#
# Berdasarkan: cleaning_protocol.md
# Tanggal: 10 Februari 2026
# =============================================================================

library(readr)
library(dplyr)

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

# Function: Rename variabel ke lowercase dengan dot separator
rename_variables <- function(data, dataset_name) {
    cat("  → Renaming variables to lowercase...\n")

    # Mapping nama variabel berdasarkan cleaning protocol
    rename_map <- c(
        "Timestamp" = "timestamp",
        "Kampus_PT" = "kampus",
        "Nomor urut" = "nomor.urut",
        "Nomor.urut" = "nomor.urut",
        "Jenis Kelamin" = "jenis.kelamin",
        "Jenis.Kelamin" = "jenis.kelamin",
        "Umur" = "usia",
        "Fakultas" = "fakultas",
        "Prodi" = "prodi",
        "Tingkat Semester" = "tingkat.semester",
        "Tingkat.Semester" = "tingkat.semester",
        "Uang Saku" = "uang.saku",
        "Uang.Saku" = "uang.saku",
        "kepemilikan mobil" = "jumlah.mobil",
        "kepemilikan.mobil" = "jumlah.mobil",
        "Jumlah.motor" = "jumlah.motor",
        "kepemilikan motor" = "jumlah.motor",
        "kepemilikan.motor" = "jumlah.motor",
        "kepemilikan sepeda" = "jumlah.sepeda",
        "kepemilikan.sepeda" = "jumlah.sepeda",
        "kendaraan utama" = "kendaraan.utama",
        "kendaraan.utama" = "kendaraan.utama",
        "kelurahan" = "kelurahan",
        "jenis tempat tinggal" = "jenis.tempat.tinggal",
        "jenis.tempat.tinggal" = "jenis.tempat.tinggal",
        "nama jalan tempat tinggal" = "alamat",
        "nama.jalan.tempat.tinggal" = "alamat",
        "jarak (km)" = "jarak.km",
        "jarak..km." = "jarak.km",
        "alasan pemilihan lokasi tempat tinggal" = "alasan.lokasi",
        "alasan.pemilihan.lokasi.tempat.tinggal" = "alasan.lokasi",
        "biaya dalam seminggu" = "biaya.dalam.seminggu.raw",
        "biaya.dalam.seminggu" = "biaya.dalam.seminggu.raw",
        "biaya.dalam.ribu" = "biaya.dalam.ribu",
        "biaya.dalam.ribu2" = "biaya.dalam.ribu",
        "Jumlah perjalanan Senin" = "jumlah.perjalanan.senin",
        "Jumlah.perjalanan.Senin" = "jumlah.perjalanan.senin",
        "Jumlah.Perjalanan.Senin" = "jumlah.perjalanan.senin",
        "Jumlah Perjalanan Selasa" = "jumlah.perjalanan.selasa",
        "Jumlah.Perjalanan.Selasa" = "jumlah.perjalanan.selasa",
        "Jumlah Perjalanan Rabu" = "jumlah.perjalanan.rabu",
        "Jumlah.Perjalanan.Rabu" = "jumlah.perjalanan.rabu",
        "Jumlah Perjalanan Kamis" = "jumlah.perjalanan.kamis",
        "Jumlah.Perjalanan.Kamis" = "jumlah.perjalanan.kamis",
        "Jumlah Perjalanan Jumat" = "jumlah.perjalanan.jumat",
        "Jumlah.Perjalanan.Jumat" = "jumlah.perjalanan.jumat",
        "Jumlah Perjalanan Sabtu" = "jumlah.perjalanan.sabtu",
        "Jumlah.Perjalanan.Sabtu" = "jumlah.perjalanan.sabtu",
        "Jumlah Perjalanan Ahad" = "jumlah.perjalanan.minggu",
        "Jumlah.Perjalanan.Ahad" = "jumlah.perjalanan.minggu",
        "Jumlah Perjalanan Minggu" = "jumlah.perjalanan.minggu",
        "Jumlah.Perjalanan.Minggu" = "jumlah.perjalanan.minggu"
    )

    # Apply renaming
    old_names <- names(data)
    new_names <- old_names

    for (i in 1:length(old_names)) {
        if (old_names[i] %in% names(rename_map)) {
            new_names[i] <- rename_map[old_names[i]]
        }
    }

    names(data) <- new_names

    cat("    ✓", sum(old_names != new_names), "variables renamed\n")
    return(data)
}

# Function: Convert jarak.km ke numeric
convert_jarak_km <- function(data) {
    cat("  → Converting jarak.km to numeric...\n")

    if ("jarak.km" %in% names(data)) {
        # Replace comma with period, then convert to numeric
        data$jarak.km <- gsub(",", ".", data$jarak.km)
        data$jarak.km <- as.numeric(data$jarak.km)
        cat("    ✓ jarak.km converted\n")
    } else {
        cat("    ! jarak.km not found\n")
    }

    return(data)
}

# Function: Standardize jenis.kelamin
standardize_jenis_kelamin <- function(data) {
    cat("  → Standardizing jenis.kelamin...\n")

    if ("jenis.kelamin" %in% names(data)) {
        data$jenis.kelamin <- trimws(data$jenis.kelamin)

        # Mapping
        data$jenis.kelamin <- case_when(
            data$jenis.kelamin == "1" ~ "Laki-laki",
            data$jenis.kelamin == "2" ~ "Perempuan",
            grepl("laki", data$jenis.kelamin, ignore.case = TRUE) ~ "Laki-laki",
            grepl("perempuan", data$jenis.kelamin, ignore.case = TRUE) ~ "Perempuan",
            TRUE ~ data$jenis.kelamin
        )

        # Convert to factor
        data$jenis.kelamin <- factor(data$jenis.kelamin,
            levels = c("Laki-laki", "Perempuan")
        )

        cat("    ✓ jenis.kelamin standardized\n")
    }

    return(data)
}

# Function: Standardize tingkat.semester
standardize_tingkat_semester <- function(data) {
    cat("  → Standardizing tingkat.semester...\n")

    if ("tingkat.semester" %in% names(data)) {
        # Fix potential UTF-8 encoding issues
        data$tingkat.semester <- enc2utf8(as.character(data$tingkat.semester))
        data$tingkat.semester <- iconv(data$tingkat.semester, "UTF-8", "UTF-8", sub = "")
        data$tingkat.semester <- trimws(data$tingkat.semester)

        # Mapping
        data$tingkat.semester <- case_when(
            data$tingkat.semester == "1" ~ "Semester 1 - 2",
            grepl("1.*2|semester 1|semester 2", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 1 - 2",
            data$tingkat.semester == "2" ~ "Semester 3 - 4",
            grepl("3.*4|semester 3|semester 4", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 3 - 4",
            data$tingkat.semester == "3" ~ "Semester 5 - 6",
            grepl("5.*6|semester 5|semester 6", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 5 - 6",
            data$tingkat.semester == "4" ~ "Semester 7 - 8 ke atas",
            grepl("7.*8|semester 7|semester 8|ke atas", data$tingkat.semester, ignore.case = TRUE) ~ "Semester 7 - 8 ke atas",
            TRUE ~ data$tingkat.semester
        )

        # Convert to ordered factor
        data$tingkat.semester <- factor(data$tingkat.semester,
            levels = c(
                "Semester 1 - 2",
                "Semester 3 - 4",
                "Semester 5 - 6",
                "Semester 7 - 8 ke atas"
            ),
            ordered = TRUE
        )

        cat("    ✓ tingkat.semester standardized\n")
    }

    return(data)
}

# Function: Standardize uang.saku
standardize_uang_saku <- function(data) {
    cat("  → Standardizing uang.saku...\n")

    if ("uang.saku" %in% names(data)) {
        # Fix potential UTF-8 encoding issues
        data$uang.saku <- enc2utf8(as.character(data$uang.saku))
        data$uang.saku <- iconv(data$uang.saku, "UTF-8", "UTF-8", sub = "")
        data$uang.saku <- trimws(data$uang.saku)

        # Mapping
        data$uang.saku <- case_when(
            data$uang.saku == "1" ~ "< Rp1 juta",
            grepl("< 1|<1|kurang.*1", data$uang.saku, ignore.case = TRUE) ~ "< Rp1 juta",
            data$uang.saku == "2" ~ "Rp1 juta - Rp2 juta",
            grepl("1.*2|1 jt.*2 jt", data$uang.saku, ignore.case = TRUE) ~ "Rp1 juta - Rp2 juta",
            data$uang.saku == "3" ~ "Rp2,1 juta - Rp3 juta",
            grepl("2.*3|2,1.*3", data$uang.saku, ignore.case = TRUE) ~ "Rp2,1 juta - Rp3 juta",
            data$uang.saku == "4" ~ "Rp3,1 juta - Rp4 juta",
            grepl("3.*4|3,1.*4", data$uang.saku, ignore.case = TRUE) ~ "Rp3,1 juta - Rp4 juta",
            data$uang.saku == "5" ~ "> Rp4 juta",
            grepl("> 4|>4|lebih.*4", data$uang.saku, ignore.case = TRUE) ~ "> Rp4 juta",
            TRUE ~ data$uang.saku
        )

        # Convert to ordered factor
        data$uang.saku <- factor(data$uang.saku,
            levels = c(
                "< Rp1 juta",
                "Rp1 juta - Rp2 juta",
                "Rp2,1 juta - Rp3 juta",
                "Rp3,1 juta - Rp4 juta",
                "> Rp4 juta"
            ),
            ordered = TRUE
        )

        cat("    ✓ uang.saku standardized\n")
    }

    return(data)
}

# Function: Standardize kendaraan.utama
standardize_kendaraan_utama <- function(data) {
    cat("  → Standardizing kendaraan.utama...\n")

    if ("kendaraan.utama" %in% names(data)) {
        # Fix potential UTF-8 encoding issues
        data$kendaraan.utama <- enc2utf8(as.character(data$kendaraan.utama))
        data$kendaraan.utama <- iconv(data$kendaraan.utama, "UTF-8", "UTF-8", sub = "")
        data$kendaraan.utama <- trimws(data$kendaraan.utama)

        # Mapping
        data$kendaraan.utama <- case_when(
            grepl("jalan kaki|berjalan|kaki", data$kendaraan.utama, ignore.case = TRUE) ~ "Berjalan kaki",
            grepl("sepeda motor pribadi|motor pribadi|sepeda motor", data$kendaraan.utama, ignore.case = TRUE) ~ "Sepeda motor pribadi",
            grepl("mobil pribadi|mobil", data$kendaraan.utama, ignore.case = TRUE) ~ "Mobil pribadi",
            grepl("menumpang|nebeng|teman|keluarga|kendaraan bermotor.*teman", data$kendaraan.utama, ignore.case = TRUE) ~ "Menumpang kendaraan bermotor teman/keluarga",
            grepl("daring|online|ojek online|grab|gojek", data$kendaraan.utama, ignore.case = TRUE) ~ "Transportasi daring",
            grepl("angkot|angkutan", data$kendaraan.utama, ignore.case = TRUE) ~ "Transportasi daring",
            grepl("sepeda([^m]|$)", data$kendaraan.utama, ignore.case = TRUE) ~ "Berjalan kaki",
            TRUE ~ data$kendaraan.utama
        )

        # Convert to factor
        data$kendaraan.utama <- factor(data$kendaraan.utama,
            levels = c(
                "Berjalan kaki",
                "Sepeda motor pribadi",
                "Mobil pribadi",
                "Menumpang kendaraan bermotor teman/keluarga",
                "Transportasi daring"
            )
        )

        cat("    ✓ kendaraan.utama standardized\n")
    }

    return(data)
}

# Function: Standardize jenis.tempat.tinggal
standardize_jenis_tempat_tinggal <- function(data) {
    cat("  → Standardizing jenis.tempat.tinggal...\n")

    if ("jenis.tempat.tinggal" %in% names(data)) {
        # Fix potential UTF-8 encoding issues
        data$jenis.tempat.tinggal <- enc2utf8(as.character(data$jenis.tempat.tinggal))
        data$jenis.tempat.tinggal <- iconv(data$jenis.tempat.tinggal, "UTF-8", "UTF-8", sub = "")
        data$jenis.tempat.tinggal <- trimws(data$jenis.tempat.tinggal)

        # Mapping ke 8 kategori standar
        data$jenis.tempat.tinggal <- case_when(
            grepl("^kos sendiri$|^os sendiri$", data$jenis.tempat.tinggal, ignore.case = TRUE) ~ "Kos sendiri",
            grepl("kos bersama", data$jenis.tempat.tinggal, ignore.case = TRUE) ~ "Kos bersama-sama",
            grepl("rumah pribadi|rumah keluarga", data$jenis.tempat.tinggal, ignore.case = TRUE) ~ "Rumah pribadi/rumah keluarga",
            grepl("rumah bersama saudara|bersama saudara", data$jenis.tempat.tinggal, ignore.case = TRUE) ~ "Rumah bersama saudara",
            grepl("rumah mengontrak pribadi|rumah ngontrak pribadi|mengontrak sendiri", data$jenis.tempat.tinggal, ignore.case = TRUE) ~ "Rumah mengontrak sendiri",
            grepl("rumah mengontrak bersama|rumah ngontrak bersama|mengontrak bersama", data$jenis.tempat.tinggal, ignore.case = TRUE) ~ "Rumah mengontrak bersama-sama",
            grepl("asrama", data$jenis.tempat.tinggal, ignore.case = TRUE) ~ "Asrama",
            TRUE ~ "Lainnya"
        )

        # Convert to factor
        data$jenis.tempat.tinggal <- factor(data$jenis.tempat.tinggal,
            levels = c(
                "Kos sendiri",
                "Kos bersama-sama",
                "Rumah pribadi/rumah keluarga",
                "Rumah bersama saudara",
                "Rumah mengontrak sendiri",
                "Rumah mengontrak bersama-sama",
                "Asrama",
                "Lainnya"
            )
        )

        cat("    ✓ jenis.tempat.tinggal standardized\n")
    }

    return(data)
}

# Function: Handle biaya.dalam.ribu scaling
scale_biaya_dalam_ribu <- function(data, dataset_name) {
    cat("  → Scaling biaya.dalam.ribu...\n")

    if ("biaya.dalam.ribu" %in% names(data)) {
        # Convert to numeric first
        data$biaya.dalam.ribu <- as.numeric(data$biaya.dalam.ribu)

        # For ITERA dataset, divide by 1000 if > 1000
        if (dataset_name == "ITERA") {
            mask <- !is.na(data$biaya.dalam.ribu) & data$biaya.dalam.ribu > 1000
            if (sum(mask) > 0) {
                data$biaya.dalam.ribu[mask] <- data$biaya.dalam.ribu[mask] / 1000
                cat("    ✓", sum(mask), "values scaled (divided by 1000)\n")
            }
        }

        cat("    ✓ biaya.dalam.ribu processed\n")
    }

    return(data)
}

# Function: Convert jumlah perjalanan to numeric
convert_jumlah_perjalanan <- function(data) {
    cat("  → Converting jumlah.perjalanan.* to numeric...\n")

    cols_perjalanan <- grep("jumlah\\.perjalanan\\.", names(data), value = TRUE)

    for (col in cols_perjalanan) {
        # Replace non-numeric with 0
        data[[col]] <- gsub("[^0-9]", "", data[[col]])
        data[[col]][data[[col]] == ""] <- "0"
        data[[col]] <- as.numeric(data[[col]])
    }

    cat("    ✓", length(cols_perjalanan), "perjalanan columns converted\n")
    return(data)
}

# Function: Handle missing values
handle_missing_values <- function(data, dataset_name) {
    cat("  → Handling missing values...\n")

    # 1. Imputasi median untuk jarak.km (ITERA & UNILA)
    if (dataset_name %in% c("ITERA", "UNILA") && "jarak.km" %in% names(data)) {
        median_jarak <- median(data$jarak.km, na.rm = TRUE)
        n_missing <- sum(is.na(data$jarak.km))

        if (n_missing > 0) {
            data$jarak.km[is.na(data$jarak.km)] <- median_jarak
            cat("    ✓ jarak.km:", n_missing, "missing values imputed with median =", median_jarak, "\n")
        }
    }

    # 2. Imputasi median untuk jumlah.mobil (UBL)
    if (dataset_name == "UBL" && "jumlah.mobil" %in% names(data)) {
        data$jumlah.mobil <- as.numeric(data$jumlah.mobil)
        median_mobil <- median(data$jumlah.mobil, na.rm = TRUE)
        n_missing <- sum(is.na(data$jumlah.mobil))

        if (n_missing > 0) {
            data$jumlah.mobil[is.na(data$jumlah.mobil)] <- median_mobil
            cat("    ✓ jumlah.mobil:", n_missing, "missing values imputed with median =", median_mobil, "\n")
        }
    }

    # 3. Imputasi median untuk jumlah.sepeda (UBL)
    if (dataset_name == "UBL" && "jumlah.sepeda" %in% names(data)) {
        data$jumlah.sepeda <- as.numeric(data$jumlah.sepeda)
        median_sepeda <- median(data$jumlah.sepeda, na.rm = TRUE)
        n_missing <- sum(is.na(data$jumlah.sepeda))

        if (n_missing > 0) {
            data$jumlah.sepeda[is.na(data$jumlah.sepeda)] <- median_sepeda
            cat("    ✓ jumlah.sepeda:", n_missing, "missing values imputed with median =", median_sepeda, "\n")
        }
    }

    # 4. DROP observasi dengan missing di semua jumlah perjalanan (UNILA)
    if (dataset_name == "UNILA") {
        cols_perjalanan <- grep("jumlah\\.perjalanan\\.", names(data), value = TRUE)
        if (length(cols_perjalanan) > 0) {
            all_na <- rowSums(is.na(data[cols_perjalanan])) == length(cols_perjalanan)
            n_drop <- sum(all_na)

            if (n_drop > 0) {
                data <- data[!all_na, ]
                cat("    ✓", n_drop, "observations dropped (all jumlah.perjalanan missing)\n")
            }
        }
    }

    # 5. DROP observasi dengan biaya.dalam.ribu = NA (UBL)
    if (dataset_name == "UBL" && "biaya.dalam.ribu" %in% names(data)) {
        n_drop <- sum(is.na(data$biaya.dalam.ribu))

        if (n_drop > 0) {
            data <- data[!is.na(data$biaya.dalam.ribu), ]
            cat("    ✓", n_drop, "observations dropped (biaya.dalam.ribu = NA)\n")
        }
    }

    return(data)
}

# Function: Remove unwanted columns
remove_unwanted_columns <- function(data, dataset_name) {
    cat("  → Removing unwanted columns...\n")

    cols_to_remove <- c("timestamp", "biaya.dalam.seminggu.raw", "kelurahan")

    # Remove columns that exist
    cols_exist <- cols_to_remove[cols_to_remove %in% names(data)]

    if (length(cols_exist) > 0) {
        data <- data %>% select(-all_of(cols_exist))
        cat("    ✓", length(cols_exist), "columns removed:", paste(cols_exist, collapse = ", "), "\n")
    } else {
        cat("    ! No columns to remove\n")
    }

    return(data)
}

# Function: Convert numeric columns
convert_numeric_columns <- function(data) {
    cat("  → Converting numeric columns...\n")

    numeric_cols <- c(
        "usia", "jumlah.mobil", "jumlah.motor", "jumlah.sepeda",
        "jarak.km", "biaya.dalam.ribu",
        "jumlah.perjalanan.senin", "jumlah.perjalanan.selasa",
        "jumlah.perjalanan.rabu", "jumlah.perjalanan.kamis",
        "jumlah.perjalanan.jumat", "jumlah.perjalanan.sabtu",
        "jumlah.perjalanan.minggu"
    )

    for (col in numeric_cols) {
        if (col %in% names(data)) {
            data[[col]] <- as.numeric(data[[col]])
        }
    }

    cat("    ✓ Numeric columns converted\n")
    return(data)
}

# =============================================================================
# MAIN CLEANING FUNCTION
# =============================================================================

clean_dataset <- function(file_path, dataset_name, output_path) {
    cat("\n=================================================\n")
    cat("CLEANING DATASET:", dataset_name, "\n")
    cat("=================================================\n\n")

    # Read data
    cat("Step 1: Reading data...\n")
    data <- read_delim(file_path,
        delim = ";",
        locale = locale(encoding = "UTF-8"),
        col_types = cols(.default = col_character()),
        trim_ws = TRUE
    )

    cat("  ✓ Rows:", nrow(data), "\n")
    cat("  ✓ Columns:", ncol(data), "\n\n")

    # Apply cleaning steps
    cat("Step 2: Renaming variables...\n")
    data <- rename_variables(data, dataset_name)
    cat("\n")

    cat("Step 3: Converting data types...\n")
    data <- convert_jarak_km(data)
    data <- convert_jumlah_perjalanan(data)
    data <- convert_numeric_columns(data)
    cat("\n")

    cat("Step 4: Standardizing categorical variables...\n")
    data <- standardize_jenis_kelamin(data)
    data <- standardize_tingkat_semester(data)
    data <- standardize_uang_saku(data)
    data <- standardize_kendaraan_utama(data)
    data <- standardize_jenis_tempat_tinggal(data)
    cat("\n")

    cat("Step 5: Scaling biaya...\n")
    data <- scale_biaya_dalam_ribu(data, dataset_name)
    cat("\n")

    cat("Step 6: Handling missing values...\n")
    data <- handle_missing_values(data, dataset_name)
    cat("\n")

    cat("Step 7: Removing unwanted columns...\n")
    data <- remove_unwanted_columns(data, dataset_name)
    cat("\n")

    # Save cleaned data
    cat("Step 8: Saving cleaned data...\n")
    write_delim(data,
        output_path,
        delim = ";",
        na = "",
        quote = "needed",
        escape = "double",
        eol = "\n",
        col_names = TRUE
    )

    cat("  ✓ Saved to:", output_path, "\n")
    cat("  ✓ Final rows:", nrow(data), "\n")
    cat("  ✓ Final columns:", ncol(data), "\n")

    cat("\n✅ CLEANING COMPLETED FOR", dataset_name, "\n")

    return(data)
}

# =============================================================================
# EXECUTE CLEANING FOR ALL DATASETS
# =============================================================================

cat("\n")
cat("###############################################################\n")
cat("#                                                             #\n")
cat("#           MASTER DATA CLEANING SCRIPT                      #\n")
cat("#           Praktikum R - Sistem Transportasi                #\n")
cat("#                                                             #\n")
cat("###############################################################\n")
cat("\n")

# Ensure output directory exists
if (!dir.exists("datasets/olah_ulang/cleaned")) {
    dir.create("datasets/olah_ulang/cleaned")
    cat("Created output directory: datasets/olah_ulang/cleaned\n\n")
}

# Clean ITERA
data_itera <- clean_dataset(
    "datasets/olah_ulang/DataUtama_mhsITERA.csv",
    "ITERA",
    "datasets/olah_ulang/cleaned/DataUtama_mhsITERA_clean.csv"
)

# Clean UNILA
data_unila <- clean_dataset(
    "datasets/olah_ulang/DataUtama_mhsUNILA.csv",
    "UNILA",
    "datasets/olah_ulang/cleaned/DataUtama_mhsUNILA_clean.csv"
)

# Clean UBL
data_ubl <- clean_dataset(
    "datasets/olah_ulang/DataUtama_mhsUBL.csv",
    "UBL",
    "datasets/olah_ulang/cleaned/DataUtama_mhsUBL_clean.csv"
)

# Clean UINRIL
data_uinril <- clean_dataset(
    "datasets/olah_ulang/DataUtama_mhsUINRIL.csv",
    "UINRIL",
    "datasets/olah_ulang/cleaned/DataUtama_mhsUINRIL_clean.csv"
)

# =============================================================================
# GENERATE SUMMARY REPORT
# =============================================================================

cat("\n")
cat("=================================================\n")
cat("CLEANING SUMMARY\n")
cat("=================================================\n\n")

summary_df <- data.frame(
    Dataset = c("ITERA", "UNILA", "UBL", "UINRIL", "TOTAL"),
    Rows = c(
        nrow(data_itera), nrow(data_unila), nrow(data_ubl), nrow(data_uinril),
        nrow(data_itera) + nrow(data_unila) + nrow(data_ubl) + nrow(data_uinril)
    ),
    Columns = c(ncol(data_itera), ncol(data_unila), ncol(data_ubl), ncol(data_uinril), "-")
)

print(summary_df)

cat("\n✅ ALL DATASETS CLEANED SUCCESSFULLY!\n")
cat("\nCleaned files saved in: datasets/olah_ulang/cleaned/\n\n")
