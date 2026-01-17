# AGENTS.md

## Identitas Proyek
Dokumen ini adalah "Panduan Praktikum Statistika dengan R" (Bookdown) untuk mahasiswa S1 Perencanaan Wilayah dan Kota.
Gaya bahasa: Akademis, instruktif, namun ramah untuk pemula. Bahasa Indonesia baku.

## Tech Stack
- **Core:** R Markdown, Bookdown, Knitr.
- **Output:** Gitbook (HTML) dan PDF.
- **Data:** Semua dataset berada di folder `datasets/`.

## Aturan Penulisan & Kode
1. **Kode R:** Gunakan gaya `tidyverse` (piping `|>`) untuk manipulasi data.
2. **Visualisasi:** Wajib menggunakan `ggplot2`. Plot harus memiliki judul (`labs(title=...)`) dan label sumbu yang jelas dalam Bahasa Indonesia.
3. **Callouts:** Gunakan sintaks `::: {.rmdnote}` atau `::: {.rmdtip}` untuk catatan tambahan.
4. **Sitasi:** Gunakan format `@key` untuk referensi. Jangan hardcode nama penulis jika ada di file `.bib`.

## Perintah Terminal (Hanya jika diminta)
- Render buku: `bookdown::render_book("index.Rmd")`
- Cek file: `ls -R` (Jangan gunakan perintah hapus `rm` tanpa izin eksplisit).

## Tugas Utama
Kamu bertugas sebagai asisten editor dan programmer. Fokus pada konsistensi istilah, perbaikan alur antar-bab, dan memastikan kode R berjalan (reproducible).