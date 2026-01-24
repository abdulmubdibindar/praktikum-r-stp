# Script untuk membersihkan dataset UBL
# Mengikuti metodologi dari 02-statistik-deskriptif.Rmd

library(tidyverse)

cat("=== Membersihkan Dataset UBL ===\n\n")

# 1. Backup file asli dan import dataset
cat("1. Membackup file asli dan mengimpor dataset...\n")
original_file <- "datasets/DataUtama_mhsUBL.csv"
backup_file <- "datasets/_DataUtama_mhsUBL.csv"

# Backup file asli  jika belum ada backup
if (!file.exists(backup_file)) {
    file.copy(original_file, backup_file)
    cat("   File asli dibackup ke:", backup_file, "\n")
}

data.ubl <- read.csv(backup_file, sep = ";", stringsAsFactors = FALSE)
cat("   Dimensi awal:", nrow(data.ubl), "baris x", ncol(data.ubl), "kolom\n")

# 2. Cek missing values sebelum pembersihan
cat("\n2. Mengecek missing values...\n")
mv_before <- colSums(is.na(data.ubl))
total_mv_before <- sum(mv_before)
cat("   Total missing values:", total_mv_before, "\n")
if (total_mv_before > 0) {
    cat("   Distribusi missing values per kolom:\n")
    print(mv_before[mv_before > 0])
}

# 3. Rename variabel
cat("\n3. Mengganti nama variabel...\n")
data.ubl <- data.ubl |>
    rename(
        Nomor.urut = `Nomor.urut`,
        Jenis.Kelamin = `Jenis.Kelamin`,
        Umur = `Umur`,
        Fakultas = `Fakultas`,
        Prodi = `Prodi`,
        Tingkat.Semester = `Tingkat.Semester`,
        Uang.Saku = `Uang.Saku`,
        kepemilikan.mobil = `kepemilikan.mobil`,
        kepemilikan.motor = `kepemilikan.motor`,
        kepemilikan.sepeda = `kepemilikan.sepeda`,
        kendaraan.utama = `kendaraan.utama`,
        kelurahan = `kelurahan`,
        jenis.tempat.tinggal = `jenis.tempat.tinggal`,
        nama.jalan.tempat.tinggal = `nama.jalan.tempat.tinggal`,
        jarak = `jarak..km.`,
        alasan.pemilihan.lokasi.tempat.tinggal = `alasan.pemilihan.lokasi.tempat.tinggal`,
        biaya.dalam.sepekan = `biaya.dalam.seminggu`, # Rename dari seminggu ke sepekan
        Jumlah.Perjalanan.Senin = `Jumlah.perjalanan.Senin`,
        Jumlah.Perjalanan.Selasa = `Jumlah.Perjalanan.Selasa`,
        Jumlah.Perjalanan.Rabu = `Jumlah.Perjalanan.Rabu`,
        Jumlah.Perjalanan.Kamis = `Jumlah.Perjalanan.Kamis`,
        Jumlah.Perjalanan.Jumat = `Jumlah.Perjalanan.Jumat`,
        Jumlah.Perjalanan.Sabtu = `Jumlah.Perjalanan.Sabtu`,
        Jumlah.Perjalanan.Ahad = `Jumlah.Perjalanan.Ahad`
    )
cat("   Nama variabel berhasil diseragamkan\n")

# 4. Fungsi untuk menghitung modus (nilai terbanyak)
get_mode <- function(x) {
    x_clean <- x[!is.na(x)]
    if (length(x_clean) == 0) {
        return(NA)
    }
    ux <- unique(x_clean)
    ux[which.max(tabulate(match(x_clean, ux)))]
}

# 5. Imputasi missing values
cat("\n4. Melakukan imputasi missing values...\n")

# Identifikasi kolom numerik dan kategoris
numeric_cols <- c(
    "Umur", "kepemilikan.mobil", "kepemilikan.motor", "kepemilikan.sepeda",
    "jarak", "biaya.dalam.sepekan",
    "Jumlah.Perjalanan.Senin", "Jumlah.Perjalanan.Selasa",
    "Jumlah.Perjalanan.Rabu", "Jumlah.Perjalanan.Kamis",
    "Jumlah.Perjalanan.Jumat", "Jumlah.Perjalanan.Sabtu",
    "Jumlah.Perjalanan.Ahad"
)

categorical_cols <- c(
    "Jenis.Kelamin", "Fakultas", "Prodi", "Tingkat.Semester",
    "Uang.Saku", "kendaraan.utama", "kelurahan",
    "jenis.tempat.tinggal", "nama.jalan.tempat.tinggal",
    "alasan.pemilihan.lokasi.tempat.tinggal"
)

# Imputasi untuk variabel numerik dengan mean
for (col in numeric_cols) {
    if (col %in% colnames(data.ubl)) {
        na_count <- sum(is.na(data.ubl[[col]]))
        if (na_count > 0) {
            mean_val <- mean(data.ubl[[col]], na.rm = TRUE)
            data.ubl[[col]][is.na(data.ubl[[col]])] <- mean_val
            cat("   -", col, ": imputasi", na_count, "NA dengan mean =", round(mean_val, 2), "\n")
        }
    }
}

# Imputasi untuk variabel kategoris dengan modus
for (col in categorical_cols) {
    if (col %in% colnames(data.ubl)) {
        na_count <- sum(is.na(data.ubl[[col]]) | data.ubl[[col]] == "")
        if (na_count > 0) {
            mode_val <- get_mode(data.ubl[[col]][data.ubl[[col]] != ""])
            data.ubl[[col]][is.na(data.ubl[[col]]) | data.ubl[[col]] == ""] <- mode_val
            cat("   -", col, ": imputasi", na_count, "NA dengan modus =", mode_val, "\n")
        }
    }
}

# 6. Konversi variabel kategoris ke factor
cat("\n5. Mengkonversi variabel kategoris ke factor...\n")

# Membuat vektor nilai-nilai kategoris
jk <- sort(unique(data.ubl$Jenis.Kelamin))
fakultas <- sort(unique(data.ubl$Fakultas))
prodi <- sort(unique(data.ubl$Prodi))

# Variabel ordinal (sesuai urutan tingkatan)
tingkat <- c(
    "1 (Semester 1 s.d. Semester 2)",
    "2 (Semester 3 s.d. Semester 4)",
    "3 (Semester 5 s.d. Semester 6)",
    "4 (Semester 7 s.d. Semester 8)"
)

uang_saku <- c(
    "< 1 jt", "1 jt s.d. 2 jt", "2,1 jt s.d. 3 jt",
    "3,1 jt s.d. 4 jt", "> 4 jt"
)

# Konversi ke factor
data.ubl <- data.ubl |>
    mutate(
        # Normalisasi simbol separator agar sesuai dengan levels
        Tingkat.Semester = str_replace_all(Tingkat.Semester, " [-–] ", " s.d. "),
        Uang.Saku = str_replace_all(Uang.Saku, " [-–] ", " s.d. "),

        Jenis.Kelamin = factor(Jenis.Kelamin, levels = jk),
        Fakultas = factor(Fakultas, levels = fakultas),
        Prodi = factor(Prodi, levels = prodi),
        Tingkat.Semester = factor(Tingkat.Semester, levels = tingkat, ordered = TRUE),
        Uang.Saku = factor(Uang.Saku, levels = uang_saku, ordered = TRUE),
        jenis.tempat.tinggal = factor(jenis.tempat.tinggal),
        kendaraan.utama = factor(kendaraan.utama)
    )

cat("   Variabel kategoris berhasil dikonversi ke factor\n")

# 7. Verifikasi hasil
cat("\n6. Verifikasi hasil pembersihan...\n")
mv_after <- sum(is.na(data.ubl))
cat("   Total missing values setelah imputasi:", mv_after, "\n")
cat("   Dimensi akhir:", nrow(data.ubl), "baris x", ncol(data.ubl), "kolom\n")

# 8. Simpan hasil (menggantikan file asli)
cat("\n7. Menyimpan hasil ke CSV...\n")
write.csv(data.ubl, "datasets/DataUtama_mhsUBL.csv", row.names = FALSE)
cat("   File tersimpan: datasets/DataUtama_mhsUBL.csv\n")
cat("   File asli dibackup di: datasets/_DataUtama_mhsUBL.csv\n")

cat("\n=== Pembersihan Dataset UBL Selesai ===\n")
