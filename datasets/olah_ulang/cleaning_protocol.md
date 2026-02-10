# Operasi Pembersihan Dataset

## Konvensi Penamaan Variabel

- Gunakan huruf kecil untuk semua nama variabel
- Gunakan tanda titik (.) untuk memisahkan kata

## Tipe Data Variabel

- Berikut adalah variabel numerik yang digunakan dalam keempat dataset
  - `Umur` → nilai usia responden dalam tahun → agar diseragamkan namanya menjadi `usia`
  - `kepemilikan.mobil` → jumlah mobil yang dimiliki keluarga → agar diseragamkan namanya menjadi `jumlah.mobil`
  - `kepemilikan.sepeda` → jumlah sepeda yang dimiliki keluarga → agar diseragamkan namanya menjadi `jumlah.sepeda`
  - `kepemilikan.motor` → jumlah motor yang dimiliki keluarga → agar diseragamkan namanya menjadi `jumlah.motor`
  - `jarak..km.` → jarak dari tempat tinggal ke kampus dalam kilometer → agar diseragamkan namanya menjadi `jarak.km`. Ubah menjadi desimal dengan mengganti tanda koma menjadi titik
  - `biaya.dalam.ribu` → biaya transportasi dalam seminggu dalam satuan ribu rupiah
    - gunakan nama `biaya.dalam.ribu`
    - atur agar skala nilainya menjadi maksimal ratusan, sehingga jika ada nilai yang lebih besar dari 1000 maka dibagi 1000
    - untuk dataset UBL, ubah saja nama dari variabel `biaya.dalam.ribu2` menjadi `biaya.dalam.ribu`, hapus variabel `biaya dalam seminggu` yang sudah ada sebelumnya
  - `jumlah.perjalanan.<hari>` → jumlah perjalanan dalam seminggu
    - untuk nilai yang berupa string dalam dataset UBL, ubah saja menjadi 0
    - untuk nilai missing di variabel ini dalam dataset UNILA, drop saja observasinya
- Berikut adalah variabel kategoris yang digunakan dalam keempat dataset
  - `jenis.kelamin` → jenis kelamin responden → Ubah nilai 1 menjadi "Laki-laki" dan 2 menjadi "Perempuan"
  - `Fakultas` → Fakultas responden → Gunakan nilai apa adanya di dataset untuk sementara
  - `Prodi` → Program studi responden → Gunakan nilai apa adanya di dataset untuk sementara
  - `Tingkat Semester` → Tingkat semester responden → Ubah nilai 1 - 4 menjadi "Semester 1 - 2", "Semester 3 - 4", "Semester 5 - 6", "Semester 7 - 8 ke atas" untuk semua dataset buat menjadi factor dengan urutan sesuai yang disebutkan
  - `Uang Saku` → Uang saku responden dalam seminggu → Seragamkan nilai kategoris menjadi "< Rp1 juta", "Rp1 juta - Rp2 juta", "Rp2,1 juta - Rp3 juta", "Rp3,1 juta - Rp4 juta", dan "> Rp4 juta" -> buat menjadi factor dengan urutan sesuai yang disebutkan
  - `kendaraan utama` → kendaraan utama yang digunakan untuk berangkat ke kampus -> Gunakan nilai "Berjalan kaki", "Menumpang kendaraan bermotor teman/keluarga", "Mobil pribadi", "Sepeda motor pribadi", dan "Transportasi daring". Ubah nilai-nilai yang ada menjadi kategori yang paling mendekati nilai yang sudah dispesifikkan.
  - `Jenis tempat tinggal` → Jenis tempat tinggal responden → seragamkan untuk seluruh dataset berdasarkan nilai kategoris yang sudah tertulis.
  - `nama jalan tempat tinggal` → nama jalan tempat tinggal responden → seragamkan menjadi `alamat`
  - hapus variabel `kelurahan` dari dataset ITERA

## Variabel ID

- Hapus saja variabel `Timestamp`. Pertahankan variabel `Nomor Urut`. Ganti nama variabelnya sesuai konvensi penamaan variabel
- Pertahankan variabel `kampus`.

## Handling Missing Values (FINAL)

### Strategi per Variabel:

1. **jarak.km** (ITERA: 1 missing, UNILA: 1 missing)
   - **Keputusan**: Imputasi dengan **median** dataset masing-masing

2. **Jumlah.Perjalanan.<hari>** (UNILA: 1 observasi dengan SEMUA hari missing)
   - **Keputusan**: **DROP observasi** yang memiliki missing di semua variabel jumlah perjalanan

3. **kepemilikan.mobil / jumlah.mobil** (UBL: 3 missing)
   - **Keputusan**: Imputasi dengan **median** (0 atau 1)

4. **kepemilikan.sepeda / jumlah.sepeda** (UBL: 1 missing)
   - **Keputusan**: Imputasi dengan **median** (0 atau 1)

5. **biaya.dalam.ribu2 / biaya.dalam.ribu** (UBL: 1 missing dari outlier "20 JUTA RUPIAH")
   - **Keputusan**: **DROP observasi** dengan nilai NA di variabel ini

6. **nama.jalan.tempat.tinggal / alamat** (UBL: 4 missing)
   - **Keputusan**: **Biarkan NA** (variabel alamat tidak kritis untuk analisis)

### Estimasi Observasi Final:

- ITERA: 428 (tidak ada drop)
- UNILA: 394 (drop 1 observasi)
- UBL: 378 (drop 1 observasi dengan biaya NA)
- UINRIL: 400 (tidak ada drop)
- **TOTAL: 1,600 observasi**
