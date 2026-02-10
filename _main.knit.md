---
title: "Modul Praktik Statistika Untuk Perencanaan"
subtitle: "Penggunaan R dalam Pengolahan Data Kuantitatif"
site: bookdown::bookdown_site
output:
    bookdown::gitbook:
        css: style.css
        split_bib: false
    bookdown::pdf_book:
        latex_engine: xelatex
        citation_package: natbib
        keep_tex: true
        pandoc_args: ["--lua-filter=capaian.lua"]
        includes:
            in_header: preamble.tex
bibliography: referensi.bib
biblio-title: "Referensi"
link-citations: true
---



# Pengantar {.unnumbered}

Selamat datang di modul daring Praktikum Statistika untuk Perencanaan. Modul ini digunakan untuk mendampingi kalian mengikuti Praktikum dalam mata kuliah Statistika untuk Perencanaan, mata kuliah di Program Studi Perencanaan Wilayah dan Kota, Institut Teknologi Sumatera.

Modul praktikum ini akan mendampingi Anda mempelajari pengolahan statistik menggunakan bahasa pemrograman R. Untuk itu, modul ini terbagi menjadi **9 modul** yang disusun secara bertahap, dimulai dari pengenalan dasar hingga analisis multivariat:

| Modul |                   Topik                    |                                      Deskripsi Singkat                                       |
| :---: | :----------------------------------------: | :------------------------------------------------------------------------------------------: |
|   1   |        Pengolahan Data Terstruktur         | Dasar *data wrangling*: Impor, seleksi, standardisasi, penggabungan, dan ekspor data/dataset |
|   2   |           Statistika Deskriptif            |                 Perhitungan proporsi, mean, median, standar deviasi, dan IQV                 |
|   3   |              Visualisasi Data              |        Pembuatan grafik dengan `ggplot2`: bar chart, histogram, boxplot, scatter plot        |
|   4   | Distribusi Sampling & Interval Kepercayaan |                  Simulasi sampling, standard error, dan estimasi parameter                   |
|   5   |               Uji Hipotesis                |                 Uji hipotesis 1 dan 2 populasi untuk rata-rata dan proporsi                  |
|   6   |         Korelasi Nominal & Ordinal         |                            Koefisien V Cramer, Lambda, dan Gamma                             |
|   7   |              Korelasi Metrik               |                            Koefisien Spearman's ρ dan Pearson's r                            |
|   8   |               Regresi Linear               |                            Regresi linear sederhana dan berganda                             |
|   9   |         Analisis Komponen Prinsip          |                                   PCA dan Analisis Faktor                                    |

Setiap modul dilengkapi dengan **capaian pembelajaran**, **contoh kode**, dan **soal latihan** yang harus dikerjakan.

------------------------------------------------------------------------

# Pengenalan R dan RStudio {.unnumbered}

Selamat datang di dunia pengolahan data yang lebih canggih! Dalam praktikum ini, kalian akan berkenalan dengan teknik pengolahan dan analisis data dengan menggunakan bahasa pemrograman bernama R. R adalah bahasa pemrograman yang dibuat khusus untuk keperluan analisis statistik.

## Apa itu R?

R adalah lingkungan perangkat lunak (*software environment*) dan bahasa pemrograman yang digunakan untuk komputasi statistik dan grafik. R dikembangkan oleh Ross Ihaka dan Robert Gentleman di Universitas Auckland, Selandia Baru, pada awal tahun 1990-an sebagai evolusi dari bahasa S yang sebelumnya dikembangkan di Bell Laboratories [@history_overview_r]. R bersifat *open-source* (berlisensi GNU GPL), yang berarti dapat digunakan secara gratis dan dikembangkan secara kolaboratif oleh komunitas global [@r_wikipedia].

Keunggulan utama R dalam konteks perencanaan dan pemerintahan meliputi:

1.  **Ekosistem Paket yang Luas**: R memiliki puluhan ribu paket (*packages*) di CRAN untuk berbagai keperluan, mulai dari manipulasi data, pemodelan statistik, hingga analisis geospasial menggunakan `sf` dan `terra` [@spatial_r_sf; @spatial_data_science_terra].
2.  **Visualisasi Data**: Dengan paket seperti `ggplot2` dan `Shiny`, R memungkinkan pembuatan grafik berkualitas tinggi dan dashboard interaktif yang informatif [@shiny_gallery].
3.  **Dukungan Kebijakan Berbasis Data**: R mendukung implementasi kebijakan "Satu Data Indonesia" dengan kemampuan standardisasi, interoperabilitas, dan transparansi metode analisis yang dapat diaudit [@satu_data_local_govt]. R memfasilitasi proses ETL (*Extract-Transform-Load*) otomatis untuk membersihkan data dari berbagai instansi [@r_public_data].

Dalam bidang perencanaan wilayah dan kota, R digunakan untuk:

-   **Analisis Geospasial**: Mengelola data vektor dan raster untuk pemetaan dan pemodelan lingkungan [@spatial_data_science_terra].
-   **Perencanaan Transportasi**: Menggunakan paket seperti `stplanr` untuk analisis jaringan, rute, dan pemodelan transportasi berkelanjutan [@stplanr_cran; @sustainable_transport_stplanr].
-   **Simulasi Kebijakan**: Melakukan simulasi dampak kebijakan publik, seperti perubahan penggunaan lahan atau intervensi sosial, sebelum diterapkan secara nyata [@simulation_public_policies].

## Mengapa Menggunakan R?

R memiliki kelebihan yang signifikan dibandingkan dengan alat analisis berbasis antarmuka grafis (*Graphical User Interface* - GUI) seperti SPSS atau Microsoft Excel. Berikut adalah beberapa alasan utama mengapa R menjadi standar de facto dalam sains data modern:

1.  **Reproduksibilitas (*Reproducibility*)**:
    Berbeda dengan perangkat lunak berbasis *point-and-click* di mana langkah-langkah analisis seringkali sulit dilacak kembali, R bekerja berbasis skript (*script-based*). Setiap langkah analisis, mulai dari pembersihan data hingga pembuatan model, terekam secara eksplisit dalam kode. Hal ini memungkinkan analisis untuk diverifikasi, diaudit, dan dijalankan ulang oleh orang lain (atau diri kita sendiri di masa depan) dengan hasil yang identik, sebuah prinsip fundamental dalam penelitian ilmiah yang kredibel [@peng2011reproducible; @gandrud2013reproducible].

2.  **Fleksibilitas dan Kemampuan Kostumisasi**:
    R tidak membatasi pengguna pada menu yang sudah tersedia. Sebagai bahasa pemrograman, R memungkinkan kita untuk membangun alat analisis sendiri atau memodifikasi metode yang sudah ada sesuai dengan kebutuhan spesifik penelitian, memberikan fleksibilitas yang hampir tak terbatas dibandingkan perangkat lunak tertutup (*proprietary*) [@wickham2016r].

3.  **Gratis dan *Open Source***:
    Sebagai perangkat lunak *open source*, R dapat digunakan sepenuhnya secara gratis. Ini menghilangkan hambatan biaya lisensi yang mahal yang sering ditemui pada perangkat lunak komersial, membuatnya sangat aksesibel bagi mahasiswa, peneliti, dan pemerintah daerah dengan anggaran terbatas.

4.  **Komunitas yang Masif**:
    Dukungan komunitas R sangat luar biasa melalui platform seperti StackOverflow dan R-Bloggers. Jika Anda menemui masalah, kemungkinan besar orang lain sudah pernah menghadapinya dan solusinya sudah tersedia secara daring.

## Apa itu RStudio?

RStudio (yang kini bertransformasi menjadi **Posit**) adalah *Integrated Development Environment* (IDE) untuk R. Diluncurkan pertama kali pada tahun 2009, RStudio menyediakan antarmuka visual yang lebih ramah pengguna dibandingkan antarmuka baris perintah (*command line*) asli R [@about_posit]. Fitur-fitur seperti penyorotan sintaksis (*syntax highlighting*), *auto-completion*, dan manajemen *workspace* membuat pengguna baru lebih mudah mempelajari dan menggunakan R. Transformasi menjadi Posit mencerminkan komitmen terhadap ekosistem *data science* modern yang lebih luas, termasuk dukungan untuk Python [@goodbye_rstudio].

Gambar \@ref(fig:jendela-rstudio) memberikan penjelasan singkat tentang tampilan jendela RStudio yang terdiri atas 4 panel.

<div class="figure" style="text-align: center">
<img src="images/jendela_rstudio.png" alt="Bagian-bagian jendela RStudio" width="926" />
<p class="caption">(\#fig:jendela-rstudio)Bagian-bagian jendela RStudio</p>
</div>

1.  Panel *Environment* yang menampilkan daftar data atau variabel yang telah kita impor atau buat.
2.  Panel *Files, Plots, dan Help*, tempat kita melihat daftar *file* yang tersedia, grafik yang dihasilkan, dan menemukan dokumen bantuan untuk berbagai bagian dari R.
3.  Panel *Console*, digunakan untuk menjalankan kode.
4.  Panel *Script*, digunakan untuk menulis kode. Di sinilah kita akan menghabiskan sebagian besar waktu kerja kita.

## Instalasi R dan RStudio

Sebelum memulai praktikum, kalian perlu menginstal R dan RStudio terlebih dahulu. R harus diinstal **sebelum** RStudio, karena RStudio memerlukan instalasi R yang berfungsi untuk dapat berjalan.

**Langkah 1: Instalasi R**

1. Kunjungi situs resmi CRAN di **[cran.r-project.org](https://cran.r-project.org)**
2. Pilih sistem operasi Anda (Windows/macOS/Linux)
3. Untuk **Windows**: Klik "base" lalu unduh installer terbaru
4. Untuk **macOS**: Pilih versi sesuai prosesor (Apple Silicon M1/M2/M3/M4/M5 atau Intel)
5. Jalankan file installer dan ikuti petunjuk hingga selesai

**Langkah 2: Instalasi RStudio**

1. Kunjungi situs resmi Posit di **[posit.co/downloads](https://posit.co/downloads)**
2. Unduh **RStudio Desktop** versi gratis sesuai sistem operasi Anda
3. Jalankan installer dan ikuti petunjuk hingga selesai

**Verifikasi**: Buka RStudio setelah instalasi selesai. RStudio akan otomatis mendeteksi instalasi R yang sudah ada.

## Cara Menjalankan R

Cara (paling) utama untuk menjalankan perintah bahasa pemrograman R adalah dengan mengetikkannya langsung di **Console** (jendela nomor 3 pada Gambar \@ref(fig:jendela-rstudio)).

Misalnya, jika Anda mengetikkan `1 + 1` di Console lalu menekan **Enter**, R akan langsung memberikan jawabannya.

::: rmdexercise
**Aktivitas Mandiri: Halo Dunia**

Cobalah ketik perintah berikut di Console, lalu tekan Enter:

`print("Halo dunia!")`

Selamat! Anda baru saja menjalankan kode R pertama Anda.
:::

Namun, mengetik satu per satu di Console akan melelahkan jika perintahnya banyak. Oleh karena itu, kita biasanya menulis kode dalam sebuah file *source code* (ekstensi `.R`).

### Membuat File Kode Sumber R (`.R`)

File kode sumber R (berekstensi `.R`) adalah dokumen teks yang berisi rangkaian perintah R yang dapat disimpan, diedit, dan dijalankan berulang kali. Ini adalah cara profesional dalam bekerja dengan R, karena kode kita menjadi **terdokumentasi**, **dapat direproduksi**, dan **mudah dibagikan**.

**Langkah-langkah membuat file `.R` baru:**

1. Di RStudio, pilih menu **File → New File → R Script** (atau tekan **Ctrl + Shift + N** di Windows/Linux, **Cmd + Shift + N** di Mac)
2. Sebuah tab baru akan muncul di panel *Script* (jendela kiri atas)
3. Ketikkan kode R Anda di dalam tab tersebut
4. Simpan file dengan memilih **File → Save** (atau **Ctrl + S** / **Cmd + S**)
5. Beri nama file dengan ekstensi `.R`, misalnya `kode_R_pertama_saya.R`

**Menjalankan kode dari file `.R`:**

Untuk menjalankan kode dari file `.R` ke Console tanpa mengetik ulang:

1. Sorot (blok) baris kode yang ingin dijalankan di panel *Script*
2. Tekan kombinasi tombol **Ctrl + Enter** (Windows/Linux) atau **Cmd + Enter** (Mac)
3. Kode yang disorot akan otomatis dikirim ke *Console* dan dijalankan

Ini adalah cara kerja standar yang efisien dalam menggunakan R. Dengan cara ini, kita bisa:

- **Menyimpan pekerjaan** untuk digunakan di lain waktu
- **Menjalankan ulang** analisis dengan mudah
- **Berbagi kode** dengan rekan kerja atau asisten praktikum
- **Mendokumentasikan** setiap langkah analisis kita

::: rmdexercise
**Aktivitas Mandiri: Membuat Kode Sumber R**

1. Buatlah file R Script baru melalui menu **File → New File → R Script**
2. Ketikkan kode berikut di dalam file tersebut:

``` r
# File kode R pertama saya
# Dibuat pada: [isi dengan tanggal hari ini]

print("Halo dunia!")
print("Hari ini saya mulai belajar R!")

# Operasi matematika sederhana
1 + 1
2 * 3
```

3. Simpan file dengan nama `kode_R_pertama_saya.R` di dalam folder **Praktikum STP 2026**
4. Sorot baris-baris kode `print`, lalu tekan **Ctrl + Enter** (Windows/Linux) atau **Cmd + Enter** (Mac). Setelah itu, sorot baris-baris operasi matematika, lalu tekan **Ctrl + Enter** (Windows/Linux) atau **Cmd + Enter** (Mac) lagi.
5. Perhatikan jendela *Console* - Anda akan melihat hasil eksekusi kode Anda
6. Selamat! Anda baru saja membuat file kode sumber R pertama Anda yang dapat disimpan dan dijalankan kapan saja. Jangan lupa tekan **Ctrl + S** / **Cmd + S** untuk menyimpan file Anda setiap kali Anda selesai mengeditnya.

:::

------------------------------------------------------------------------

# Pengenalan Teknis R {.unnumbered}

Sebelum memulai praktikum dengan set data sesungguhnya, ada baiknya kita memahami beberapa konsep teknis dasar dalam bahasa pemrograman R. Bagian ini merangkum keterampilan-keterampilan dasar yang akan kalian temui tersebar di modul-modul praktikum.

## Pengaturan Direktori

Salah satu keterampilan penting dalam bekerja dengan R adalah mengorganisasi *file* dan data dengan baik. Sepanjang semester ini, kalian akan bekerja dengan berbagai dataset, kode R, dan hasil analisis. Pengaturan direktori yang terstruktur akan memudahkan kalian dalam mengelola semua file tersebut dan memastikan kode dapat berjalan dengan lancar.

### Struktur Direktori yang Ideal

Sebelum memulai praktikum, kalian perlu menyiapkan direktori kerja (*working directory*) yang terorganisir dengan baik. Berikut adalah struktur direktori yang **wajib** kalian gunakan sepanjang semester:

```text
Praktikum STP 2026/
├── Praktikum STP 2026.Rproj
├── datasets/
│   ├── data.csv
│   └── ...
├── output/
│   ├── output_1.xlsx
│   └── ...
├── modul_1.R
└── modul_2.R
```

**Komponen-komponen penting:**

-   **`Praktikum STP 2026.Rproj`**: File RStudio Project yang mengatur *working directory* secara otomatis dan menyimpan *environment* kerja kalian.
-   **`datasets/`**: Folder khusus untuk menyimpan **semua dataset mentah** (file Excel, CSV, atau format lainnya yang kalian terima dari asisten praktikum).
-   **`output/`**: Folder khusus untuk menyimpan **hasil-hasil analisis** seperti file Excel yang sudah diolah, file CSV hasil export, atau grafik yang dihasilkan.
-   **`modul_1.R`, `modul_2.R`, ...**: File-file kode R (script) yang akan kalian buat untuk setiap modul praktikum.

Dengan struktur seperti ini, kode R kalian akan lebih **ringkas** dan **portabel**. Sebagai contoh, untuk membaca data, kalian cukup menulis:

``` r
data <- read.xlsx("datasets/data_penduduk.xlsx")
```

Tanpa perlu menulis *path* lengkap seperti `C:\Users\NamaAnda\Documents\praktikum\data_penduduk.xlsx` yang panjang, rumit, dan berbeda-beda di setiap komputer.

### Membuat dan Mengatur Direktori Praktikum

Ikuti langkah-langkah berikut untuk menyiapkan direktori praktikum kalian:

#### Langkah 1: Membuat Folder Utama

Buatlah sebuah folder di komputer kalian dengan nama **`Praktikum STP 2026`** (sesuai tahun ajaran yang sedang berjalan). Penamaan yang seragam ini **sangat penting** agar asisten praktikum dapat dengan mudah membantu kalian jika terjadi masalah atau kesalahan.

Folder ini akan menjadi **direktori kerja** (*working directory*) kalian selama satu semester penuh.

#### Langkah 2: Membuat Subfolder `datasets` dan `output`

Di dalam folder `Praktikum STP 2026`, buatlah **dua subfolder**:

1.  Subfolder **`datasets`** - untuk menyimpan semua data mentah
2.  Subfolder **`output`** - untuk menyimpan hasil analisis

**Cara membuat folder:**

-   **Di Windows**: Klik kanan di dalam folder `Praktikum STP 2026` → pilih *New* → *Folder* → beri nama `datasets`, lalu ulangi untuk membuat folder `output`
-   **Di Mac/Linux**: Klik kanan di dalam folder `Praktikum STP 2026` → pilih *New Folder* → beri nama `datasets`, lalu ulangi untuk membuat folder `output`

Setiap kali kalian mendapatkan dataset baru untuk praktikum (misalnya file Excel atau CSV dari asisten), **simpanlah di dalam folder `datasets`**. Setiap kali kalian menghasilkan output analisis, **simpanlah di dalam folder `output`**.

#### Langkah 3: Mengubahnya Menjadi RStudio Project

Setelah struktur folder dasar sudah siap, langkah selanjutnya adalah mengubahnya menjadi **RStudio Project**. RStudio Project adalah fitur yang sangat berguna untuk mengelola sesi kerja R kalian.

**Keuntungan RStudio Project:**

1.  **Otomatis mengatur *working directory***: Ketika kalian membuka sebuah Project, RStudio otomatis mengatur *working directory* ke folder tersebut, sehingga kalian tidak perlu menggunakan perintah `setwd()` lagi.

::: rmdnote
Perintah `setwd()` digunakan untuk mengatur *working directory* secara manual. Misalnya, jika kita ingin mengatur *working directory* ke folder `Praktikum STP 2026` yang terletak dalam folder `Documents` pada direktori `C:/Users/NamaAnda/`, kita bisa menggunakan perintah 

```r
setwd("C:/Users/NamaAnda/Documents/Praktikum STP 2026")
```

Namun, jika kita sudah membuat direktori Anda sebagai Project, dalam praktikum ini, kita tidak perlu menggunakan perintah ini lagi.
:::

2.  **Mempertahankan status kerja**: RStudio menyimpan *environment* (variabel, data yang sudah dimuat) sehingga kalian bisa melanjutkan pekerjaan dari tempat terakhir kalian berhenti.
3.  **Memudahkan manajemen path**: Kalian cukup menulis *relative path* (misalnya `datasets/data.xlsx`) tanpa perlu mengetik *path* lengkap yang panjang dan berisiko error.
4.  **Portabilitas**: Project folder bisa dipindahkan ke komputer lain atau dibagikan ke rekan tanpa perlu mengubah kode, karena semua path bersifat relatif.

**Cara membuat RStudio Project:**

1.  Buka RStudio
2.  Pilih menu **File → New Project...**
3.  Pilih **Existing Directory** (karena folder sudah dibuat)
4.  Klik **Browse...** dan cari folder **`Praktikum STP 2026`** yang sudah kalian buat
5.  Klik **Create Project**

Setelah itu, RStudio akan membuat file **`Praktikum STP 2026.Rproj`** di dalam folder kalian. File `.Rproj` ini adalah "pintu masuk" ke Project kalian.

**Setiap kali ingin bekerja**: Cukup *double-click* file **`Praktikum STP 2026.Rproj`** tersebut, dan RStudio akan terbuka dengan *working directory* yang sudah otomatis diatur ke folder praktikum kalian. Kalian siap untuk mulai bekerja!

::: rmdwarning
**Catatan Penting:** Selalu buka RStudio melalui file `.Rproj`, bukan dengan membuka RStudio terlebih dahulu lalu membuka *script*. Ini memastikan *working directory* selalu benar dan kode kalian berjalan sebagaimana mestinya.
:::

### Mengunduh Dataset Praktikum dari GitHub

Setelah struktur direktori dan Project sudah siap, langkah selanjutnya adalah **mengunduh dataset-dataset praktikum** yang akan digunakan sepanjang semester. Semua dataset praktikum disimpan di repository GitHub dan dapat diunduh secara gratis.

::: rmdnote
**Mengapa Dataset Disimpan di GitHub? {.header}**

Dataset praktikum disimpan di GitHub agar:
- Semua mahasiswa mendapatkan dataset yang **sama** dan **terbaru**
- Dataset dapat **diakses kapan saja** tanpa perlu menunggu distribusi dari asisten
- Jika ada pembaruan dataset, kalian bisa **mengunduh ulang** dengan mudah
- Dataset **tidak hilang** meskipun laptop rusak atau file terhapus
:::

#### Langkah-Langkah Mengunduh Dataset

Ikuti langkah-langkah berikut dengan seksama untuk mengunduh folder `datasets/` dari GitHub:

**1. Buka halaman GitHub repository praktikum**

Klik link berikut atau copy-paste ke browser kalian:

**[https://github.com/abdulmubdibindar/praktikum-r-stp](https://github.com/abdulmubdibindar/praktikum-r-stp)**

Kalian akan melihat halaman repository yang berisi semua file praktikum.

**2. Download seluruh repository sebagai file ZIP**

- Di halaman GitHub, cari dan klik tombol hijau **"Code"** di bagian kanan atas
- Pada menu yang muncul, pilih **"Download ZIP"**
- Simpan file ZIP di lokasi yang mudah kalian temukan (misalnya folder **Downloads** atau **Desktop**)
- Tunggu hingga proses download selesai

**3. Ekstrak file ZIP yang sudah didownload**

- Buka folder tempat kalian menyimpan file ZIP (misalnya **Downloads**)
- Klik kanan pada file **`praktikum-r-stp-main.zip`**
- Pilih **"Extract All..."** atau **"Extract Here"** (di Windows)
- Atau untuk Mac/Linux: double-click file ZIP, akan otomatis ter-ekstrak
- Setelah ekstrak selesai, akan muncul folder bernama **`praktikum-r-stp-main`**

**4. Copy folder `datasets` ke dalam Project RStudio kalian**

Ini adalah langkah paling penting! Ikuti dengan teliti:

- Buka folder **`praktikum-r-stp-main`** yang baru diekstrak
- Di dalam folder tersebut, cari folder bernama **`datasets`**
- **Klik kanan** pada folder `datasets`, lalu pilih **"Copy"** (atau tekan `Ctrl + C`)
- Buka folder **`Praktikum STP 2026`** (folder Project RStudio kalian)
- **Klik kanan** di dalam folder tersebut, lalu pilih **"Paste"** (atau tekan `Ctrl + V`)
- Folder `datasets` beserta seluruh isinya sekarang sudah tersalin ke Project kalian

**5. Verifikasi dataset sudah tersimpan dengan benar**

Untuk memastikan dataset sudah tersimpan di lokasi yang benar, buka RStudio (klik file `.Rproj` kalian), lalu jalankan kode berikut di **Console**:



Jika hasilnya `TRUE`, berarti folder `datasets` sudah berada di lokasi yang benar! ✓

Selanjutnya, cek isi folder `datasets` dengan kode:



Kalian akan melihat daftar file-file dataset seperti `Data Praktikum 01.xlsx`, `Data Praktikum 02.xlsx`, `DataUtama_mhsUBL.csv`, dan lain-lain.

::: rmdimportant
**Struktur Folder yang Benar {.header}**

Pastikan struktur folder Project kalian sekarang terlihat seperti ini:

```text
Praktikum STP 2026/           ← Folder Project kalian
├── Praktikum STP 2026.Rproj  ← File Project RStudio
├── datasets/                 ← Folder datasets (HARUS ada di sini!)
│   ├── Data Praktikum 01.xlsx
│   ├── Data Praktikum 02.xlsx
│   ├── Data Praktikum 03.xlsx
│   ├── DataUtama_mhsUBL.csv
│   ├── DataUtama_mhsUINRIL.csv
│   ├── DataUtama_mhsUNILA.csv
│   ├── DataUtama_mhsITERA.csv
│   ├── data_mahasiswa.csv
│   └── ... (file-file dataset lainnya)
├── output/                   ← Folder untuk hasil analisis
└── ... (file .R kalian)
```

**PENTING**: Jika folder `datasets` berada di lokasi lain (misalnya di **Desktop** atau **Downloads**), kode praktikum **tidak akan bisa** membaca dataset. Pastikan folder `datasets` berada **langsung di dalam** folder `Praktikum STP 2026`.
:::

#### Alternatif: Download Dataset Satu per Satu (Tidak Disarankan)

Jika kalian hanya ingin mengunduh satu atau beberapa file dataset tertentu, bisa menggunakan cara berikut:

1. Buka [folder datasets di GitHub](https://github.com/abdulmubdibindar/praktikum-r-stp/tree/main/datasets)
2. Klik nama file dataset yang ingin diunduh (misalnya `Data Praktikum 01.xlsx`)
3. Klik tombol **"Download"** di pojok kanan atas halaman
4. Simpan file tersebut ke dalam folder **`datasets/`** di Project RStudio kalian

> **Catatan**: Cara ini lebih lambat jika kalian perlu banyak file. **Sangat disarankan** menggunakan cara download ZIP untuk mendapatkan **semua dataset sekaligus** agar tidak perlu download berulang-ulang.

#### Troubleshooting: Jika Kode Tidak Bisa Membaca Dataset

Jika kalian mengalami error seperti:

```
Error in file(file, "rt") : cannot open the connection
```

Kemungkinan penyebabnya:

- ❌ Folder `datasets` tidak berada di lokasi yang benar
- ❌ Nama folder salah ketik (misalnya `dataset` tanpa huruf 's' atau `Datasets` dengan huruf kapital)
- ❌ File Project `.Rproj` tidak dibuka (sehingga *working directory* salah)

**Solusi:**

1. Tutup RStudio
2. Buka **kembali** RStudio dengan cara double-click file **`Praktikum STP 2026.Rproj`**
3. Jalankan kembali kode `dir.exists("datasets")` - harus menghasilkan `TRUE`
4. Jika masih `FALSE`, cek kembali apakah folder `datasets` sudah benar-benar berada di dalam folder Project


## Sintaks Dasar Bahasa r

Dalam subbab ini, kita akan membahas sintaks dasar bahasa R yang akan sering digunakan dalam praktikum ini.

### Komentar

Pada dasarnya, semua yang kita tulis di *script* akan dijalankan oleh R. Akan tetapi, kita bisa memberi tahu R untuk tidak menjalankan kode yang kita tulis dengan mengubah formatnya menjadi **komentar** (*comment*). Kita bisa menuliskan komentar dengan menggunakan tanda pagar (`#`) sebelum kode yang ingin kita komentari.

``` r
# Kode ini akan menghitung 1 + 1
1 + 1 
```

::: rmdimportant
Komentar sangat berperan penting dalam kode kalian. Malahan, ini adalah kekuatan terbesar dari penggunaan R dalam Kita akan sering menggunakan komentar dalam kode kalian. Jadi, jangan ragu untuk menggunakan komentar untuk menjelaskan kode kalian.
:::

### *Assignment* (Pemberian Nilai)

Untuk menyimpan nilai ke dalam variabel/objek, kita menggunakan tanda panah kiri (`<-`). Gunakanlah selalu `<-` sebagai penanda bahwa kita sedang memasukkan nilai ke dalam objek, karena ini adalah standar baku dalam pemrograman R.

``` r
x <- 10
nama <- "Budi"
```

### *Case Sensitivity*

R membedakan huruf besar dan huruf kecil (*case sensitive*). Variabel `Data` dianggap berbeda dengan `data`.

## Paket (*Packages*)

R memiliki ribuan paket tambahan yang menyediakan fungsi-fungsi khusus.

-   **`install.packages("nama_paket")`**: Digunakan untuk mengunduh dan menginstal paket dari internet ke komputer kita. Ini cukup dilakukan satu kali saja.
-   **`library(nama_paket)`**: Digunakan untuk memuat paket yang sudah terinstal ke dalam sesi kerja kita agar isinya bisa digunakan. Ini harus dilakukan setiap kali kita membuka RStudio baru.

Paket utama yang akan sering kita gunakan adalah:

-   **`tidyverse`**: Kumpulan paket untuk pengolahan data modern.
-   **`openxlsx`**: Untuk membaca dan menulis file Excel.

::: rmdexercise
**Aktivitas Mandiri: Instalasi Paket**

Cobalah untuk menginstal paket `tidyverse` dan `openxlsx` di komputer Anda dengan mengetikkan perintah berikut di *Console*:

`install.packages(c("tidyverse", "openxlsx"))`

Tunggu hingga proses instalasi selesai. Ingat, tahap ini hanya perlu dilakukan satu kali saja.
:::

## Fungsi (*Functions*)

Fungsi adalah serangkaian instruksi yang dibungkus menjadi satu perintah untuk melakukan tugas tertentu. R memiliki banyak fungsi bawaan, dan kita juga bisa membuat fungsi sendiri.

### Menggunakan Fungsi

Untuk menggunakan fungsi, kita memanggil namanya diikuti dengan tanda kurung `()`. Di dalam tanda kurung, kita bisa memasukkan **argumen** (input).

``` r
# Contoh fungsi bawaan: mean (rata-rata)
nilai <- c(10, 20, 30)
rata_rata <- mean(nilai) # Hasil: 20
```

### Membuat Fungsi Sendiri

Kita dapat membuat fungsi kustom menggunakan perintah `function()`. Struktur dasarnya adalah:

``` r
nama_fungsi <- function(input) {
  # Proses yang dilakukan
  hasil <- input * 2
  return(hasil)
}
```

Ini akan sangat berguna ketika kita ingin melakukan perhitungan yang sama berulang kali, seperti pada perhitungan IQV di Modul 2.

## Struktur Data Dasar

### Vektor

Vektor adalah struktur data paling dasar di R yang menampung deretan nilai dengan tipe yang sama. Kita membuatnya dengan fungsi `c()` (*combine*).

``` r
angka <- c(1, 2, 3, 4, 5)
huruf <- c("a", "b", "c")
```

### Tipe Data

Saat mengolah data, kalian akan sering menemukan singkatan tipe data berikut:

-   **`dbl` (Double)**: Angka numerik (bisa desimal).
-   **`chr` (Character)**: Teks atau *string*. Ditandai dengan tanda kutip.
-   **`fct` (Factor)**: Data kategorik (bisa nominal atau ordinal). Factor menyimpan nilai sebagai angka di belakang layar namun menampilkan label teks, yang berguna untuk analisis statistik dan plot.

### Data Frame dan Tibble

Data dalam R biasanya disimpan dalam bentuk tabel yang disebut *Data Frame*. Di era modern (tidyverse), kita sering menggunakan versi yang lebih canggih disebut **Tibble**. Strukturnya mirip spreadsheet: baris mewakili observasi, kolom mewakili variabel.

## Operator Pipa (`|>`)

Dalam `tidyverse`, kita sering menggunakan operator pipa (`|>`) untuk merangkai beberapa perintah sekaligus. Bayangkan ini sebagai penyambung proses:

``` r
# Tanpa pipa
hasil <- fungsi_2(fungsi_1(data))

# Dengan pipa (lebih mudah dibaca)
data |> 
  fungsi_1() |> 
  fungsi_2()
```

Artinya: "Ambil `data`, lalu `fungsi_1`, kemudian hasilnya dimasukkan ke `fungsi_2`."

## Manajemen Data (Input/Output)

### Membaca Data

Kita sering menggunakan `read.xlsx()` dari paket `openxlsx` untuk membaca file Excel.

``` r
data <- read.xlsx("folder/nama_file.xlsx", sheet = "nama_sheet")
```

### Menyimpan Data

Setelah diolah, data bisa disimpan kembali ke Excel atau CSV.

``` r
write.xlsx(data, "folder/nama_file_baru.xlsx")
write.csv2(data, "folder/nama_file_baru.csv") # Format CSV Excel Indonesia (pemisah titik koma)
```

<!--chapter:end:index.Rmd-->

# Modul-1: Pengolahan Data Terstruktur

Setelah mempelajari modul ini Anda diharapkan dapat:

1.  menganalisis variabel dan objek dalam sebuah format data terstruktur [STP-1.3]{.capaian}
2.  mengelola data terstruktur dengan tepat menggunakan perangkat komputer [STP-1.4]{.capaian}

---

Kita akan mempelajari cara pengolahan data terstruktur atau *dataset*/set data dari hasil kuesioner kepada mahasiswa-mahasiswa Universitas Islam Negeri Raden Intan Lampung (UINRIL) dan Universitas Bandar Lampung (UBL) tentang pola perjalanan mereka.

Dalam R, pengolahan data terstruktur dipermudah dengan adanya paket `tidyverse`. Paket ini menyertakan paket-paket lain yang mempunyai kegunaan unik dalam pengolahan data terstruktur.



Seperti yang kalian lihat, paket `tidyverse` menyertakan paket-paket berikut yang mempunyai kegunaan masing-masing:

-   `dplyr`: menyediakan serangkaian fungsi inti untuk memanipulasi dan mentransformasi data secara efisien.
-   `forcats`: memudahkan pekerjaan dengan data kategorikal atau yang dalam R disebut juga 'factors'.
-   `ggplot2`: untuk membuat grafik yang ciamik.
-   `lubridate`: mempermudah pekerjaan terkait format tanggal
-   `purrr`: meningkatkan kemampuan pemrograman fungsi dan vektor
-   `readr`: untuk membaca data tabular seperti `.csv`
-   `stringr`: menyederhanakan operasi teks/*string*
-   `tibble`: versi modern dari *data.frame* yang lebih rapi dan mudah digunakan.
-   `tidyr`: untuk merapikan data dengan mengubah format atau struktur tata letaknya.

Selain paket `tidyverse`, kita juga akan menggunakan paket `openxlsx` untuk mengoperasikan *file* Excel.



## Mengimpor set data *(dataset)* dari Excel

Untuk membuat set data di lingkungan kerja R kita, gunakan fungsi `read.xlsx()` seperti berikut. Fungsi `read.xlsx()` mempunyai atribut utama berupa *file path* lokasi file yang ditempatkan di dalam tanda kurung.

::: rmdwarning

⚠️ **Penting**

Pastikan file Excel yang akan diimpor sudah tertutup, karena mengimpor file yang sedang terbuka akan menghasilkan *error*.
:::




























































































































































































































































































































































