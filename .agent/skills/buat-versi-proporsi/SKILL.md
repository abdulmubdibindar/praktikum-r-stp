---
name: buat-versi-proporsi
description: membuat teks tutorial praktikum untuk versi parameter proporsi menggunakan konteks dan langkah yang serupa dengan versi parameter rata-rata
---

# Membuat Teks Tutorial Versi Parameter Proporsi

## Apa yang dilakukan skill ini

Skill ini memandu bagaimana pembuatan teks tutorial bagian parameter proporsi berdasarkan konteks yang digunakan pada dokumen praktikum di bagian sebelumnya, yakni bagian parameter rata-rata (contohnya: `/contoh_bagian_rata2.Rmd`).

## Panduan penulisan teks tutorial

Teks tutorial terdiri atas 3 level heading:

- **Level 1**: judul bagian yakni **Uji Hipotesis Dua Populasi Independen untuk Parameter Proporsi**
- **Level 2**: langkah-langkah pengujian hipotesis yang terdiri atas:
  - Memuat dataset
    - Lihat bagian [Dataset yang digunakan](#dataset) dokumen ini.
    - Bahas mengenai konteks dari variabel yang akan digunakan untuk pengujian hipotesis.
    - Tampilkan kode untuk memuat dataset.
    - Tampilkan kode untuk memeriksa kondisi data.
    - Tampilkan output dari pemeriksaan kondisi data.
  - Merumuskan hipotesis kosong dan alternatif
    - Jelaskan mengenai bagaimana merumuskan hipotesis kosong dan alternatif berdasarkan cara yang digunakan pada bagian parameter rata-rata yang sudah dituliskan sebelumnya.
    - Sekarang atur agar hipotesis alternatifnya berarah lebih kecil (satu sisi kiri)
  - Memilih distribusi statistik, wilayah kritis, dan titik kritis
    - Jelaskan distribusi statistik apa yang dipakai, wilayah kritisnya, dan titik kritisnya.
    - Kali ini gunakan wilayah kritis = $\alpha = 0.10$
    - Jelaskan cara menemukan titik kritisnya.
  - Menghitung statistik uji
    - Bagian ini mengandung **Level 3** heading:
      - Membuat fungsi untuk menghitung statistik uji
      - Mendeklarasikan variabel masukan
      - Menghitung statistik uji
  - Menarik kesimpulan
    - Gunakan patokan rumus `if-else` yang sudah diberikan di bagian parameter rata-rata sebelumnya
    - Nyatakan hasil pengujian hipotesis dan bahas interpretasinya.

Buat block `rmexercise` setelah penjelasan setiap sub bagian seperti yang dilakukan di bagian parameter rata-rata dalam modul praktikum ini.

## Dataset yang digunakan

Praktikum ini menggunakan dataset yang ada pada direktori `datasets/` yang bernama `data_mahasiswa.csv`. Dataset ini sudah dimuat pada bagian parameter rata-rata di bagian sebelumnya modul praktikum. Ada 4 dataset yang dimuat:

- `data_itera`
- `data_uinril`
- `data_ubl`
- `data_unila`

`data_itera` dan `data_uinril` digunakan untuk demonstrasi, sementara `data_ubl` dan `data_unila` digunakan untuk latihan.

## Penulisan _Code Chunks_

- Setiap _code chunk_ harus memiliki label yang diawali dengan `mod05a-` diikuti dengan deskripsi singkat mengenai _code chunk_ tersebut. Contoh: `mod05a-load-dataset`.
- Gunakan _code chunk_ dengan `echo=TRUE` untuk menampilkan kode, dan `echo=FALSE` untuk menyembunyikan kode.
- Gunakan _code chunk_ dengan `results='hide'` untuk menyembunyikan output. Opsi lain adalah `'hold'` untuk menampilkan output di bawah kode sekaligus.
  - Gunakan `'hide'` untuk _code chunk_ pengerjaan pada blok latihan.
  - Gunakan `'hold'` untuk _code chunk_ pengerjaan pada blok demonstrasi yang menampilkan lebih dari satu keluaran.
- Gunakan _code chunk_ dengan `collapse=TRUE` untuk menggabungkan kode dan output dalam satu _code chunk_.

## Penulisan Block `rmexercise`

- Gunakan `rmexercise` untuk membuat blok latihan.
- Atur agar level heading di dalam `rmexercise` adalah level yang sama seperti lokasi `rmexercise` tersebut. Contoh: jika `rmexercise` berada di dalam sub bagian level 2, maka level heading di dalam `rmexercise` adalah level 2 juga.
- Judul yang digunakan adalah "Aktivitas Mandiri" diikuti dengan nomor urut aktivitas (misalnya: Aktivitas Mandiri 1, Aktivitas Mandiri 2, dst.) dan diakhiri dengan `{.unnumbered}`. Pastikan penomoran aktivitasnya berurutan berdasarkan yang sudah ditulis sebelumnya.
