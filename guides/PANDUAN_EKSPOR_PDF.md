# Panduan Ekspor ke PDF (Bookdown)

Dokumen ini berisi langkah-langkah untuk mengekspor proyek modul praktikum ini menjadi dokumen PDF yang siap cetak.

## 1. Persiapan Awal (Instalasi LaTeX)

Untuk membuat PDF dari R Markdown, Anda memerlukan distribusi LaTeX. Cara termudah untuk pengguna R adalah dengan menggunakan paket `tinytex`.

Jalankan perintah berikut di **Console R** (bukan di dalam chunk R Markdown) satu kali saja:

```r
# 1. Instal paket tinytex
install.packages("tinytex")

# 2. Instal TinyTeX (distribusi LaTeX ringan)
tinytex::install_tinytex()
```

_Catatan: Proses ini membutuhkan koneksi internet dan waktu beberapa menit untuk mengunduh komponen yang diperlukan._

## 2. Konfigurasi `index.Rmd`

Buka file `index.Rmd` dan tambahkan konfigurasi `bookdown::pdf_book` di bawah bagian `output`. Pastikan indentasi (spasi) sesuai.

Ubah bagian YAML header (bagian paling atas di antara `---`):

```yaml
---
title: "Modul Praktik Statistika Untuk Perencanaan"
# ... (bagian lain tetap sama)
output:
  bookdown::gitbook:
    css: style.css
    split_bib: false
  bookdown::pdf_book:
    latex_engine: xelatex
    citation_package: natbib
    keep_tex: true
# ...
---
```

**Penjelasan Konfigurasi:**

- `latex_engine: xelatex`: Disarankan menggunakan `xelatex` untuk dukungan font yang lebih baik dan karakter Unicode.
- `keep_tex: true`: Berguna untuk _debugging_ jika terjadi error saat pembuatan PDF.

## 3. Cara Merender (Ekspor)

Ada dua cara untuk melakukan ekspor ke PDF:

### Cara A: Melalui Panel Build (Klik Tombol)

1.  Buka panel **Build** di RStudio (biasanya di kanan atas, satu tab dengan Environment/History).
2.  Klik tombol segitiga kecil di sebelah **Build Book**.
3.  Pilih **bookdown::pdf_book**.

### Cara B: Melalui Console (Perintah)

Jalankan perintah berikut di Console R:

```r
bookdown::render_book("index.Rmd", "bookdown::pdf_book")
```

## 4. Troubleshooting (Masalah Umum)

### Error "LaTeX failed to compile"

Jika muncul error seperti ini, biasanya ada paket LaTeX yang kurang atau karakter khusus yang tidak didukung.

- Periksa file log (biasanya berekstensi `.log`) untuk detail error.
- Coba jalankan: `tinytex::reinstall_tinytex()` jika instalasi terasa korup.

### Gambar Terpotong/Terlalu Besar

PDF memiliki halaman statis, berbeda dengan HTML.

- Pastikan chunk gambar memiliki argumen `out.width` yang sesuai, misalnya `out.width = "80%"`.
- Contoh: `{r, out.width="80%", fig.align="center"}`.

### Tabel Terpotong

Jika tabel terlalu lebar:

- Gunakan paket `kableExtra` dengan opsi `latex_options = "scale_down"` agar tabel otomatis mengecil menyesuaikan lebar halaman.
