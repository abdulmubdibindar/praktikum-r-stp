# Git 102: Langkah Selanjutnya setelah Git 101

## Pengantar

Selamat! Jika Anda sudah membaca [Git 101](./Git%20101,%2010%20Konsep%20Penting%20di%20Git.md) dan berlatih 10 konsep dasarnya, Anda sudah memiliki fondasi yang kuat. Anda bisa membuat repository, melakukan commit, bekerja dengan branch, berkolaborasi via GitHub, dan menyelesaikan konflik.

Tapi dunia Git jauh lebih dalam dari itu. Panduan ini membahas **8 topik lanjutan** yang akan membawa Anda dari level *pemula yang percaya diri* ke level *developer profesional*. Topik-topik ini bukan sekadar trik tambahan — mereka benar-benar mengubah cara Anda bekerja sehari-hari.

> 💡 **Prasyarat:** Pastikan Anda sudah nyaman dengan konsep di Git 101 sebelum melanjutkan ke sini. Topik-topik berikut mengasumsikan Anda sudah memahami commit, branch, merge, remote, dan pull request.

Mari mulai!

---

## 1. Git Stash — Laci Penyimpanan Sementara

### 📖 Definisi

**Git Stash** adalah fitur untuk **menyimpan perubahan sementara** yang belum siap di-commit, lalu bisa dipulihkan kapan saja. Bayangkan seperti **laci meja kerja** — Anda taruh dulu pekerjaan yang sedang setengah jalan, beralih ke urusan lain, lalu buka laci dan lanjutkan pekerjaan semula.

### 🎯 Mengapa Konsep Ini Penting?

Skenario klasik: Anda sedang asyik mengerjakan fitur baru, lalu tiba-tiba atasan meminta Anda memperbaiki bug kritis di branch `main`. Masalahnya, pekerjaan Anda belum selesai dan belum layak di-commit. Git Stash adalah solusinya — simpan dulu, tangani bug, lalu kembali.

### 💻 Perintah Terkait

```bash
# Simpan perubahan saat ini ke stash
git stash

# Simpan dengan pesan deskriptif
git stash push -m "WIP: fitur keranjang belanja"

# Lihat semua stash yang tersimpan
git stash list

# Pulihkan stash terbaru (dan hapus dari daftar stash)
git stash pop

# Pulihkan stash tertentu (indeks dimulai dari 0)
git stash apply stash@{2}

# Hapus satu stash tertentu
git stash drop stash@{0}

# Hapus semua stash sekaligus
git stash clear

# Lihat isi stash tanpa menerapkannya
git stash show -p stash@{0}
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda sedang mengerjakan fitur checkout, tapi ada bug kritis di halaman login yang harus segera diperbaiki.

```bash
# Kondisi: sedang di branch fitur/checkout, ada file yang belum di-commit
git status
# On branch fitur/checkout
# Changes not staged for commit:
#   modified: checkout.js
#   modified: cart.js

# Langkah 1: Simpan pekerjaan ke stash
git stash push -m "WIP: implementasi logika checkout"

# Langkah 2: Pindah ke main dan buat branch bugfix
git checkout main
git checkout -b bugfix/login-crash

# Langkah 3: Perbaiki bug, commit, push
git add login.js
git commit -m "Memperbaiki crash saat login dengan email khusus"
git push origin bugfix/login-crash

# Langkah 4: Kembali ke pekerjaan semula
git checkout fitur/checkout

# Langkah 5: Pulihkan stash
git stash pop

# Kerja dilanjutkan! Semua file kembali seperti semula.
git status
# On branch fitur/checkout
# Changes not staged for commit:
#   modified: checkout.js
#   modified: cart.js
```

### 🔑 Poin Penting

- ✅ `git stash pop` = pulihkan + hapus dari daftar stash
- ✅ `git stash apply` = pulihkan tapi tetap ada di daftar stash (aman untuk dicoba di beberapa tempat)
- ✅ Beri nama stash yang deskriptif agar mudah diidentifikasi jika Anda punya banyak stash
- ⚠️ File *untracked* (baru dibuat, belum pernah `git add`) tidak otomatis ikut di-stash — gunakan `git stash -u` untuk menyertakannya

### 📊 Alur Stash

```
Perubahan di Working Directory
        ↓ git stash
    [Laci Stash]
        ↓ git stash pop
Perubahan kembali ke Working Directory
```

---

## 2. Cherry Pick — Mengambil Commit Terpilih

### 📖 Definisi

**Cherry Pick** adalah perintah untuk **mengambil satu commit tertentu dari branch lain** dan menerapkannya ke branch Anda saat ini — tanpa harus merge seluruh branch tersebut. Persis seperti memilih buah di pohon: "Saya mau commits ini saja, yang lain tidak."

### 🎯 Mengapa Konsep Ini Penting?

Terkadang rekan tim Anda membuat 10 commit di branch mereka, tapi Anda hanya butuh 1 atau 2 commit saja — misalnya, perbaikan bug kecil yang juga relevan untuk branch Anda. Cherry pick memungkinkan Anda mengambil yang dibutuhkan tanpa membawa "bagasi" lainnya.

### 💻 Perintah Terkait

```bash
# Ambil satu commit ke branch saat ini
git cherry-pick <hash-commit>

# Ambil beberapa commit sekaligus
git cherry-pick <hash1> <hash2> <hash3>

# Ambil range commit (a tidak termasuk, b termasuk)
git cherry-pick a..b

# Cherry-pick tanpa langsung commit (bisa diedit dulu)
git cherry-pick --no-commit <hash-commit>

# Batalkan cherry-pick yang sedang berlangsung
git cherry-pick --abort

# Lanjutkan cherry-pick setelah resolve konflik
git cherry-pick --continue
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Rekan Anda mengerjakan `branch-budi` dan di sana ada perbaikan bug validasi form yang juga dibutuhkan di branch `main`. Tapi branch Budi belum selesai dan belum siap di-merge sepenuhnya.

```bash
# Langkah 1: Lihat commit di branch Budi
git log branch-budi --oneline
# f7a3b2c Memperbaiki validasi form email  ← ini yang dibutuhkan!
# e2d1a0b WIP: menambah fitur export PDF
# c9b8a7d WIP: redesign halaman profil

# Langkah 2: Pindah ke branch tujuan
git checkout main

# Langkah 3: Cherry-pick hanya commit perbaikan bug
git cherry-pick f7a3b2c

# Output:
# [main 3e4f5a6] Memperbaiki validasi form email
#  1 file changed, 5 insertions(+), 2 deletions(-)
```

Perbaikan bug sekarang ada di `main`, tanpa membawa pekerjaan Budi yang masih WIP!

### 🔑 Poin Penting

- ✅ Gunakan `git log --oneline` dulu untuk menemukan hash commit yang tepat
- ✅ Cherry pick membuat commit **baru** dengan hash berbeda, meskipun isinya sama
- ⚠️ Jangan cherry-pick terlalu banyak — jika kebutuhan lebih dari 3-4 commit, pertimbangkan merge biasa
- ⚠️ Cherry pick bisa menciptakan duplikasi commit jika nanti branch sumber juga di-merge

---

## 3. Interactive Rebase — Menulis Ulang Sejarah

### 📖 Definisi

**Interactive Rebase** (`git rebase -i`) adalah fitur yang memungkinkan Anda **mengubah, menyusun ulang, menggabungkan, atau menghapus commit** yang sudah ada. Ini seperti mesin waktu untuk sejarah commit Anda — Anda bisa "merevisi" masa lalu sebelum membaginya ke tim.

### 🎯 Mengapa Konsep Ini Penting?

Saat mengembangkan fitur, wajar jika Anda punya commit-commit "kotor" seperti `"fix typo"`, `"coba lagi"`, atau `"harusnya ini"`. Sebelum membuat Pull Request, Anda ingin riwayat yang bersih dan bermakna. Interactive rebase adalah alat untuk merapikan itu semua.

### 💻 Perintah Terkait

```bash
# Mulai interactive rebase untuk N commit terakhir
git rebase -i HEAD~N

# Rebase relatif terhadap branch lain
git rebase -i main

# Lanjutkan setelah resolve konflik
git rebase --continue

# Batalkan rebase
git rebase --abort
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda punya 4 commit berantakan yang ingin dirapikan sebelum membuat PR.

```bash
# Lihat 4 commit terakhir
git log --oneline -4
# d4e5f6a coba lagi
# c3d4e5b fix typo di validasi
# b2c3d4e wip: tambah validasi email
# a1b2c3d Menambahkan form registrasi

# Mulai interactive rebase untuk 4 commit terakhir
git rebase -i HEAD~4
```

Editor akan terbuka dengan tampilan seperti ini:

```
pick a1b2c3d Menambahkan form registrasi
pick b2c3d4e wip: tambah validasi email
pick c3d4e5b fix typo di validasi
pick d4e5f6a coba lagi
```

Anda bisa mengubah kata `pick` dengan perintah berikut:

| Perintah | Singkatan | Fungsi |
|---|---|---|
| `pick`   | `p` | Gunakan commit apa adanya |
| `squash` | `s` | Gabungkan ke commit sebelumnya |
| `fixup`  | `f` | Gabungkan, buang pesan commit ini |
| `reword` | `r` | Gunakan commit, tapi ubah pesannya |
| `drop`   | `d` | Hapus commit ini |
| `edit`   | `e` | Berhenti untuk mengedit commit ini |

Misalnya, gabungkan commit WIP dan perbaikan ke dalam satu commit yang rapi:

```
pick a1b2c3d Menambahkan form registrasi
squash b2c3d4e wip: tambah validasi email
fixup c3d4e5b fix typo di validasi
fixup d4e5f6a coba lagi
```

Simpan dan tutup editor. Editor akan terbuka lagi untuk menulis pesan commit gabungan:

```
Menambahkan form registrasi dengan validasi email
```

Hasil akhir — **2 commit yang bersih** menggantikan 4 commit berantakan:

```bash
git log --oneline
# e7f8a9b Menambahkan form registrasi dengan validasi email
# (commit sebelumnya...)
```

### 🔑 Poin Penting

- ✅ Selalu gunakan `rebase -i` **sebelum** push ke remote
- ⚠️ **Jangan rebase commit yang sudah di-push dan dibagikan ke tim** — ini akan merusak riwayat bagi orang lain
- ✅ Gunakan `rebase -i` sebagai langkah terakhir sebelum membuat Pull Request untuk menghasilkan riwayat yang bersih

---

## 4. Git Hooks — Otomasi di Balik Layar

### 📖 Definisi

**Git Hooks** adalah skrip yang berjalan **secara otomatis** sebelum atau sesudah perintah Git tertentu (seperti `commit`, `push`, atau `merge`). Mereka memungkinkan Anda mengotomasi pemeriksaan kualitas kode tanpa mengandalkan manusia untuk mengingatnya.

### 🎯 Mengapa Konsep Ini Penting?

Bayangkan hook sebagai **pos pemeriksaan otomatis**. Setiap kali seseorang mencoba commit, hook bisa menjalankan linter, unit test, atau pengecekan format kode. Jika ada yang tidak beres, commit akan dibatalkan dan developer diberi tahu. Ini mencegah kode buruk masuk ke repository dari awal.

### 💻 Perintah Terkait

```bash
# Hook disimpan di folder ini (dibuat otomatis saat git init)
ls .git/hooks/

# Contoh hook yang tersedia:
# pre-commit, commit-msg, pre-push, post-merge, dll.

# Aktifkan hook: buat file tanpa ekstensi .sample dan beri izin eksekusi
# Di Linux/macOS:
chmod +x .git/hooks/pre-commit

# Di Windows (Git Bash):
# File hook sudah bisa dieksekusi oleh Git Bash tanpa chmod
```

### ✅ Contoh Penggunaan Praktis

**Skenario 1: Jalankan linter otomatis sebelum setiap commit.**

Buat file `.git/hooks/pre-commit`:

```bash
#!/bin/sh

echo "Menjalankan linter sebelum commit..."

# Jalankan ESLint (contoh untuk proyek JavaScript)
npx eslint . --ext .js

# Jika linter gagal (exit code bukan 0), batalkan commit
if [ $? -ne 0 ]; then
  echo "❌ Commit dibatalkan: ada error dari linter."
  exit 1
fi

echo "✅ Linter lolos. Commit dilanjutkan."
```

Sekarang setiap `git commit` akan menjalankan linter dulu. Jika ada error, commit dibatalkan otomatis!

**Skenario 2: Validasi format pesan commit.**

Buat file `.git/hooks/commit-msg`:

```bash
#!/bin/sh

# Baca pesan commit dari file
COMMIT_MSG=$(cat "$1")

# Cek apakah pesan dimulai dengan kata kerja yang diizinkan
if ! echo "$COMMIT_MSG" | grep -qE "^(feat|fix|docs|style|refactor|test|chore):"; then
  echo "❌ Format pesan commit tidak valid!"
  echo "Gunakan format: <tipe>: <deskripsi>"
  echo "Contoh: feat: menambahkan fitur login"
  exit 1
fi
```

**Skenario 3: Menggunakan Husky (cara modern untuk tim)**

Untuk proyek tim, gunakan [Husky](https://typicode.github.io/husky/) agar hook bisa di-share via `package.json`:

```bash
# Install Husky
npm install husky --save-dev

# Aktifkan
npx husky init

# Tambahkan hook pre-commit
echo "npx eslint ." > .husky/pre-commit
```

### 🔑 Poin Penting

- ✅ Hook tersimpan di `.git/hooks/` dan **tidak ikut ke-push** ke remote secara default
- ✅ Gunakan Husky atau alat serupa untuk berbagi hook dengan seluruh tim via `package.json`
- ✅ Hook `pre-commit` dan `pre-push` paling sering digunakan
- ⚠️ Jangan buat hook yang terlalu lambat — developer akan frustrasi dan melewatinya dengan `--no-verify`

---

## 5. Git Submodules — Repository di Dalam Repository

### 📖 Definisi

**Git Submodules** adalah cara untuk menyertakan satu repository Git di dalam repository Git lain sebagai **dependensi yang terlacak versinya**. Ini berguna saat proyek Anda bergantung pada proyek eksternal yang juga menggunakan Git.

### 🎯 Mengapa Konsep Ini Penting?

Bayangkan Anda membangun sistem dengan beberapa komponen yang masing-masing punya repository terpisah: `komponen-ui`, `library-grafik`, dan `aplikasi-utama`. Submodules memungkinkan `aplikasi-utama` menyertakan kedua komponen tersebut sambil melacak versi spesifiknya — sehingga Anda tahu selalu komponen mana yang kompatibel.

### 💻 Perintah Terkait

```bash
# Menambahkan submodule
git submodule add https://github.com/user/repo.git nama-folder

# Clone repository yang memiliki submodule (--recursive mengambil semua submodule)
git clone --recursive https://github.com/user/main-repo.git

# Jika sudah terlanjur clone tanpa --recursive, inisialisasi submodule
git submodule update --init --recursive

# Update semua submodule ke versi terbaru
git submodule update --remote

# Lihat status semua submodule
git submodule status
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Proyek `portal-akademik` Anda menggunakan library `komponen-tabel` yang dikembangkan tim lain.

```bash
# Langkah 1: Di dalam repository portal-akademik, tambahkan submodule
git submodule add https://github.com/tim-lain/komponen-tabel.git libs/komponen-tabel

# Hasilnya: folder libs/komponen-tabel tersedia
# Git juga membuat file .gitmodules di root proyek

# Langkah 2: Commit perubahan ini
git add .gitmodules libs/komponen-tabel
git commit -m "Menambahkan submodule komponen-tabel"

# Langkah 3: Ketika tim lain clone proyek ini, mereka menjalankan:
git clone --recursive https://github.com/kita/portal-akademik.git
# Atau jika sudah clone biasa:
git submodule update --init --recursive
```

### 🔑 Poin Penting

- ✅ Submodule menunjuk ke **commit spesifik**, bukan ke branch (sengaja — untuk stabilitas)
- ✅ Gunakan `--recursive` saat cloning repository yang memiliki submodule
- ⚠️ Submodules menambah kompleksitas. Pertimbangkan alternatif seperti npm packages atau git subtree jika tim tidak terbiasa dengan submodule
- ✅ File `.gitmodules` harus di-commit dan ada di repository

---

## 6. Git Tags — Menandai Versi Rilis

### 📖 Definisi

**Git Tags** adalah cara untuk memberikan **label permanen dan bermakna** pada commit tertentu — biasanya untuk menandai titik rilis (seperti `v1.0.0`, `v2.1.3`). Berbeda dengan branch yang bergerak seiring commit baru, tag bersifat statis dan tidak pernah berpindah.

### 🎯 Mengapa Konsep Ini Penting?

Tanpa tag, bagaimana Anda tahu commit mana yang merupakan versi yang sudah dirilis? Hash commit seperti `a3f2b1c` tidak bermakna. Tag seperti `v2.0.0` langsung memberitahu Anda: "Ini adalah kode yang sudah naik ke production untuk versi 2.0.0."

### 💻 Perintah Terkait

```bash
# Buat tag pada commit terbaru (lightweight tag - hanya label)
git tag v1.0.0

# Buat annotated tag (yang direkomendasikan - ada pesan, author, tanggal)
git tag -a v1.0.0 -m "Rilis versi 1.0.0 - Fitur login dan dashboard"

# Buat tag pada commit lama
git tag -a v0.9.0 a3f2b1c -m "Versi beta sebelum rilis resmi"

# Lihat semua tag
git tag

# Lihat detail sebuah tag
git show v1.0.0

# Push tag ke remote (tag tidak otomatis ikut saat git push)
git push origin v1.0.0

# Push SEMUA tag ke remote sekaligus
git push origin --tags

# Hapus tag lokal
git tag -d v1.0.0-rc1

# Hapus tag di remote
git push origin --delete v1.0.0-rc1

# Checkout ke kondisi kode pada tag tertentu
git checkout v1.0.0
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Tim Anda baru menyelesaikan Sprint 1 dan ingin menandai rilis pertama aplikasi.

```bash
# Langkah 1: Pastikan di branch main, semua sudah di-merge
git checkout main
git pull origin main

# Langkah 2: Buat annotated tag
git tag -a v1.0.0 -m "Rilis v1.0.0
- Fitur: login dan registrasi pengguna
- Fitur: dashboard ringkasan data
- Fix: perbaikan gagal upload gambar profil"

# Langkah 3: Verifikasi tag
git show v1.0.0
# Output:
# tag v1.0.0
# Tagger: Abdul Mubdi <mubdi@example.com>
# Date:   Tue Mar 10 09:00:00 2026 +0700
# Rilis v1.0.0 ...

# Langkah 4: Push tag ke GitHub
git push origin v1.0.0
```

Di GitHub, tag ini akan otomatis muncul di halaman **Releases** repository Anda!

### 🔑 Poin Penting

- ✅ Selalu gunakan **annotated tag** (`-a`) untuk rilis — bukan lightweight tag
- ✅ Ikuti format **Semantic Versioning**: `vMAJOR.MINOR.PATCH` (contoh: `v1.2.3`)
  - **MAJOR** — perubahan yang tidak kompatibel ke belakang
  - **MINOR** — fitur baru yang kompatibel
  - **PATCH** — perbaikan bug kecil
- ✅ Tag **tidak otomatis** ter-push — harus eksplisit dengan `git push --tags`

---

## 7. Forking Workflow — Kontribusi pada Open Source

### 📖 Definisi

**Forking Workflow** adalah pola kolaborasi di mana setiap kontributor bekerja pada **salinan (fork) repository mereka sendiri**, bukan langsung di repository utama. Setelah pekerjaan selesai, mereka mengajukan Pull Request ke repository asli.

Ini adalah cara standar untuk berkontribusi pada proyek open source di GitHub.

### 🎯 Mengapa Konsep Ini Penting?

Dalam proyek open source, Anda tidak bisa sembarangan push ke repository orang lain. Forking memberikan Anda **ruang kerja pribadi** (fork) tanpa perlu izin maintainer, sambil tetap memungkinkan Anda mengajukan perubahan melalui Pull Request.

### 💻 Perintah Terkait

```bash
# Setelah fork di GitHub web, clone fork Anda
git clone https://github.com/USERNAME-ANDA/nama-proyek.git

# Tambahkan repository asli sebagai remote bernama 'upstream'
git remote add upstream https://github.com/pemilik-asli/nama-proyek.git

# Cek remote yang ada
git remote -v
# origin    https://github.com/USERNAME-ANDA/nama-proyek.git (fetch)
# origin    https://github.com/USERNAME-ANDA/nama-proyek.git (push)
# upstream  https://github.com/pemilik-asli/nama-proyek.git (fetch)
# upstream  https://github.com/pemilik-asli/nama-proyek.git (push)

# Update fork Anda dengan perubahan terbaru dari upstream
git fetch upstream
git checkout main
git merge upstream/main

# Push update ke fork Anda
git push origin main
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Anda ingin menambahkan fitur ke proyek open source `awesome-tool` yang populer di GitHub.

```bash
# Langkah 1: Fork di GitHub
# Buka https://github.com/pemilik/awesome-tool
# Klik tombol "Fork" → repository disalin ke akun Anda

# Langkah 2: Clone fork Anda
git clone https://github.com/NAMA-ANDA/awesome-tool.git
cd awesome-tool

# Langkah 3: Hubungkan ke repository asli
git remote add upstream https://github.com/pemilik/awesome-tool.git

# Langkah 4: Update dengan kode terbaru dari upstream
git fetch upstream
git merge upstream/main

# Langkah 5: Buat branch fitur
git checkout -b fitur/tambah-ekspor-csv

# Langkah 6: Kerjakan fitur, commit
git add .
git commit -m "Menambahkan fitur ekspor data ke format CSV"

# Langkah 7: Push ke FORK Anda (bukan upstream!)
git push origin fitur/tambah-ekspor-csv

# Langkah 8: Buka Pull Request di GitHub
# Dari: NAMA-ANDA/awesome-tool (fitur/tambah-ekspor-csv)
# Ke:   pemilik/awesome-tool (main)
```

### 🔑 Poin Penting

- ✅ `origin` = fork Anda, `upstream` = repository asli (konvensi standar)
- ✅ Selalu **sync dengan upstream** sebelum mulai pengerjaan untuk menghindari konflik
- ✅ Selalu buat **branch terpisah** untuk setiap kontribusi, jangan bekerja di `main` fork Anda
- ✅ Baca file `CONTRIBUTING.md` milik proyek sebelum berkontribusi — setiap proyek punya aturan berbeda

### 📊 Diagram Forking Workflow

```
[Repo Original (upstream)]
       ↑ Pull Request
[Fork Anda (origin)]   ← git fetch upstream + merge
       ↑ git push
[Local Repository]
```

---

## 8. GitFlow — Strategi Branching untuk Tim Besar

### 📖 Definisi

**GitFlow** adalah sebuah **model branching** yang mendefinisikan aturan baku tentang bagaimana branch digunakan, kapan dibuat, dan bagaimana digabungkan. Diciptakan oleh Vincent Driessen, GitFlow sangat populer untuk tim yang memiliki siklus rilis terjadwal.

### 🎯 Mengapa Konsep Ini Penting?

Ketika tim Anda terdiri dari 5 orang atau lebih dan ada fitur, bug fix, dan hotfix yang berjalan bersamaan, hanya bermodalkan branch `main` dan `fitur/sesuatu` tidak lagi cukup. GitFlow menyediakan **kerangka kerja yang jelas**: siapa mengerjakan apa di branch mana, dan kapan bisa masuk ke production.

### 💻 Struktur Branch dalam GitFlow

GitFlow menggunakan beberapa branch dengan peran khusus:

| Branch | Jenis | Fungsi |
|---|---|---|
| `main` | Permanen | Kode production yang stabil. Setiap commit = versi rilis |
| `develop` | Permanen | Integrasi fitur. Tempat semua fitur selesai dikumpulkan |
| `feature/*` | Sementara | Pengembangan fitur baru (cabang dari `develop`) |
| `release/*` | Sementara | Persiapan rilis: bug fix minor, update versi |
| `hotfix/*` | Sementara | Perbaikan bug kritis di production (langsung dari `main`) |

### 💻 Perintah Terkait

Anda bisa menggunakan `git-flow` CLI extension untuk mempermudah:

```bash
# Install git-flow (Windows dengan Git for Windows)
# Biasanya sudah tersedia bawaan

# Inisialisasi GitFlow di repository Anda
git flow init

# Mulai mengerjakan fitur baru
git flow feature start nama-fitur
# Setara dengan: git checkout -b feature/nama-fitur develop

# Selesai fitur, merge ke develop
git flow feature finish nama-fitur
# Setara dengan: merge ke develop, hapus branch fitur

# Mulai rilis
git flow release start 1.2.0

# Selesaikan rilis (merge ke main DAN develop, buat tag)
git flow release finish 1.2.0

# Mulai hotfix (dari main)
git flow hotfix start nama-bug-kritis

# Selesaikan hotfix (merge ke main DAN develop)
git flow hotfix finish nama-bug-kritis
```

### ✅ Contoh Penggunaan Praktis

**Skenario:** Tim 6 orang sedang mengembangkan aplikasi dengan rilis tiap 2 sprint.

```bash
# === Sprint Dimulai ===

# Developer A: mengerjakan fitur login SSO
git flow feature start fitur-sso
# ... coding & committing ...
git flow feature finish fitur-sso
# Otomatis merge ke develop

# Developer B: mengerjakan fitur notifikasi email
git flow feature start fitur-notifikasi
# ... coding & committing ...
git flow feature finish fitur-notifikasi

# === Sprint Berakhir, Siap Rilis ===

# Team Lead: mulai siklus rilis
git flow release start 2.0.0

# Perbaiki bug kecil yang ditemukan saat QA testing di release branch
git add fix-qa-bug.js
git commit -m "Fix: perbaiki edge case validasi tanggal"

# Rilis resmi
git flow release finish 2.0.0
# Otomatis: merge ke main, merge ke develop, buat tag v2.0.0

# === Darurat! Bug Kritis di Production ===

git flow hotfix start login-crash-nullpointer
# ... fix code ...
git flow hotfix finish login-crash-nullpointer
# Otomatis: merge ke main, merge ke develop, buat tag v2.0.1
```

### 🔑 Poin Penting

- ✅ `main` **hanya boleh menerima merge dari** `release` atau `hotfix` — jangan langsung
- ✅ `develop` adalah pusat integrasi — semua fitur bermuara di sini
- ✅ GitFlow cocok untuk produk dengan **jadwal rilis terencana** (mingguan, sprint-based)
- ⚠️ GitFlow mungkin **terlalu berat** untuk proyek kecil atau yang rilis terus-menerus (*continuous deployment*) — GitHub Flow lebih sederhana untuk kasus tersebut

### 📊 Visualisasi GitFlow

```
main     ●────────────────────────────●──────────●
          \                          / \        / \
release    ●──●──●──────────────────●   \      /   \
                  \                      \    /     \
develop    ●────────●────────────────●────●──●──────●
                     \              /
feature               ●──●──●──────●
```

---

## Kesimpulan

Anda baru saja mempelajari **8 topik Git lanjutan** yang akan membawa kemampuan Anda ke level berikutnya:

### 📚 Ringkasan 8 Topik

| # | Topik | Kegunaan Utama |
|---|---|---|
| 1 | **Git Stash** | Simpan pekerjaan sementara tanpa commit |
| 2 | **Cherry Pick** | Ambil commit terpilih dari branch lain |
| 3 | **Interactive Rebase** | Rapikan riwayat commit sebelum PR |
| 4 | **Git Hooks** | Otomasi pengecekan kualitas kode |
| 5 | **Git Submodules** | Kelola dependensi yang punya repo sendiri |
| 6 | **Git Tags** | Tandai commit rilis dengan versi |
| 7 | **Forking Workflow** | Kontribusi ke proyek open source |
| 8 | **GitFlow** | Strategi branching untuk tim besar |

### 🎯 Kapan Menggunakan Apa?

- Sedang kerja dan ada interupsi mendadak → **Git Stash**
- Butuh satu perbaikan dari branch lain → **Cherry Pick**
- Sebelum membuat Pull Request → **Interactive Rebase**
- Ingin standarisasi kualitas kode tim → **Git Hooks**
- Proyek multi-komponen dengan repo terpisah → **Git Submodules**
- Siap naik ke production → **Git Tags**
- Berkontribusi ke proyek orang lain → **Forking Workflow**
- Tim besar dengan siklus rilis terjadwal → **GitFlow**

### 🚀 Rekomendasi Urutan Belajar

Jika semuanya terasa banyak, mulai dari yang paling sering berguna dalam kerja harian:

1. **Git Stash** → digunakan hampir setiap hari
2. **Git Tags** → dibutuhkan saat rilis pertama
3. **Interactive Rebase** → untuk PR yang lebih rapi
4. **Cherry Pick** → untuk situasi khusus
5. **Git Hooks** → saat mulai peduli dengan kualitas kode secara sistematis
6. **Forking Workflow** → saat mulai kontribusi open source
7. **GitFlow** → saat tim membesar dan butuh struktur
8. **Git Submodules** → hanya jika arsitektur proyek membutuhkan

### 💡 Tips Terakhir

1. **Latihan adalah satu-satunya cara** — buat repository uji coba dan coba semua perintah ini
2. **Baca error dengan seksama** — Git selalu memberikan petunjuk cara menyelesaikan masalah
3. **`git reflog` adalah jaring pengaman terakhir** — hampir semua "kesalahan fatal" di Git bisa dipulihkan lewat perintah ini
4. **Diskusikan dengan tim** — GitFlow, Git Hooks, dan konvensi tag harus disepakati bersama, bukan diterapkan sepihak

### 📖 Resources Lanjutan

- [Pro Git Book (Gratis)](https://git-scm.com/book/id/v2) — Buku resmi Git yang komprehensif
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials) — Penjelasan visual yang sangat baik
- [Oh Shit, Git!?](https://ohshitgit.com/) — Panduan menyelesaikan situasi darurat di Git
- [Learn Git Branching](https://learngitbranching.js.org/) — Simulasi interaktif untuk memahami branching dan rebase
- [Conventional Commits](https://www.conventionalcommits.org/) — Spesifikasi standar pesan commit (relevan untuk Git Hooks)
- [Semantic Versioning](https://semver.org/) — Panduan resmi versioning untuk Git Tags

---

## Penutup

Menguasai topik-topik ini tidak terjadi dalam semalam. Setiap kali Anda menghadapi situasi baru dalam proyek nyata — sebuah bug darurat, kebutuhan merapikan PR, atau keinginan berkontribusi ke open source — kembalilah ke panduan ini.

Git adalah alat yang bertumbuh bersama Anda. Semakin kompleks proyek yang Anda tangani, semakin banyak fitur Git yang akan terasa relevan dan berharga.

> "Seorang developer yang menguasai Git bukan yang tidak pernah membuat kesalahan, melainkan yang tahu cara memperbaikinya dengan percaya diri."

Selamat belajar dan selamat berkontribusi! 🚀💻

---

**Catatan:** Panduan ini merupakan lanjutan dari [Git 101: 10 Konsep Penting di Git](./Git%20101,%2010%20Konsep%20Penting%20di%20Git.md). Silakan kembali ke Git 101 kapan saja untuk menyegarkan pemahaman dasar.
