---
name: buat-rmdexercise
description: Panduan menyusun bagian Aktivitas Mandiri (rmdexercise) dalam modul praktikum R. Gunakan skill ini jika Anda diminta untuk membuat latihan atau tugas mandiri menggunakan format rmdexercise.
---

# Panduan Membuat Rmdexercise (Aktivitas Mandiri)

Skill ini memberikan referensi dan panduan untuk merancang bagian latihan pemahaman yang disebut sebagai fitur **Aktivitas Mandiri** (menggunakan block `rmdexercise`).

Anda dapat merujuk file `references/05-uji-hipotesis.Rmd` sebagai acuan konkret bagaimana format penyajian exercise ini diterapkan pada sebuah modul aslinya.

## Prinsip Penyusunan `rmdexercise`

1. **Struktur Paralel dengan Materi Utama**:
   Setiap "Aktivitas Mandiri" diletakkan setelah sebuah penjelasan konsep utama. Pertanyaan atau instruksi yang dibuat harus mengikuti langkah-langkah yang baru saja dilakukan pada contoh di teks pendahulunya, sehingga mahasiswa dapat langsung mempraktikkannya.
2. **Konteks/Dataset Berbeda**:
   Meskipun langkah-langkahnya sama dengan materi, aplikasikan pertanyaan tersebut menggunakan **dataset** atau **variabel berbeda**. Ini krusial agar mahasiswa tidak sekadar menyalin (copy-paste) kode contoh, melainkan memahami konteksnya.
3. **Bahasa Lugas dan Tidak _Self-Conscious_**:
   Penjelasan harus profesional dan _to the point_. Jangan menghasilkan metakomentar bergaya AI yang seolah "menjelaskan" mengapa dataset tersebut berbeda.
   - **BENAR**: "Lakukan pengujian hipotesis menggunakan dataset `mtcars` untuk variabel `mpg`."
   - **SALAH**: "Karena di materi awal kita sudah menggunakan fungsi ini pada dataset `iris`, untuk latihan ini kita menggunakan dataset yang berbeda yaitu `mtcars` agar kasusnya berbeda."

4. **Penomoran Urut secara Keseluruhan**:
   Selalu perhatikan urutan aktivitas dalam dokumen yang sedang Anda kerjakan. Judul Aktivitas Mandiri harus diimbuhi dengan angka yang berurutan meneruskan aktivitas sebelumnya (contoh: "Aktivitas Mandiri 1", "Aktivitas Mandiri 2", "Aktivitas Mandiri 3", dst). **Jangan mereset penomoran dari angka 1** pada setiap bab atau section.

## Format Markdown untuk `rmdexercise`

### Format Umum

Gunakan format _custom div block_ dari Pandoc/Bookdown Markdown (yaitu `:::` denga class `rmdexercise`) untuk setiap aktivitas.

```markdown
::: rmdexercise

#### Aktivitas Mandiri {n} {.unnumbered}

1. Lakukan [Instruksi langkah pertama].
2. [Instruksi langkah kedua].
3. [Format pertanyaan lainnya].

:::
```

Catatan:

- `{n}` adalah nomor urut aktivitas yang sesuai.
- Level _heading_ (`####` atau `###`) untuk judul "Aktivitas Mandiri" menyesuaikan level heading terakhir dari di mana blok ini di letakkan (disarankan berada selangkah di bawah heading materi, atau menyesuaikan konsistensi file).
- Sertakan parameter `{.unnumbered}` agar tidak muncul sebagai elemen bernomor otomatis pada daftar isi (Daftar Isi Bookdown).

### Format Alternatif

Terkadang instruksi aktivitas tidak harus berbentuk daftar berurut. Anda bisa juga menyajikan instruksi dalam bentuk 1 kalimat tunggal.

```markdown
::: rmdexercise

#### Aktivitas Mandiri {n} {.unnumbered}

Muat dataset ITERA dan UINRIL. Simpan ke dalam variabel `data_itera_2` dan `data_uinril_2`. Jangan lupa mengecek kondisinya menggunakan `glimpse()`
```

## Kunci Jawaban

Tuliskan kunci jawaban menggunakan _code chunk_ di bawah instruksi dengan opsi `include=FALSE`.
