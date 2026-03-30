content <- readLines("c:/Users/LENOVO/praktikum-r-stp/03-visualisasi-data.Rmd", encoding = "UTF-8")

# Data preparation chunk
content <- gsub("biaya_dalam_sepekan = biaya\\.dalam\\.seminggu", "biaya_dalam_sepekan = biaya_ribu", content)
content <- gsub("jumlah_perjalanan_senin = Jumlah\\.perjalanan\\.Senin", "jumlah_perjalanan_senin = jml_trip_senin", content)
content <- gsub("jarak = `jarak\\.\\(km\\)`", "jarak = jarak_km", content)

content <- gsub("Jenis\\.Kelamin = factor\\(Jenis\\.Kelamin", "jenis_kelamin = factor(jenis_kelamin", content)
content <- gsub("Fakultas = factor\\(Fakultas", "fakultas = factor(fakultas", content)
content <- gsub("Prodi = factor\\(Prodi", "prodi = factor(prodi", content)
content <- gsub("Tingkat\\.Semester = factor\\(Tingkat\\.Semester", "tingkat_semester = factor(tingkat_semester", content)
content <- gsub("Uang\\.Saku = factor\\(Uang\\.Saku", "uang_saku = factor(uang_saku", content)

content <- gsub("variabel Tingkat\\.Semester dan Uang\\.Saku", "variabel tingkat_semester dan uang_saku", content)
content <- gsub("Tingkat\\.Semester = fct_recode\\(Tingkat\\.Semester", "tingkat_semester = fct_recode(tingkat_semester", content)
content <- gsub("Uang\\.Saku = fct_relevel", "uang_saku = fct_relevel", content)
content <- gsub("Uang\\.Saku,", "uang_saku,", content)

content <- gsub("x = Tingkat\\.Semester", "x = tingkat_semester", content)
content <- gsub("variabel `Tingkat\\.Semester`", "variabel `tingkat_semester`", content)
content <- gsub("kategori `Tingkat\\.Semester`", "kategori `tingkat_semester`", content)
content <- gsub("fill = Uang\\.Saku", "fill = uang_saku", content)
content <- gsub("variabel `Uang\\.Saku`", "variabel `uang_saku`", content)
content <- gsub("kategori `Uang\\.Saku`", "kategori `uang_saku`", content)
content <- gsub("\\(`Uang\\.Saku`\\)", "(`uang_saku`)", content)
content <- gsub("\\(`Tingkat\\.Semester`\\)", "(`tingkat_semester`)", content)

content <- gsub("variabel `Fakultas`", "variabel `fakultas`", content)
content <- gsub("Prodi, name = \"jumlah\"", "prodi, name = \"jumlah\"", content)
content <- gsub("Prodi = fct_inorder\\(Prodi\\)", "prodi = fct_inorder(prodi)", content)
content <- gsub("x = Prodi", "x = prodi", content)
content <- gsub("variabel `Prodi`", "variabel `prodi`", content)
content <- gsub("berdasarkan `Prodi`", "berdasarkan `prodi`", content)
content <- gsub("mengubah `Prodi`", "mengubah `prodi`", content)

content <- gsub("Fakultas, name = \"jumlah\"", "fakultas, name = \"jumlah\"", content)
content <- gsub("fill = Fakultas", "fill = fakultas", content)

content <- gsub("`alasan\\.pemilihan\\.lokasi\\.tempat\\.tinggal`", "alasan_hunian", content)

content <- gsub("seperti `Umur`", "seperti `umur`", content)
content <- gsub("x = Umur", "x = umur", content)
content <- gsub("variabel numerik `Umur`", "variabel numerik `umur`", content)
content <- gsub("data `Umur`", "data `umur`", content)

content <- gsub("x = kendaraan\\.utama", "x = moda", content)
content <- gsub("fill = kendaraan\\.utama", "fill = moda", content)
content <- gsub("kategori `kendaraan\\.utama`", "kategori `moda`", content)

content <- gsub("antara `Umur`", "antara `umur`", content)

content <- gsub("y = \\\\`jarak\\.\\(km\\)\\\\`", "y = jarak", content)
content <- gsub("y = `jarak\\.\\(km\\)`", "y = jarak", content)

# Some extra cases for grammar of graphics mapping explanations
content <- sub("variabel kategori`kendaraan\\.utama`ke", "variabel kategori `moda` ke", content, fixed = TRUE)
content <- sub("variabel numerik`jarak\\.\\(km\\)`ke", "variabel numerik `jarak` ke", content, fixed = TRUE)
content <- sub("dan`kendaraan\\.utama`ke warna isian`fill`", "dan `moda` ke warna isian `fill`", content, fixed = TRUE)

content <- sub("dua variabel,`Umur`ke", "dua variabel, `umur` ke", content, fixed = TRUE)
content <- sub("dan`jarak\\.\\(km\\)` ke", "dan `jarak` ke", content, fixed = TRUE)

content <- gsub("berdasarkan `Tingkat\\.Semester`", "berdasarkan `tingkat_semester`", content)
content <- gsub("berdasarkan `kendaraan\\.utama`", "berdasarkan `moda`", content)
content <- gsub("untuk `Umur`", "untuk `umur`", content)
content <- gsub("`Jenis\\.Kelamin` vs `Umur`", "`jenis_kelamin` vs `umur`", content)

writeLines(content, "c:/Users/LENOVO/praktikum-r-stp/03-visualisasi-data.Rmd", useBytes = TRUE)
