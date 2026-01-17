# Panduan Custom Blocks untuk Bookdown

Panduan ini berisi koleksi "Custom Blocks" yang dapat Anda gunakan untuk mempercantik tampilan modul praktikum. Custom blocks berguna untuk menonjolkan informasi penting seperti **Catatan**, **Tips**, **Peringatan**, atau **Tugas**.

## 1. Apa itu Custom Blocks?

Dalam R Markdown / Bookdown, kita bisa membuat kotak khusus (blocks) menggunakan tanda titik dua tiga kali (`:::`) diikuti dengan nama kelas CSS.

**Sintaks:**

``` markdown
::: nama-kelas
Isi teks di sini...
:::
```

## 2. Pilihan Blok yang Tersedia

Berikut adalah daftar gaya blok yang direkomendasikan untuk modul praktikum Anda. Anda dapat memilih mana yang paling sesuai dengan konteks kalimat.

### A. Catatan (Note)

Digunakan untuk informasi tambahan atau klarifikasi yang *nice to know* tapi bukan inti materi.

-   **Warna**: Biru
-   **Kode**: `::: rmdnote` (Sudah ada di `style.css` Anda)

**Contoh Penggunaan:**

``` markdown
::: rmdnote
**Catatan:** R bersifat _case-sensitive_, artinya huruf besar dan kecil dianggap berbeda.
:::
```

### B. Tips (Tip)

Digunakan untuk memberikan saran praktis, jalan pintas (*shortcut*), atau *best practice*.

-   **Warna**: Hijau
-   **Kode**: `::: rmdtip`

**Contoh Penggunaan:**

``` markdown
::: rmdtip
**Tip:** Gunakan tombol `Tab` untuk melengkapi nama fungsi secara otomatis di RStudio.
:::
```

### C. Penting (Important)

Digunakan untuk konsep kunci yang **harus** dipahami mahasiswa sebelum melanjutkan.

-   **Warna**: Ungu
-   **Kode**: `::: rmdimportant`

**Contoh Penggunaan:**

``` markdown
::: rmdimportant
**Penting:** Selalu pastikan data Anda sudah bersih (clean) sebelum melakukan analisis statistik.
:::
```

### D. Peringatan (Warning)

Digunakan untuk memperingatkan tentang potensi error atau kesalahan umum.

-   **Warna**: Kuning/Oranye
-   **Kode**: `::: rmdwarning`

**Contoh Penggunaan:**

``` markdown
::: rmdwarning
**Hati-hati:** Fungsi ini akan menghapus semua variabel di memori Anda.
:::
```

### E. Latihan / Tugas (Exercise)

Digunakan untuk menunujukkan soal latihan yang harus dikerjakan.

-   **Warna**: Abu-abu / Netral dengan border tebal
-   **Kode**: `::: rmdexercise`

**Contoh Penggunaan:**

``` markdown
::: rmdexercise
**Latihan 1:**
Buatlah sebuah vektor yang berisi 5 nama kota di Indonesia!
:::
```

------------------------------------------------------------------------

## 3. Cara Mengaktifkan (Copy-Paste CSS)

Agar blok-blok di atas (selain `rmdnote` yang sudah ada) berfungsi, salin kode di bawah ini dan tempelkan ke bagian paling bawah file **`style.css`** Anda.

``` css
/* --- MULAI CUSTOM BLOCKS --- */

/* 1. Catatan (Sudah ada, ini versi update yang lebih rapi jika mau) */
.rmdnote {
  padding: 1em;
  margin: 1em 0;
  padding-left: 15px;
  background-color: #e7f2fa; /* Biru sangat muda */
  border-left: 6px solid #2196f3; /* Biru Material */
  border-radius: 4px;
  color: #2c3e50;
}

/* 2. Tips (Tip) - Hijau */
.rmdtip {
  padding: 1em;
  margin: 1em 0;
  padding-left: 15px;
  background-color: #e6ffed; /* Hijau sangat muda */
  border-left: 6px solid #00c853; /* Hijau Material */
  border-radius: 4px;
  color: #2c3e50;
}

/* 3. Penting (Important) - Ungu */
.rmdimportant {
  padding: 1em;
  margin: 1em 0;
  padding-left: 15px;
  background-color: #f3e5f5; /* Ungu sangat muda */
  border-left: 6px solid #9c27b0; /* Ungu Material */
  border-radius: 4px;
  color: #2c3e50;
}

/* 4. Peringatan (Warning) - Kuning/Oranye */
.rmdwarning {
  padding: 1em;
  margin: 1em 0;
  padding-left: 15px;
  background-color: #fff8e1; /* Kuning sangat muda */
  border-left: 6px solid #ffab00; /* Amber Material */
  border-radius: 4px;
  color: #2c3e50;
}

/* 5. Soal Latihan (Exercise) - Merah Bata / Netral */
.rmdexercise {
  padding: 1em;
  margin: 1em 0;
  padding-left: 15px;
  background-color: #fbe9e7; /* Merah bata sangat muda */
  border-left: 6px solid #ff5722; /* Deep Orange */
  border-radius: 4px;
  color: #2c3e50;
  font-weight: 500;
}

/* Bonus: Ikon opsional sebelum teks (membutuhkan FontAwesome, tapi ini styling dasar teks) */
.rmdnote strong,
.rmdtip strong,
.rmdimportant strong,
.rmdwarning strong,
.rmdexercise strong {
  display: block;
  margin-bottom: 0.5em;
  font-size: 1.1em;
}

/* --- SELESAI CUSTOM BLOCKS --- */
```

## 4. Tips Tambahan

-   **Kombinasi dengan Emoji**: Anda bisa menambahkan emoji di judul blok agar lebih menarik.
    -   `::: rmdtip` 💡 **Tips Pro:** ... `:::`
    -   `::: rmdwarning` ⚠️ **Awas:** ... `:::`
-   **Indentasi**: Pastikan isi blok menjorok (indent) atau berada di baris baru agar Markdown di dalamnya (seperti *bold*, link, atau kode) tetap terbaca/dirender dengan benar.