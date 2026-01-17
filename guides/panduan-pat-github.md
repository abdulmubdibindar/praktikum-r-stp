# PANDUAN PENGELOLAAN PERSONAL ACCESS TOKEN (PAT) GITHUB

## Untuk Penggunaan Multi-Perangkat

---

**Dokumen Teknis Resmi**  
**Versi:** 1.1  
**Tanggal Berlaku:** 16 Januari 2026  
**Status:** Aktif

---

## DAFTAR ISI

1. [Pendahuluan](#1-pendahuluan)
2. [Definisi dan Istilah](#2-definisi-dan-istilah)
3. [Permasalahan Umum](#3-permasalahan-umum)
4. [Solusi dan Prosedur Kerja](#4-solusi-dan-prosedur-kerja)
5. [Langkah-Langkah Implementasi](#5-langkah-langkah-implementasi)
6. [Keamanan dan Praktik Terbaik](#6-keamanan-dan-praktik-terbaik)
7. [Pemecahan Masalah](#7-pemecahan-masalah)
8. [Lampiran](#8-lampiran)

---

## 1. PENDAHULUAN

### 1.1 Latar Belakang

Personal Access Token (PAT) merupakan mekanisme autentikasi yang disediakan oleh GitHub sebagai pengganti kata sandi tradisional untuk mengakses repositori melalui antarmuka baris perintah (CLI), aplikasi pihak ketiga, maupun operasi Git berbasis HTTPS. Sejak 13 Agustus 2021, GitHub telah menonaktifkan autentikasi berbasis kata sandi untuk operasi Git, sehingga penggunaan PAT menjadi wajib.

### 1.2 Tujuan Dokumen

Dokumen ini disusun untuk memberikan panduan komprehensif kepada pengguna yang mengoperasikan akun GitHub pada **dua atau lebih perangkat komputer secara bergantian**, dengan fokus pada pengelolaan PAT yang aman dan efisien.

### 1.3 Ruang Lingkup

Panduan ini mencakup:

- Pembuatan dan pengelolaan PAT
- Penyimpanan token secara aman
- Konfigurasi multi-perangkat
- Prosedur pemulihan akses

---

## 2. DEFINISI DAN ISTILAH

| Istilah                          | Definisi                                                                            |
| -------------------------------- | ----------------------------------------------------------------------------------- |
| **PAT (Personal Access Token)**  | Token autentikasi yang berfungsi sebagai pengganti kata sandi untuk akses ke GitHub |
| **Fine-grained PAT**             | Jenis PAT terbaru dengan kontrol akses granular per-repositori                      |
| **Classic PAT**                  | Jenis PAT tradisional dengan cakupan (scope) yang lebih luas                        |
| **Git Credential Manager (GCM)** | Utilitas penyimpanan kredensial Git yang aman                                       |
| **GitHub CLI (gh)**              | Antarmuka baris perintah resmi dari GitHub                                          |
| **Credential Helper**            | Mekanisme penyimpanan kredensial pada sistem operasi                                |

---

## 3. PERMASALAHAN UMUM

### 3.1 Identifikasi Masalah

Pengguna yang mengoperasikan GitHub pada dua komputer secara bergantian kerap menghadapi permasalahan berikut:

> [!WARNING] > **Masalah Utama:** Personal Access Token hanya ditampilkan **SATU KALI** pada saat pembuatan. Setelah halaman ditutup atau berpindah, token tidak dapat dilihat kembali.

### 3.2 Dampak Permasalahan

1. **Regenerasi Token Berulang:** Ketika membutuhkan token untuk perangkat kedua, pengguna terpaksa membuat token baru karena token sebelumnya tidak tersimpan.

2. **Invalidasi Token Lama:** Proses regenerasi akan menonaktifkan token sebelumnya, menyebabkan autentikasi pada perangkat pertama menjadi gagal.

3. **Siklus Tidak Efisien:** Pengguna terjebak dalam siklus regenerasi token setiap kali berpindah perangkat.

4. **Isolasi Kredensial Antar-Layanan:** Credential yang tersimpan pada satu layanan (misalnya Git) **tidak dapat diakses** oleh layanan lain (misalnya GitHub CLI, Visual Studio Code, atau RStudio) pada perangkat yang sama. Setiap layanan memiliki penyimpanan kredensial tersendiri yang terisolasi.

> [!NOTE] > **Contoh Kasus:** Anda telah berhasil melakukan `git push` menggunakan token. Kemudian Anda menginstal GitHub CLI dan menjalankan `gh auth login`. GitHub CLI akan meminta token kembali karena tidak dapat mengakses token yang tersimpan di Git credential helper.

### 3.3 Ilustrasi Skenario

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Komputer A    │     │     GitHub      │     │   Komputer B    │
│                 │     │                 │     │                 │
│ Token: abc123   │────▶│ Token Valid:    │◀────│ Token: ???      │
│ (tersimpan)     │     │ abc123          │     │ (tidak punya)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                │
                                ▼
                    ┌─────────────────────┐
                    │ Pengguna regenerate │
                    │ Token: xyz789       │
                    └─────────────────────┘
                                │
                                ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Komputer A    │     │     GitHub      │     │   Komputer B    │
│                 │     │                 │     │                 │
│ Token: abc123   │──X──│ Token Valid:    │◀────│ Token: xyz789   │
│ (INVALID)       │     │ xyz789          │     │ (baru)          │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## 4. SOLUSI DAN PROSEDUR KERJA

### 4.1 Solusi Utama: Penyimpanan Token Secara Aman

> [!IMPORTANT] > **Prinsip Dasar:** Simpan token segera setelah pembuatan di lokasi yang aman dan dapat diakses dari kedua perangkat.

### 4.2 Opsi Penyimpanan Token

#### Opsi A: Password Manager (DIREKOMENDASIKAN)

| Password Manager | Platform                 | Keterangan                         |
| ---------------- | ------------------------ | ---------------------------------- |
| Bitwarden        | Cross-platform, gratis   | Open source, dapat di-host sendiri |
| 1Password        | Cross-platform, berbayar | Integrasi dengan Git dan CLI       |
| KeePassXC        | Cross-platform, gratis   | Offline, database terenkripsi      |
| LastPass         | Cross-platform, freemium | Sinkronisasi cloud                 |

#### Opsi B: Penyimpanan Terenkripsi Manual

- File terenkripsi menggunakan GPG/PGP
- Catatan terenkripsi pada layanan cloud (mis. Standard Notes)
- Dokumen terproteksi kata sandi

#### Opsi C: Git Credential Manager

Menggunakan Git Credential Manager (GCM) untuk menyimpan kredensial secara lokal pada setiap perangkat setelah login pertama.

### 4.3 Memahami Isolasi Kredensial

> [!IMPORTANT] > **Fakta Penting:** Setiap layanan/aplikasi menyimpan kredensial secara **terpisah dan terisolasi**. Token yang tersimpan di satu layanan TIDAK otomatis tersedia untuk layanan lain, meskipun berada di perangkat yang sama.

**Ilustrasi Isolasi Kredensial dalam Satu Perangkat:**

```
┌────────────────────────────────────────────────────────────────┐
│                      SATU KOMPUTER                             │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │     Git      │  │  GitHub CLI  │  │    VS Code   │          │
│  │              │  │              │  │              │          │
│  │ Token: ✓     │  │ Token: ✗     │  │ Token: ✗     │          │
│  │ (tersimpan)  │  │ (belum ada)  │  │ (belum ada)  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│         │                  │                  │                │
│         ▼                  ▼                  ▼                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Credential  │  │   ~/.config  │  │   Settings   │          │
│  │   Manager    │  │   /gh/       │  │    JSON      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                │
│  ════════════════════════════════════════════════════════════  │
│          PENYIMPANAN KREDENSIAL TERISOLASI SATU SAMA LAIN      │
└────────────────────────────────────────────────────────────────┘
```

**Implikasi:** Anda perlu memasukkan token untuk **setiap layanan** yang membutuhkan autentikasi GitHub. Oleh karena itu, menyimpan token di password manager menjadi **SANGAT KRUSIAL**.

### 4.4 Strategi Multi-Token (Per Perangkat)

Alternatif lain adalah membuat **token terpisah untuk setiap perangkat**:

| Pendekatan    | Kelebihan                                | Kekurangan                        |
| ------------- | ---------------------------------------- | --------------------------------- |
| Token Tunggal | Manajemen sederhana                      | Harus disimpan dan disinkronkan   |
| Multi-Token   | Isolasi per perangkat, revoke independen | Lebih banyak token untuk dikelola |

---

## 5. LANGKAH-LANGKAH IMPLEMENTASI

### 5.1 Prosedur Pembuatan PAT Baru

#### Langkah 1: Akses Pengaturan Developer

1. Login ke akun GitHub melalui browser
2. Klik foto profil di pojok kanan atas
3. Pilih **Settings**
4. Pada menu kiri, scroll ke bawah dan klik **Developer settings**
5. Pilih **Personal access tokens**

#### Langkah 2: Pilih Jenis Token

| Jenis Token             | Kapan Digunakan                                           |
| ----------------------- | --------------------------------------------------------- |
| **Fine-grained tokens** | Untuk akses terbatas ke repositori tertentu               |
| **Tokens (classic)**    | Untuk akses umum atau kompatibilitas dengan aplikasi lama |

#### Langkah 3: Konfigurasi Token (Classic)

1. Klik **Generate new token** → **Generate new token (classic)**
2. Isi kolom **Note** dengan deskripsi yang jelas, contoh:
   - `Komputer Kantor - Git Operations`
   - `Laptop Pribadi - GitHub CLI`
3. Pilih **Expiration** (masa berlaku):
   - 30 hari, 60 hari, 90 hari, atau custom
   - **No expiration** (tidak disarankan untuk keamanan)
4. Pilih **Scopes** yang diperlukan:

| Scope      | Fungsi                                      |
| ---------- | ------------------------------------------- |
| `repo`     | Akses penuh ke repositori privat dan publik |
| `workflow` | Mengelola GitHub Actions                    |
| `read:org` | Membaca keanggotaan organisasi              |
| `gist`     | Membuat dan mengelola Gist                  |

5. Klik **Generate token**

#### Langkah 4: SEGERA SIMPAN TOKEN

> [!CAUTION] > **PERHATIAN KRITIS:** Setelah token ditampilkan, **SALIN DAN SIMPAN SEGERA** ke password manager atau lokasi aman lainnya. Token TIDAK AKAN ditampilkan lagi setelah halaman ditutup.

**Contoh format penyimpanan:**

```
Nama: GitHub PAT - Komputer Kantor
Username: username_github
Token: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Dibuat: 16 Januari 2026
Kadaluarsa: 16 April 2026
Scopes: repo, workflow
```

### 5.2 Konfigurasi Token pada Komputer Pertama

#### Untuk Git (HTTPS)

```bash
# Konfigurasi credential helper untuk menyimpan kredensial
git config --global credential.helper store

# Atau gunakan Git Credential Manager (lebih aman)
git config --global credential.helper manager
```

Saat melakukan operasi Git pertama kali (push/pull), masukkan:

- **Username:** Username GitHub Anda
- **Password:** Token yang telah dibuat (BUKAN kata sandi akun)

#### Untuk GitHub CLI

```bash
# Login menggunakan token
gh auth login

# Pilih opsi:
# 1. GitHub.com
# 2. HTTPS
# 3. Paste an authentication token
# 4. Tempelkan token yang telah disimpan
```

### 5.3 Konfigurasi Token pada Komputer Kedua

Ulangi prosedur pada Bagian 5.2 menggunakan **token yang sama** yang telah disimpan di password manager.

> [!TIP]
> Dengan menggunakan token yang sama di kedua perangkat, Anda tidak perlu regenerate token setiap kali berpindah komputer.

### 5.4 Prosedur Strategi Multi-Token (Alternatif)

Jika memilih pendekatan multi-token:

1. **Buat token terpisah** untuk setiap perangkat dengan nama deskriptif:
   - `PAT-Komputer-Kantor`
   - `PAT-Laptop-Pribadi`
2. **Simpan kedua token** di password manager

3. **Keuntungan:** Jika satu perangkat dikompromikan, Anda dapat me-revoke token spesifik tersebut tanpa memengaruhi perangkat lain.

### 5.5 Konfigurasi Multi-Layanan pada Satu Perangkat

Ketika menggunakan beberapa layanan yang membutuhkan autentikasi GitHub pada satu perangkat:

> [!TIP] > **Prinsip Utama:** Gunakan **satu token yang sama** untuk semua layanan pada satu perangkat. Ambil token dari password manager setiap kali layanan baru meminta autentikasi.

#### Langkah-Langkah:

1. **Buka password manager** dan salin token yang telah tersimpan
2. **Masukkan token** ke layanan yang membutuhkan autentikasi
3. **Ulangi** untuk setiap layanan baru

#### Contoh Skenario Lengkap:

| Urutan | Layanan       | Aksi                                              |
| ------ | ------------- | ------------------------------------------------- |
| 1      | Git (CLI)     | `git push` → masukkan token dari password manager |
| 2      | GitHub CLI    | `gh auth login` → paste token yang sama           |
| 3      | VS Code       | Sign in → paste token yang sama                   |
| 4      | RStudio       | Git credentials → paste token yang sama           |
| 5      | JetBrains IDE | GitHub integration → paste token yang sama        |

#### Alur Kerja yang Direkomendasikan:

```
┌─────────────────┐
│ Password Manager │
│  (Sumber Token)  │
└────────┬────────┘
         │
         │ Salin token saat dibutuhkan
         │
         ▼
┌─────────────────────────────────────────────────────────┐
│                    SATU KOMPUTER                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐      │
│   │ Git │   │ GH  │   │ VS  │   │ R   │   │ IDE │      │
│   │     │   │ CLI │   │Code │   │Stud.│   │ lain│      │
│   └──┬──┘   └──┬──┘   └──┬──┘   └──┬──┘   └──┬──┘      │
│      │         │         │         │         │         │
│      └─────────┴─────────┴─────────┴─────────┘         │
│                         │                              │
│                         ▼                              │
│              Token yang SAMA digunakan                 │
│              untuk semua layanan                       │
└─────────────────────────────────────────────────────────┘
```

> [!WARNING] > **Jangan regenerate token** hanya karena layanan baru meminta autentikasi. Cukup salin token yang sudah ada dari password manager.

---

## 6. KEAMANAN DAN PRAKTIK TERBAIK

### 6.1 Prinsip Keamanan Token

| Prinsip                   | Implementasi                                         |
| ------------------------- | ---------------------------------------------------- |
| **Least Privilege**       | Berikan hanya scope yang diperlukan                  |
| **Expiration**            | Atur masa berlaku token (90 hari direkomendasikan)   |
| **Deskripsi Jelas**       | Gunakan nama token yang menjelaskan perangkat/fungsi |
| **Revoke Tidak Terpakai** | Hapus token yang tidak lagi digunakan                |

### 6.2 Larangan

> [!CAUTION] > **DILARANG KERAS:**
>
> - Menyimpan token di file teks biasa tanpa enkripsi
> - Mengirim token melalui email atau pesan tidak terenkripsi
> - Menyertakan token dalam kode sumber (commit ke repositori)
> - Membagikan token kepada pihak lain

### 6.3 Audit Berkala

Lakukan audit token secara berkala melalui:  
**Settings → Developer settings → Personal access tokens**

Periksa:

- Token yang sudah lama tidak digunakan
- Token yang mendekati kadaluarsa
- Token dengan scope berlebihan

---

## 7. PEMECAHAN MASALAH

### 7.1 Token Tidak Diterima

**Gejala:** Autentikasi gagal meskipun token sudah dimasukkan.

**Kemungkinan Penyebab dan Solusi:**

| Penyebab               | Solusi                                               |
| ---------------------- | ---------------------------------------------------- |
| Token sudah kadaluarsa | Buat token baru dengan masa berlaku lebih panjang    |
| Token sudah di-revoke  | Periksa daftar token di GitHub Settings              |
| Scope tidak mencukupi  | Buat token baru dengan scope yang sesuai             |
| Typo saat copy-paste   | Pastikan menyalin seluruh token tanpa spasi tambahan |

### 7.2 Credential Tersimpan Salah

**Untuk Windows:**

```bash
# Hapus kredensial GitHub dari Credential Manager
cmdkey /delete:git:https://github.com
```

**Untuk macOS:**

```bash
# Hapus dari Keychain
git credential-osxkeychain erase
host=github.com
protocol=https
[tekan Enter dua kali]
```

**Untuk Linux:**

```bash
# Jika menggunakan credential.helper store
rm ~/.git-credentials

# Atau edit file untuk menghapus entri GitHub saja
nano ~/.git-credentials
```

### 7.3 GitHub CLI Tidak Mengenali Token

```bash
# Logout terlebih dahulu
gh auth logout

# Login ulang
gh auth login
```

---

## 8. LAMPIRAN

### 8.1 Daftar Periksa Implementasi

- [ ] Password manager sudah terinstal dan dikonfigurasi di kedua perangkat
- [ ] Token baru sudah dibuat dengan scope yang sesuai
- [ ] Token sudah disimpan di password manager
- [ ] Kredensial sudah dikonfigurasi di Komputer A
- [ ] Kredensial sudah dikonfigurasi di Komputer B
- [ ] Verifikasi: `git push` berhasil dari Komputer A
- [ ] Verifikasi: `git push` berhasil dari Komputer B
- [ ] Verifikasi: `gh auth status` berhasil dari kedua komputer

### 8.2 Referensi

- [Dokumentasi Resmi GitHub - Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [Git Credential Storage](https://git-scm.com/docs/git-credential-store)

### 8.3 Riwayat Revisi Dokumen

| Versi | Tanggal         | Perubahan                                                                                    | Penyusun        |
| ----- | --------------- | -------------------------------------------------------------------------------------------- | --------------- |
| 1.0   | 16 Januari 2026 | Dokumen awal                                                                                 | Tim Dokumentasi |
| 1.1   | 16 Januari 2026 | Penambahan penjelasan isolasi kredensial antar-layanan dan panduan konfigurasi multi-layanan | Tim Dokumentasi |

---

**AKHIR DOKUMEN**

---

_Dokumen ini disusun sesuai dengan standar dokumentasi teknis pemerintah dan dapat digunakan sebagai panduan operasional._
