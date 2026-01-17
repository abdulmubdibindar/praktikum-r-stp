# Panduan Mengubah Nama Project "praktikum-2026" Menjadi "praktikum-r-stp"

Panduan ini akan membantu Anda mengubah nama project BookDown dari `praktikum-2026` menjadi `praktikum-r-stp`. Project ini sudah tersambung dengan GitHub dan memiliki GitHub Pages yang sedang di-publish.

---

## 📋 Ringkasan Perubahan

Berikut adalah komponen yang perlu diubah:

1. ✅ Nama folder/direktori lokal
2. ✅ Nama repository di GitHub
3. ✅ Nama file RStudio Project (`.Rproj`)
4. ✅ Konfigurasi Git remote URL
5. ✅ URL GitHub Pages

---

## 🔧 Langkah-Langkah Pengubahan

### Langkah 1: Backup Project Anda

> [!IMPORTANT]
> Sebelum memulai perubahan apapun, sangat disarankan untuk membuat backup project Anda terlebih dahulu!

**Cara membuat backup:**

1. Tutup RStudio terlebih dahulu
2. Buka File Explorer/Windows Explorer
3. Copy folder `C:\Users\LENOVO\praktikum-2026`
4. Paste di lokasi yang sama dengan nama `praktikum-2026-BACKUP`

---

### Langkah 2: Commit dan Push Semua Perubahan

Sebelum mengubah nama repository, pastikan semua pekerjaan Anda sudah tersimpan di GitHub.

**Langkah-langkah:**

1. Buka RStudio dengan project `praktikum-2026`
2. Buka Terminal di RStudio (Tab: **Tools → Terminal → New Terminal**)
3. Jalankan perintah berikut satu per satu:

```bash
# Cek status file yang belum di-commit
git status

# Tambahkan semua perubahan
git add .

# Commit dengan pesan
git commit -m "Backup sebelum rename project"

# Push ke GitHub
git push origin main
```

> [!NOTE]
> Jika branch utama Anda adalah `master` bukan `main`, gunakan `git push origin master`

---

### Langkah 3: Rename Repository di GitHub

Sekarang kita akan mengubah nama repository di GitHub terlebih dahulu.

**Langkah-langkah:**

1. Buka browser dan login ke **GitHub**
2. Buka repository **praktikum-2026** Anda
3. Klik tab **⚙️ Settings** (di bagian atas repository)
4. Di bagian paling atas, Anda akan menemukan section **Repository name**
5. Ubah nama dari `praktikum-2026` menjadi `praktikum-r-stp`
6. Klik tombol **Rename**

> [!WARNING]
> Setelah rename, URL GitHub Pages Anda akan berubah! URL baru akan menjadi:
>
> - Lama: `https://username.github.io/praktikum-2026/`
> - Baru: `https://username.github.io/praktikum-r-stp/`

GitHub akan otomatis melakukan redirect dari URL lama ke URL baru untuk sementara waktu, tetapi sebaiknya gunakan URL yang baru.

---

### Langkah 4: Update Git Remote URL di Project Lokal

Setelah repository di GitHub berganti nama, kita perlu mengupdate konfigurasi Git di project lokal agar mengarah ke nama repository yang baru.

**Langkah-langkah:**

1. Buka RStudio dengan project `praktikum-2026` (yang masih dengan nama lama)
2. Buka Terminal di RStudio
3. Jalankan perintah berikut:

```bash
# Cek remote URL saat ini
git remote -v

# Update remote URL ke nama baru
git remote set-url origin https://github.com/USERNAME/praktikum-r-stp.git
```

> [!IMPORTANT]
> Ganti `USERNAME` dengan username GitHub Anda yang sebenarnya!

4. Verifikasi perubahan dengan menjalankan:

```bash
git remote -v
```

Anda seharusnya melihat URL baru yang mengarah ke `praktikum-r-stp`.

5. Test koneksi dengan melakukan pull:

```bash
git pull origin main
```

#### 💡 Catatan: Windows Credential Manager

Saat pertama kali melakukan `git pull` atau `git push` setelah mengubah remote URL, Windows mungkin memunculkan **Git Credential Manager** untuk autentikasi.

**Pilihan yang akan muncul:**

1. **Token** (Pilihan yang Disarankan ✅)

   - Pilih opsi ini jika Anda menggunakan GitHub Personal Access Token
   - Anda perlu membuat token di: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**
   - Copy token dan paste saat diminta
   - Token akan disimpan di Windows Credential Manager untuk penggunaan berikutnya

2. **Sign in with your browser**

   - Pilih opsi ini untuk login melalui browser
   - Jendela browser akan terbuka dan Anda login ke akun GitHub
   - Lebih mudah untuk pengguna baru
   - Kredensial akan otomatis tersimpan

3. **Username & Password**
   - ⚠️ **Tidak disarankan!** GitHub sudah tidak mendukung autentikasi password biasa sejak Agustus 2021
   - Jika dipilih, akan muncul error: "Support for password authentication was removed"

> [!TIP] > **Rekomendasi:** Gunakan opsi **"Sign in with your browser"** karena paling mudah dan aman. Setelah berhasil login sekali, Windows akan menyimpan kredensial Anda sehingga tidak perlu login lagi di masa mendatang.

> [!NOTE]
> Jika Anda sudah pernah login sebelumnya, mungkin tidak akan muncul prompt autentikasi karena kredensial sudah tersimpan di Windows Credential Manager.

---

### Langkah 5: Rename Folder Lokal

Sekarang kita akan mengubah nama folder lokal di komputer Anda.

**Langkah-langkah:**

1. **Tutup RStudio** terlebih dahulu (sangat penting!)
2. Buka File Explorer/Windows Explorer
3. Navigate ke folder `C:\Users\LENOVO\`
4. Klik kanan pada folder `praktikum-2026`
5. Pilih **Rename**
6. Ubah nama menjadi `praktikum-r-stp`
7. Tekan **Enter**

---

### Langkah 6: Rename File RStudio Project

File `.Rproj` masih memiliki nama lama. Kita perlu mengubahnya agar konsisten.

**Langkah-langkah:**

1. Buka File Explorer
2. Navigate ke folder `C:\Users\LENOVO\praktikum-r-stp\`
3. Cari file `Praktikum 2026.Rproj`
4. Klik kanan → **Rename**
5. Ubah nama menjadi `Praktikum R-STP.Rproj`
6. Tekan **Enter**

---

### Langkah 7: Buka Project dengan Nama Baru

Sekarang project Anda sudah siap dengan nama baru!

**Langkah-langkah:**

1. Buka File Explorer
2. Navigate ke `C:\Users\LENOVO\praktikum-r-stp\`
3. **Double-click** file `Praktikum R-STP.Rproj`
4. RStudio akan terbuka dengan project yang sudah berganti nama

---

### Langkah 8: Verifikasi Semua Berfungsi

Mari kita pastikan semuanya masih berfungsi dengan baik.

**Test 1: Cek Working Directory**

Jalankan di R Console:

```r
getwd()
```

Harusnya menampilkan: `C:/Users/LENOVO/praktikum-r-stp`

**Test 2: Cek Git Remote**

Buka Terminal dan jalankan:

```bash
git remote -v
```

Harusnya menampilkan URL yang mengarah ke `praktikum-r-stp`

**Test 3: Render Book**

Coba render book Anda:

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

Jika berhasil tanpa error, selamat! 🎉

**Test 4: Push ke GitHub**

Test push perubahan ke GitHub:

```bash
# Tambahkan perubahan nama file .Rproj
git add .
git commit -m "Update project name to praktikum-r-stp"
git push origin main
```

---

### Langkah 9: Update GitHub Pages (Jika Diperlukan)

GitHub Pages seharusnya sudah otomatis beralih mengikuti nama repository baru. Namun, untuk memastikan:

**Langkah-langkah:**

1. Buka repository di GitHub
2. Klik tab **⚙️ Settings**
3. Scroll ke bawah dan klik **Pages** di sidebar kiri
4. Pastikan **Source** masih di-set ke branch yang benar (biasanya `main` atau `gh-pages`) dan folder yang benar (biasanya `/docs`)
5. GitHub akan menampilkan URL baru: `https://username.github.io/praktikum-r-stp/`

> [!TIP]
> Tunggu beberapa menit hingga GitHub Pages selesai melakukan rebuild. Anda bisa melihat statusnya di tab **Actions**.

---

## 📝 Catatan Tambahan

### Jika Anda Bekerja di Multiple Komputer

Jika Anda menggunakan project ini di komputer lain (misalnya laptop dan PC), setelah rename repository di GitHub, lakukan langkah berikut di komputer kedua:

1. Clone ulang repository dengan nama baru:

```bash
cd C:\Users\LENOVO\
git clone https://github.com/USERNAME/praktikum-r-stp.git
```

Atau, jika ingin mempertahankan perubahan lokal:

1. Update remote URL (seperti Langkah 4)
2. Rename folder lokal (seperti Langkah 5)
3. Rename file .Rproj (seperti Langkah 6)

### Jika Ada Bookmark atau Link

Jangan lupa untuk memperbarui:

- ✅ Bookmark browser yang mengarah ke GitHub Pages lama
- ✅ Link di CV atau portfolio Anda
- ✅ Link di README atau dokumentasi lain

---

## ❓ Troubleshooting

### Problem: Git push gagal dengan error "repository not found"

**Solusi:** Remote URL belum diupdate. Ulangi Langkah 4.

### Problem: RStudio tidak bisa membuka project

**Solusi:** Pastikan Anda membuka lewat file `.Rproj`, bukan membuka RStudio dulu baru membuka file.

### Problem: GitHub Pages masih menampilkan halaman lama

**Solusi:**

1. Pastikan Anda sudah push perubahan terbaru
2. Tunggu 5-10 menit untuk GitHub Pages rebuild
3. Clear cache browser Anda (Ctrl + Shift + Delete)

### Problem: Path di kode R tidak berfungsi

**Solusi:** Jika Anda menggunakan relative path (seperti `datasets/data.xlsx`), seharusnya tidak ada masalah. Jika menggunakan absolute path (seperti `C:\Users\LENOVO\praktikum-2026\...`), Anda perlu mengubahnya manual.

---

## ✅ Checklist Akhir

Setelah selesai semua langkah, pastikan:

- [ ] Repository di GitHub sudah bernama `praktikum-r-stp`
- [ ] Folder lokal sudah bernama `praktikum-r-stp`
- [ ] File `.Rproj` sudah bernama `Praktikum R-STP.Rproj`
- [ ] Git remote URL sudah update ke repository baru
- [ ] RStudio bisa membuka project tanpa error
- [ ] `bookdown::render_book()` berjalan sukses
- [ ] Git push berfungsi dengan baik
- [ ] GitHub Pages accessible di URL baru

---

**Selamat! Project Anda sudah berhasil berganti nama!** 🎉

Jika ada pertanyaan atau masalah, jangan ragu untuk menghubungi asisten praktikum atau dosen pengampu.
