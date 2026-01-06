Tentu, ini adalah **Panduan Alur Kerja (Workflow) Sinkronisasi** yang telah diperbaiki dan dilengkapi. Simpan panduan ini agar Anda bisa bekerja mulus antara Laptop (Kantor) dan Desktop (Rumah).

---

### **PANDUAN ALUR KERJA: R Markdown dengan Google Antigravity & GitHub**

Tujuan: Memastikan buku praktikum Anda selalu _up-to-date_ di kedua mesin tanpa konflik file.

#### **1. PAGI / SIANG: Di Kantor (Laptop)**

**A. Saat Mulai Bekerja (WAJIB)**
Jangan menyentuh atau mengedit file apa pun sebelum langkah ini selesai.

1.  Buka **Google Antigravity**.
2.  Buka Terminal (`Ctrl` + `` ` ``).
3.  Ketik perintah ini dan tekan **Enter**:
    ```bash
    git pull
    ```
    _(Perintah ini menarik semua pekerjaan yang Anda selesaikan di rumah semalam ke laptop)._

**B. Saat Bekerja (Coding & Writing)**

- **Gunakan Agen:** Karena file `AGENTS.md` sudah tersinkronisasi, agen di laptop akan otomatis paham konteks proyek dan aturan penulisan Anda.
- **Render:** Jika ingin melihat hasil sementara, ketik di terminal:
  ```r
  bookdown::render_book("index.Rmd")
  ```

**C. Sebelum Pulang (SANGAT PENTING)**
Simpan pekerjaan Anda ke GitHub agar bisa dibuka di rumah.

1.  Klik ikon **Source Control** (cabang pohon) di bilah kiri.
2.  Klik tombol **Sparkle (✨)** di kotak pesan commit. Agen akan menulis ringkasan perubahan Anda secara otomatis.
3.  Klik **Commit**.
4.  Klik **Sync Changes** (atau tombol panah berputar) untuk melakukan **Push**.

---

#### **2. MALAM: Di Rumah (Desktop)**

**A. Saat Mulai Bekerja (WAJIB)**
Sebelum menyentuh file apa pun:

1.  Buka **Google Antigravity**.
2.  Jika muncul _pop-up_ keamanan, pastikan pilih **"Yes, I trust the authors"** agar agen AI aktif.
3.  Buka Terminal dan tarik data dari kantor:
    ```bash
    git pull
    ```
    _(Jika Anda lupa langkah ini dan langsung mengedit, file akan bentrok/konflik)._

**B. Saat Bekerja**
Lanjutkan revisi atau penulisan. Semua data, gambar, dan kode dari kantor sudah tersedia.

**C. Sebelum Tidur**
Kirim kembali pekerjaan ke GitHub agar siap untuk besok pagi.

1.  Ke tab **Source Control**.
2.  **Commit** (gunakan tombol ✨ lagi).
3.  **Sync Changes (Push)**.

---

### **Tips Tambahan**

1.  **Jangan Ubah Folder `_book`:** Folder ini berisi hasil _render_ (HTML) dan biasanya tidak perlu di-track secara ketat oleh Git jika Anda hanya fokus pada _source code_ (`.Rmd`). Namun, jika Anda ingin menyimpannya, pastikan selalu di-_render_ ulang sebelum _push_.
2.  **Jika Lupa `git pull`:** Jika Anda tidak sengaja mengedit di rumah sebelum melakukan `pull`, Antigravity mungkin akan memperingatkan adanya "Merge Conflict". Jika ini terjadi, minta bantuan agen: _"Saya lupa pull dan sekarang ada konflik, tolong bantu selesaikan dengan memprioritaskan perubahan terbaru saya."_
