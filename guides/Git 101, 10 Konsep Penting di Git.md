# Git 101: 10 Konsep Penting di Git

## Pengantar

Git adalah sistem kontrol versi yang paling banyak digunakan di dunia pengembangan software. Bayangkan Git sebagai **"mesin waktu"** untuk kode Anda - memungkinkan Anda untuk kembali ke versi sebelumnya kapan pun dibutuhkan, dan juga sebagai **"kartu memori"** yang menyimpan setiap langkah perjalanan coding Anda.

Panduan ini akan membahas **10 konsep fundamental** yang harus dikuasai setiap programmer. Konsep-konsep ini disusun secara progresif - setiap konsep membangun fondasi untuk konsep berikutnya. Jangan terintimidasi; setelah Anda memahami alurnya, Git akan menjadi alat paling berharga dalam karir Anda sebagai developer.

Mari kita mulai dari yang paling dasar!

---

## 1. Repository (Repo) - Wadah Proyek Anda

### 📖 Definisi

**Repository** (sering disingkat "repo") adalah wadah atau folder tempat Git melacak semua file dan riwayat perubahannya. Repository adalah rumah di mana seluruh sejarah proyek Anda tinggal.

Ada dua jenis repository:

- **Local Repository**: Repository yang ada di komputer Anda
- **Remote Repository**: Repository yang disimpan di server online (seperti GitHub, GitLab, atau Bitbucket)

### 🎯 Mengapa Konsep Ini Penting?

Repository adalah **fondasi utama** dari seluruh sistem Git. Tanpa menginisialisasi folder sebagai repository, Git tidak akan melacak apa pun. Ini adalah langkah pertama yang mutlak harus dilakukan sebelum Anda bisa menggunakan fitur Git lainnya.

### 💻 Perintah Terkait

```bash
# Membuat repository baru di folder yang sudah ada
git init

# Melihat konfigurasi repository
git config --list
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda baru memulai proyek website bernama `toko-online`.

```bash
# 1. Buat folder proyek
mkdir toko-online
cd toko-online

# 2. Inisialisasi sebagai Git repository
git init

# Output:
# Initialized empty Git repository in /path/to/toko-online/.git/
```

Setelah menjalankan `git init`, folder `toko-online` Anda sekarang resmi menjadi Git repository. Git membuat folder tersembunyi `.git` yang menyimpan semua data tracking.

### 🔑 Poin Penting

- ✅ Setiap proyek membutuhkan satu repository
- ✅ Folder `.git` jangan dihapus (semua history ada di sana)
- ✅ Satu repository untuk satu proyek (jangan campur beberapa proyek dalam satu repo)

---

## 2. Working Directory & Staging Area - Ruang Kerja dan Ruang Tunggu

### 📖 Definisi

**Working Directory** adalah tempat Anda aktif mengedit file. Ini adalah folder proyek Anda yang bisa Anda lihat dan edit dengan text editor atau IDE.

**Staging Area** (juga disebut "Index") adalah ruang tunggu sementara tempat Anda memilih perubahan mana yang siap untuk disimpan secara permanen. Bayangkan seperti **keranjang belanja** sebelum checkout - Anda bisa menambah atau mengurangi item sebelum membayar.

### 🎯 Mengapa Konsep Ini Penting?

Staging Area memberi Anda **kontrol granular**. Anda bisa mengedit 10 file sekaligus, tetapi memilih hanya 3 file untuk disimpan dalam satu waktu. Ini memungkinkan Anda memisahkan perubahan yang tidak berhubungan menjadi commit-commit yang terorganisir dengan baik.

### 💻 Perintah Terkait

```bash
# Menambahkan file tertentu ke staging area
git add nama_file.txt

# Menambahkan semua file yang berubah
git add .

# Menambahkan semua file dengan ekstensi tertentu
git add *.js

# Menghapus file dari staging area (unstage)
git reset nama_file.txt
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda mengedit file `header.html` dan `footer.html`, tetapi hanya ingin menyimpan perubahan header terlebih dahulu.

```bash
# 1. Edit file header.html dan footer.html
# ... (edit dengan text editor)

# 2. Cek status file
git status
# Output:
# Changes not staged for commit:
#   modified:   header.html
#   modified:   footer.html

# 3. Hanya add header.html ke staging area
git add header.html

# 4. Cek status lagi
git status
# Output:
# Changes to be committed:
#   modified:   header.html
# Changes not staged for commit:
#   modified:   footer.html
```

Sekarang `header.html` sudah di staging area (siap di-commit), sementara `footer.html` masih di working directory.

### � Tips Pro: Variasi `git add`

Bagaimana jika Anda ingin lebih spesifik?

1.  **Hanya file yang sudah dilacak (Modified & Deleted):**
    Gunakan opsi `-u` (update). Ini akan men-stage file yang diedit dan dihapus, tapi **mengabaikan file baru** (untracked).

    ```bash
    git add -u
    ```

2.  **Memilih bagian tertentu dalam file (Patch):**
    Gunakan opsi `-p` (patch). Git akan menampilkan setiap blok perubahan (hunk) dan bertanya apakah Anda ingin men-stage perubahan tersebut atau tidak (`y/n`). Sangat berguna untuk review codingan sendiri dalam file yang sama!
    ```bash
    git add -p
    ```

### �🔑 Poin Penting

- ✅ Working Directory = tempat kerja Anda
- ✅ Staging Area = seleksi perubahan yang akan disimpan
- ✅ Gunakan `git add` secara selektif untuk commit yang lebih terorganisir

### 📊 Diagram Alur

```
Working Directory  →  Staging Area  →  Repository
(Edit files)        (git add)        (git commit)
```

---

## 3. Commit (Snapshot) - Checkpoint Kode Anda

### 📖 Definisi

**Commit** adalah proses menyimpan perubahan secara permanen ke dalam riwayat repository. Ini seperti **save point** atau **checkpoint** dalam video game yang bisa Anda kembali kapan saja.

Setiap commit memiliki:

- **Hash ID unik** (contoh: `a3f2b1c`)
- **Pesan deskriptif** yang menjelaskan apa yang berubah
- **Timestamp** kapan commit dibuat
- **Author** siapa yang membuat commit

### 🎯 Mengapa Konsep Ini Penting?

Commit adalah inti dari version control. Jika Anda membuat kesalahan fatal di masa depan, Anda bisa kembali ke checkpoint (commit) sebelumnya tanpa kehilangan progres lain. Commit juga membantu tim memahami **siapa mengubah apa, kapan, dan mengapa**.

### 💻 Perintah Terkait

```bash
# Commit dengan pesan singkat
git commit -m "Pesan perubahan"

# Commit dengan pesan multi-baris (akan buka editor)
git commit

# Commit dan sekaligus add semua file yang sudah tracked
git commit -am "Pesan perubahan"

# Melihat detail sebuah commit
git show <hash_commit>
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda telah memperbaiki bug login dan ingin menyimpan perubahan ini.

```bash
# 1. Add file yang sudah diperbaiki
git add login.js

# 2. Commit dengan pesan yang jelas
git commit -m "Memperbaiki bug login: validasi email tidak case-sensitive"

# Output:
# [main a3f2b1c] Memperbaiki bug login: validasi email tidak case-sensitive
#  1 file changed, 3 insertions(+), 1 deletion(-)
```

**Commit berhasil!** Perubahan Anda sekarang tersimpan dengan ID `a3f2b1c`.

### 🔑 Poin Penting - Best Practices Pesan Commit

✅ **BAIK** - Jelas dan deskriptif:

- `"Menambahkan fitur filter produk berdasarkan kategori"`
- `"Memperbaiki crash saat upload gambar > 5MB"`
- `"Refactor fungsi calculateTotal untuk efisiensi"`

❌ **BURUK** - Tidak informatif:

- `"Update"` ← Update apa?
- `"Fix bug"` ← Bug apa?
- `"asdfasdf"` ← ???

### 📊 Anatomi Commit

```
Commit ID:   a3f2b1c9d8e7f6a5b4c3d2e1
Author:      Abdul Mubdi <mubdi@example.com>
Date:        Mon Feb 10 22:30:15 2026 +0700
Message:     Memperbaiki bug login: validasi email tidak case-sensitive

Changes:
  login.js | 4 ++--
  1 file changed, 3 insertions(+), 1 deletion(-)
```

---

## 4. Git Status & Log - Mata dan Telinga Anda

### 📖 Definisi

**`git status`** memberitahu Anda keadaan file saat ini:

- File mana yang sudah di-stage
- File mana yang dimodifikasi tapi belum di-stage
- File mana yang belum dilacak (untracked)

**`git log`** adalah daftar riwayat semua commit yang pernah terjadi, seperti buku harian proyek Anda.

### 🎯 Mengapa Konsep Ini Penting?

Anda **tidak boleh bekerja "buta"**. Sebelum commit, Anda perlu tahu file mana yang berubah untuk menghindari commit file sampah (seperti file log error atau file sementara). Dengan `git log`, Anda bisa melihat apa yang telah dilakukan tim sebelumnya dan belajar dari sejarah proyek.

### 💻 Perintah Terkait

```bash
# Melihat status file saat ini
git status

# Melihat status dalam format singkat
git status -s

# Melihat history commit
git log

# Melihat log dalam satu baris per commit
git log --oneline

# Melihat log dengan grafik branch
git log --oneline --graph --all

# Melihat log untuk file tertentu
git log nama_file.txt

# Melihat siapa yang mengubah setiap baris
git blame nama_file.txt
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Sebelum commit, Anda ingin memastikan tidak ada file sampah yang ikut ter-stage.

```bash
# 1. Cek status terlebih dahulu
git status

# Output:
# On branch main
# Changes to be committed:
#   modified:   index.html
#   new file:   styles.css
#
# Untracked files:
#   debug.log        ← File sampah!
#   node_modules/    ← Folder besar yang tidak perlu!
```

Dari output ini, Anda tahu bahwa `debug.log` dan `node_modules/` tidak boleh di-commit. Anda bisa membuat file `.gitignore` untuk mengabaikan mereka.

**Contoh `git log`:**

```bash
git log --oneline

# Output:
# a3f2b1c Memperbaiki bug login: validasi email tidak case-sensitive
# b5c6d7e Menambahkan fitur filter produk
# c8d9e0f Initial commit: struktur dasar website
```

### 🔑 Poin Penting

- ✅ Selalu jalankan `git status` sebelum `git add` dan `git commit`
- ✅ Gunakan `git log --oneline` untuk quick overview
- ✅ Gunakan `git log --graph` untuk visualisasi branch

### 📊 Status File dalam Git

```
Untracked  →  Modified  →  Staged  →  Committed
   ↓           ↓            ↓           ↓
(Baru)     (Berubah)   (git add)  (git commit)
```

---

## 5. Branching (Percabangan) - Jalur Pengembangan Paralel

### 📖 Definisi

**Branch** adalah garis waktu pengembangan yang terpisah. Bayangkan seperti **multiverse** - Anda bisa membuat realitas alternatif untuk eksperimen, dan jika berhasil, gabungkan dengan realitas utama.

Branch utama biasanya bernama `main` atau `master`, yang merupakan kode produksi. Anda bisa membuat branch baru untuk fitur baru, perbaikan bug, atau eksperimen tanpa mengganggu kode utama.

### 🎯 Mengapa Konsep Ini Penting?

Branching memungkinkan **banyak orang bekerja secara bersamaan** pada fitur berbeda tanpa saling merusak kode satu sama lain. Ini adalah fondasi dari kolaborasi modern dalam tim development.

### 💻 Perintah Terkait

```bash
# Melihat semua branch
git branch

# Melihat branch dengan info tambahan
git branch -v

# Membuat branch baru
git branch nama-branch

# Pindah ke branch lain
git checkout nama-branch

# Membuat branch baru DAN langsung pindah ke sana (shortcut)
git checkout -b nama-branch

# Versi modern (Git 2.23+)
git switch nama-branch
git switch -c nama-branch  # create and switch

# Menghapus branch
git branch -d nama-branch
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda ingin menambahkan fitur "Dark Mode" tanpa merusak kode utama.

```bash
# 1. Cek branch saat ini
git branch
# * main

# 2. Buat branch baru untuk fitur dark mode
git checkout -b fitur-dark-mode

# Output:
# Switched to a new branch 'fitur-dark-mode'

# 3. Cek branch lagi
git branch
#   main
# * fitur-dark-mode    ← tanda * menunjukkan branch aktif

# 4. Mulai coding fitur dark mode
# ... edit files ...

# 5. Commit di branch fitur-dark-mode
git add styles.css
git commit -m "Menambahkan toggle dark mode"

# 6. Pindah kembali ke main
git checkout main
# Kode dark mode tidak terlihat di sini - aman!
```

### 🔑 Poin Penting

- ✅ Selalu buat branch baru untuk fitur atau bug fix
- ✅ Jangan bekerja langsung di `main` (kecuali untuk perubahan kecil)
- ✅ Gunakan naming convention yang jelas:
  - `fitur/nama-fitur`
  - `bugfix/nama-bug`
  - `hotfix/nama-urgent`

### 📊 Visualisasi Branching

```
main:     A --- B --- C
                   \
fitur-dark-mode:    D --- E
```

Commit A, B, C ada di `main`. Commit D dan E ada di branch `fitur-dark-mode`.

---

## 6. Merging (Penggabungan) - Menyatukan Kembali

### 📖 Definisi

**Merging** adalah proses menggabungkan perubahan dari satu branch ke branch lain. Biasanya digunakan untuk menggabungkan branch fitur kembali ke branch `main` setelah fitur tersebut selesai dan teruji.

### 🎯 Mengapa Konsep Ini Penting?

Setelah fitur di branch terpisah selesai dikembangkan dan teruji, kode tersebut harus **disatukan kembali** agar menjadi bagian dari produk akhir. Tanpa merge, pekerjaan di branch terpisah tidak akan pernah sampai ke pengguna.

### 💻 Perintah Terkait

```bash
# Merge branch lain ke branch saat ini
git merge nama-branch

# Merge dengan menambahkan commit message
git merge nama-branch -m "Menggabungkan fitur dark mode"

# Melihat branch yang sudah di-merge
git branch --merged

# Melihat branch yang belum di-merge
git branch --no-merged

# Membatalkan merge yang sedang berlangsung
git merge --abort
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Fitur "Dark Mode" sudah selesai dan Anda ingin menggabungkannya ke `main`.

```bash
# 1. Pastikan di branch fitur semua sudah di-commit
git checkout fitur-dark-mode
git status  # Pastikan clean

# 2. Pindah ke branch main
git checkout main

# 3. Merge branch fitur-dark-mode ke main
git merge fitur-dark-mode

# Output (jika tidak ada konflik):
# Updating c8d9e0f..a5b6c7d
# Fast-forward
#  styles.css     | 25 +++++++++++++++++++++++++
#  index.html     |  5 +++--
#  2 files changed, 28 insertions(+), 2 deletions(-)

# 4. Hapus branch fitur yang sudah tidak diperlukan (opsional)
git branch -d fitur-dark-mode
```

### 🔑 Poin Penting

- ✅ Selalu merge **ke** branch tujuan (checkout dulu ke branch tujuan)
- ✅ Test fitur di branch fitur sebelum merge
- ✅ Hapus branch fitur setelah sukses di-merge untuk kebersihan

### 📊 Visualisasi Merge

**Sebelum Merge:**

```
main:             A --- B --- C
                           \
fitur-dark-mode:            D --- E
```

**Setelah Merge (Fast-Forward):**

```
main:             A --- B --- C --- D --- E
```

**Setelah Merge (3-Way Merge dengan Merge Commit):**

```
main:             A --- B --- C ------- M
                           \         /
fitur-dark-mode:            D ----- E
```

---

## 7. Remote Repository (GitHub) - Rumah di Cloud

### 📖 Definisi

**Remote Repository** adalah versi proyek Anda yang disimpan di server internet, seperti GitHub, GitLab, atau Bitbucket.

Perbedaan sederhana:

- **Git** = Alat (software) untuk version control
- **GitHub** = Platform layanan (tempat menyimpan repository di cloud)

Analogi: Git adalah kopi, GitHub adalah kedai kopi.

### 🎯 Mengapa Konsep Ini Penting?

Remote repository berfungsi sebagai:

1. **Backup** - Jika laptop Anda rusak atau hilang, kode tetap aman di cloud
2. **Pusat Kolaborasi** - Tim bisa mengakses kode yang sama dari mana saja
3. **Portfolio** - GitHub public repo bisa menjadi showcase karya Anda untuk calon employer

### 💻 Perintah Terkait

```bash
# Menambahkan remote repository (biasanya bernama 'origin')
git remote add origin https://github.com/username/repo.git

# Melihat daftar remote
git remote -v

# Mengirim commit lokal ke remote (push)
git push origin main

# Mengambil commit dari remote (pull)
git pull origin main

# Mengambil info remote tanpa merge (fetch)
git fetch origin

# Mengubah URL remote
git remote set-url origin https://github.com/username/new-repo.git

# Menghapus remote
git remote remove origin
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda sudah membuat repository lokal dan ingin meng-upload ke GitHub.

```bash
# 1. Buat repository baru di GitHub (lewat web interface)
#    Nama: toko-online
#    Dapatkan URL: https://github.com/username/toko-online.git

# 2. Hubungkan repository lokal dengan GitHub
git remote add origin https://github.com/username/toko-online.git

# 3. Cek apakah sudah terhubung
git remote -v
# Output:
# origin  https://github.com/username/toko-online.git (fetch)
# origin  https://github.com/username/toko-online.git (push)

# 4. Push commit lokal ke GitHub
git push -u origin main

# Output:
# Enumerating objects: 10, done.
# Counting objects: 100% (10/10), done.
# ...
# To https://github.com/username/toko-online.git
#  * [new branch]      main -> main
```

**Kode Anda sekarang aman di cloud!** ☁️

### 🔑 Poin Penting

- ✅ `origin` adalah nama konvensi untuk remote utama
- ✅ `-u` dalam `git push -u origin main` men-set upstream (default remote untuk push/pull)
- ✅ Setelah set upstream, cukup ketik `git push` tanpa parameter tambahan

### 📊 Local vs Remote

```
[Local Repository]  ⟷  [Remote Repository (GitHub)]
(Di Laptop Anda)        (Di Cloud Server)
     git push  →
     ← git pull
```

---

## 8. Cloning - Salin Repository dari Remote

### 📖 Definisi

**Cloning** adalah mengunduh salinan lengkap repository dari remote (seperti GitHub) ke komputer Anda. Anda mendapatkan **semua file, semua commit history, dan semua branch** dalam satu perintah.

### 🎯 Mengapa Konsep Ini Penting?

Cloning adalah **langkah pertama** saat:

- Anda baru bergabung dengan tim dan ingin mulai kerja
- Anda ingin berkontribusi pada proyek open source
- Anda pindah ke laptop baru dan perlu download proyek Anda

### 💻 Perintah Terkait

```bash
# Clone repository
git clone https://github.com/username/repo.git

# Clone ke folder dengan nama berbeda
git clone https://github.com/username/repo.git nama-folder-baru

# Clone hanya branch tertentu
git clone -b nama-branch https://github.com/username/repo.git

# Clone dengan depth terbatas (tidak semua history, lebih cepat)
git clone --depth 1 https://github.com/username/repo.git
```

### ✅ Contoh Penggunaan Praktis

**Skenario 1: Anda beli laptop baru dan ingin melanjutkan pekerjaan.**

```bash
# 1. Clone repository dari GitHub
git clone https://github.com/username/toko-online.git

# Output:
# Cloning into 'toko-online'...
# remote: Enumerating objects: 50, done.
# remote: Counting objects: 100% (50/50), done.
# ...
# Receiving objects: 100% (50/50), done.

# 2. Masuk ke folder yang baru di-clone
cd toko-online

# 3. Lanjutkan coding!
```

**Skenario 2: Anda ingin berkontribusi pada proyek open source.**

```bash
# Clone repository proyek open source
git clone https://github.com/original-author/awesome-project.git

cd awesome-project

# Buat branch untuk fitur Anda
git checkout -b fitur-saya

# ... edit code ...
git add .
git commit -m "Menambahkan fitur X"

# Push ke fork Anda sendiri (akan dijelaskan di konsep Pull Request)
```

### 🔑 Poin Penting

- ✅ `git clone` otomatis membuat folder baru dengan nama repository
- ✅ Remote `origin` otomatis ter-setup ke URL yang di-clone
- ✅ Semua branch dari remote akan ter-download (cek dengan `git branch -r`)

### 📊 Proses Cloning

```
GitHub Repository
       ↓
   git clone
       ↓
Local Repository (Salinan Lengkap)
```

---

## 9. Pull Request (PR) - Permintaan untuk Menggabungkan

### 📖 Definisi

**Pull Request** (PR) adalah permintaan untuk menggabungkan kode Anda ke branch utama di GitHub. Ini memberi kesempatan bagi tim untuk **meninjau (code review)** kode Anda sebelum diterima ke dalam proyek.

Pull Request adalah fitur **GitHub** (dan platform serupa), bukan fitur Git itu sendiri.

### 🎯 Mengapa Konsep Ini Penting?

Pull Request menjaga **kualitas kode**. Tim bisa:

- Melihat **apa yang berubah** (diff)
- Memberi **komentar** jika ada masalah atau saran perbaikan
- Melakukan **diskusi** tentang implementasi
- Memastikan kode **tidak merusak** yang sudah ada

Ini mencegah kode yang buruk atau buggy masuk ke production.

### 💻 Perintah Terkait

Pull Request dilakukan melalui **antarmuka web GitHub**, bukan command line. Namun workflow Git-nya:

```bash
# 1. Buat branch fitur
git checkout -b fitur-baru

# 2. Commit perubahan
git add .
git commit -m "Implementasi fitur baru"

# 3. Push branch ke GitHub
git push origin fitur-baru
```

Setelah itu, lanjutkan di web GitHub untuk membuat Pull Request.

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda membuat fitur "Dark Mode" dan ingin tim review sebelum merge ke `main`.

**Langkah di Terminal:**

```bash
# 1. Pastikan di branch fitur
git checkout fitur-dark-mode

# 2. Push branch fitur ke GitHub
git push origin fitur-dark-mode

# Output:
# ...
# To https://github.com/username/toko-online.git
#  * [new branch]      fitur-dark-mode -> fitur-dark-mode
```

**Langkah di GitHub (Web Interface):**

1. Buka repository di GitHub
2. GitHub akan otomatis mendeteksi branch baru dan menampilkan tombol **"Compare & pull request"**
3. Klik tombol tersebut
4. Isi detail Pull Request:
   - **Title**: "Menambahkan fitur Dark Mode"
   - **Description**: Penjelasan detail apa yang berubah
5. Klik **"Create pull request"**

**Tim akan menerima notifikasi** dan bisa review kode Anda, beri komentar, atau approve.

### 🔑 Poin Penting

- ✅ Selalu buat PR dari branch fitur, bukan dari `main`
- ✅ Tulis deskripsi PR yang jelas dan lengkap
- ✅ Link ke issue atau ticket terkait jika ada
- ✅ Screenshot untuk perubahan UI
- ✅ Terima feedback dengan lapang dada - ini untuk pembelajaran!

### 📊 Workflow Pull Request

```
1. Create Branch       → fitur-dark-mode
2. Make Changes        → edit code
3. Commit              → git commit
4. Push to GitHub      → git push origin fitur-dark-mode
5. Create PR           → (via GitHub web)
6. Code Review         → Tim memberi feedback
7. Revise (jika perlu) → commit lagi di branch yang sama
8. Approve & Merge     → PR di-merge ke main
9. Delete Branch       → fitur-dark-mode dihapus
```

---

## 10. Merge Conflicts (Konflik) - Saat Git Bingung

### 📖 Definisi

**Merge Conflict** adalah situasi di mana Git **bingung** karena ada dua orang mengubah **baris yang sama** pada file yang sama secara berbeda. Git tidak tahu versi mana yang harus disimpan, sehingga meminta Anda memutuskan secara manual.

### 🎯 Mengapa Konsep Ini Penting?

Konflik **pasti terjadi** dalam kerja tim, terutama dalam proyek besar. Jangan panik saat melihat konflik! Ini adalah bagian normal dari kolaborasi. Yang penting adalah Anda tahu **cara menyelesaikannya dengan benar**.

### 💻 Perintah Terkait

```bash
# Melihat file yang konflik
git status

# Membatalkan merge yang sedang konflik
git merge --abort

# Setelah resolve konflik, lanjutkan merge
git add file-yang-konflik.txt
git commit

# Untuk rebase, setelah resolve
git add file-yang-konflik.txt
git rebase --continue

# Melihat konflik dalam bentuk diff
git diff
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda dan Budi sama-sama mengubah file `header.html` di baris yang sama.

**Langkah 1: Konflik Terjadi**

```bash
git merge fitur-budi

# Output:
# Auto-merging header.html
# CONFLICT (content): Merge conflict in header.html
# Automatic merge failed; fix conflicts and then commit the result.
```

**Langkah 2: Buka File yang Konflik**

File `header.html` akan terlihat seperti ini:

```html
<header>
  <<<<<<< HEAD
  <h1>Selamat Datang di Toko Saya</h1>
  =======
  <h1>Halo! Selamat Berbelanja</h1>
  >>>>>>> fitur-budi
</header>
```

**Penjelasan Marker:**

- `<<<<<<< HEAD` = Kode versi Anda (branch saat ini)
- `=======` = Pemisah
- `>>>>>>> fitur-budi` = Kode versi Budi

**Langkah 3: Pilih Versi yang Benar**

Anda punya tiga pilihan:

**Opsi A: Gunakan versi Anda**

```html
<header>
  <h1>Selamat Datang di Toko Saya</h1>
</header>
```

**Opsi B: Gunakan versi Budi**

```html
<header>
  <h1>Halo! Selamat Berbelanja</h1>
</header>
```

**Opsi C: Gabungkan atau tulis ulang**

```html
<header>
  <h1>Selamat Datang! Halo, Selamat Berbelanja</h1>
</header>
```

**Langkah 4: Hapus Marker Konflik**

Pastikan Anda menghapus semua marker (`<<<<<<<`, `=======`, `>>>>>>>`).

**Langkah 5: Stage dan Commit**

```bash
# Stage file yang sudah di-resolve
git add header.html

# Commit hasil resolve
git commit -m "Menyelesaikan konflik pada header.html"

# Output:
# [main abc123] Menyelesaikan konflik pada header.html
```

**Konflik selesai!** ✅

### 🔑 Poin Penting - Cara Menghindari Konflik

- ✅ **Pull sering** - Selalu `git pull` sebelum mulai kerja baru
- ✅ **Komunikasi tim** - Koordinasikan siapa mengerjakan file mana
- ✅ **Modularisasi kode** - Pecah file besar menjadi komponen kecil
- ✅ **Commit kecil dan sering** - Jangan tumpuk banyak perubahan dalam satu commit
- ✅ **Pakai linter** - Tool seperti Prettier/ESLint untuk formatting konsisten

### 📊 Visualisasi Konflik

```
main:        A --- B --- C (Anda edit line 5)
                      \
fitur-budi:            D (Budi edit line 5)

Saat merge: Git bingung - line 5 punya 2 versi berbeda!

Setelah resolve:
main:        A --- B --- C --- M (merge commit)
                      \       /
fitur-budi:            D ----
```

---

## Kesimpulan

Selamat! Anda telah mempelajari **10 konsep fundamental Git** yang akan menjadi fondasi karir Anda sebagai developer. Mari kita recap:

### 📚 Ringkasan 10 Konsep

1. **Repository** - Wadah proyek Anda (`git init`)
2. **Working Directory & Staging Area** - Ruang kerja dan seleksi (`git add`)
3. **Commit** - Checkpoint kode (`git commit`)
4. **Status & Log** - Mata dan telinga Anda (`git status`, `git log`)
5. **Branching** - Jalur pengembangan paralel (`git branch`, `git checkout`)
6. **Merging** - Menggabungkan branch (`git merge`)
7. **Remote Repository** - Rumah di cloud (`git push`, `git pull`)
8. **Cloning** - Salin dari remote (`git clone`)
9. **Pull Request** - Review sebelum merge (via GitHub)
10. **Merge Conflicts** - Menyelesaikan perbedaan (manual editing)

### 🎯 Alur Kerja Harian dengan Git

Berikut workflow standar yang akan Anda gunakan setiap hari:

```bash
# Pagi hari - Mulai kerja
git pull origin main                    # Update kode terbaru

# Membuat fitur baru
git checkout -b fitur-payment          # Buat branch fitur
# ... edit code ...
git add .                              # Stage perubahan
git commit -m "Implementasi payment"   # Commit

# Push ke GitHub
git push origin fitur-payment          # Upload ke remote

# Buat Pull Request di GitHub (web interface)
# Tim review → Approve → Merge

# Clean up
git checkout main                      # Kembali ke main
git pull origin main                   # Update dengan kode yang sudah di-merge
git branch -d fitur-payment           # Hapus branch lokal
```

### 🚀 Langkah Selanjutnya

Setelah menguasai 10 konsep ini, Anda bisa mempelajari topik lanjutan:

- **Git Stash** - Menyimpan perubahan sementara tanpa commit
- **Cherry Pick** - Mengambil commit tertentu dari branch lain
- **Interactive Rebase** - Mengubah history commit
- **Git Hooks** - Otomasi script sebelum/sesudah perintah Git
- **Git Submodules** - Mengelola repository dalam repository
- **Git Tags** - Menandai versi rilis (v1.0, v2.0)
- **Forking Workflow** - Kontribusi pada proyek open source
- **GitFlow** - Branching strategy untuk tim besar

### 💡 Tips Terakhir

1. **Latihan adalah kunci** - Buat repository dummy dan eksperimen
2. **Error itu wajar** - Baca pesan error, hampir selalu ada solusinya
3. **Jangan takut bertanya** - Komunitas Git sangat supportive
4. **Dokumentasikan workflow tim** - Setiap tim punya cara berbeda
5. **Backup sebelum eksperimen** - `git branch backup-experiment`

### 📖 Resources Tambahan

- [Git Official Documentation](https://git-scm.com/doc)
- [GitHub Learning Lab](https://lab.github.com/)
- [Oh My Git!](https://ohmygit.org/) - Game untuk belajar Git
- [Visualizing Git](https://git-school.github.io/visualizing-git/) - Visualisasi interaktif

---

## Penutup

Git mungkin terasa overwhelming di awal, tapi ingat: **setiap expert pernah menjadi pemula**. Yang membedakan adalah konsistensi dalam belajar dan latihan.

Mulai dengan konsep 1-4 terlebih dahulu, lalu bertahap ke konsep 5-10. Dalam beberapa minggu, Git akan menjadi **second nature** bagi Anda.

> "Jangan takut membuat kesalahan. Git ada untuk melindungi Anda dari kesalahan. Takutlah untuk TIDAK menggunakan Git!"

Selamat belajar dan selamat coding! 🚀💻

---

**Catatan:** Panduan ini adalah titik awal. Git memiliki banyak fitur advanced, tapi 10 konsep ini sudah cukup untuk 90% pekerjaan sehari-hari Anda sebagai developer profesional.
