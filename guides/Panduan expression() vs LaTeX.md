# Panduan Pemformatan Rumus Matematis: `expression()` vs LaTeX

> Panduan ini membandingkan dua cara menulis rumus matematika yang sering digunakan dalam proyek R Markdown ini:
> - **LaTeX** → untuk teks naratif di `.Rmd` (di dalam `$...$` atau `$$...$$`)
> - **`expression()` / plotmath** → untuk label di dalam grafik ggplot2 (`labs()`, `annotate()`, `scale_*_*()`, dll.)

---

## Daftar Isi

1. [Subscript dan Superscript](#1-subscript-dan-superscript)
2. [Huruf Yunani (Greek Letters)](#2-huruf-yunani-greek-letters)
3. [Pecahan (Fractions)](#3-pecahan-fractions)
4. [Akar (Square Root)](#4-akar-square-root)
5. [Operator Matematika](#5-operator-matematika)
6. [Relasi](#6-relasi)
7. [Teks Dua Baris](#7-teks-dua-baris-multi-line)
8. [Menggabungkan Teks dan Simbol](#8-menggabungkan-teks-dan-simbol)
9. [Spasi](#9-spasi)
10. [Berbagai Notasi Statistika](#10-berbagai-notasi-statistika)
11. [Notasi Lanjut (Sum, Integral, Limit)](#11-notasi-lanjut)
12. [Cara Pakai di ggplot2](#12-cara-pakai-di-ggplot2)

---

## 1. Subscript dan Superscript

| Tampilan | LaTeX | `expression()` / plotmath |
|---|---|---|
| H₀ | `$H_0$` | `H[0]` |
| H₁ | `$H_1$` | `H[1]` |
| μ₀ | `$\mu_0$` | `mu[0]` |
| x² | `$x^2$` | `x^2` |
| σ² | `$\sigma^2$` | `sigma^2` |
| x̄ | `$\bar{x}$` | `bar(x)` |
| xᵢ | `$x_i$` | `x[i]` |
| x̂ | `$\hat{x}$` | `hat(x)` |
| x̃ | `$\tilde{x}$` | `tilde(x)` |
| aᵢⱼ | `$a_{ij}$` | `a[i*j]` _(tidak ideal)_ |

**Catatan penting:**
- Di LaTeX: `_{}` untuk subscript, `^{}` untuk superscript
- Di plotmath: `[]` untuk subscript, `^` untuk superscript

```r
# Contoh ggplot
labs(x = expression(H[0]), y = expression(sigma^2))
```

---

## 2. Huruf Yunani (Greek Letters)

| Simbol | LaTeX | `expression()` |
|---|---|---|
| α | `$\alpha$` | `alpha` |
| β | `$\beta$` | `beta` |
| γ | `$\gamma$` | `gamma` |
| δ | `$\delta$` | `delta` |
| ε | `$\varepsilon$` | `epsilon` |
| μ | `$\mu$` | `mu` |
| σ | `$\sigma$` | `sigma` |
| π | `$\pi$` | `pi` |
| χ | `$\chi$` | `chi` |
| ρ | `$\rho$` | `rho` |
| λ | `$\lambda$` | `lambda` |
| Σ (kapital) | `$\Sigma$` | `Sigma` |
| Δ (kapital) | `$\Delta$` | `Delta` |

**Aturan:** Di `expression()`, huruf Yunani cukup ditulis nama lengkapnya dalam huruf kecil. Untuk kapital, pakai huruf kapital di awal.

```r
# LaTeX di .Rmd:
# Taraf signifikansi $\alpha = 0.05$

# plotmath di ggplot:
labs(title = expression("Uji dengan" ~ alpha == 0.05))
```

---

## 3. Pecahan (Fractions)

| Tampilan | LaTeX | `expression()` |
|---|---|---|
| a/b (inline) | `$\frac{a}{b}$` | `frac(a, b)` |
| ½ | `$\frac{1}{2}$` | `frac(1, 2)` |
| α/2 | `$\frac{\alpha}{2}$` | `frac(alpha, 2)` |
| x̄ / σ | `$\frac{\bar{x}}{\sigma}$` | `frac(bar(x), sigma)` |

```r
# Contoh: label sumbu dengan pecahan
labs(y = expression(frac(bar(x) - mu[0], sigma / sqrt(n))))
```

---

## 4. Akar (Square Root)

| Tampilan | LaTeX | `expression()` |
|---|---|---|
| √x | `$\sqrt{x}$` | `sqrt(x)` |
| √n | `$\sqrt{n}$` | `sqrt(n)` |
| σ/√n | `$\frac{\sigma}{\sqrt{n}}$` | `frac(sigma, sqrt(n))` |
| ∛x (akar pangkat 3) | `$\sqrt[3]{x}$` | tidak ada padanan langsung |

```r
annotate("text", x = 0, y = 0.1, label = expression(frac(sigma, sqrt(n))))
```

---

## 5. Operator Matematika

| Simbol | LaTeX | `expression()` |
|---|---|---|
| ± | `$\pm$` | `%+-%` |
| × | `$\times$` | `%*%` |
| ÷ | `$\div$` | `%//%` _(pembagian integer)_ |
| · (titik tengah) | `$\cdot$` | `%.%` |
| ∞ | `$\infty$` | `infinity` |
| ∑ | `$\sum$` | `sum()` |
| ∏ | `$\prod$` | `prod()` |
| ∫ | `$\int$` | `integral()` _(terbatas)_ |

```r
# Contoh interval kepercayaan
labs(x = expression(bar(x) %+-% z[alpha/2] * frac(sigma, sqrt(n))))
```

---

## 6. Relasi

| Simbol | LaTeX | `expression()` |
|---|---|---|
| = | `$=$` | `==` _(dua sama dengan!)_ |
| ≠ | `$\neq$` | `!=` |
| < | `$<$` | `<` |
| > | `$>$` | `>` |
| ≤ | `$\leq$` | `<=` |
| ≥ | `$\geq$` | `>=` |
| ≈ | `$\approx$` | `%~~%` |
| ~ (tilde, distribusi) | `$\sim$` | `%~%` |
| ∈ | `$\in$` | `%in%` |

> ⚠️ **Penting:** Di `expression()`, operator `=` tunggal **tidak bekerja**. Harus pakai `==` untuk menampilkan tanda sama dengan.

```r
# SALAH ❌
expression(mu = 4)

# BENAR ✅
expression(mu == 4)
expression(H[0] : mu[0] == 4)
```

---

## 7. Teks Dua Baris (Multi-line)

| Tujuan | LaTeX | `expression()` |
|---|---|---|
| Dua baris teks | `\\` (di dalam `$$`) | `atop(baris1, baris2)` |

Di LaTeX, `\\` hanya bisa dalam mode align/array. Di `expression()`, tidak ada `\n` — gunakan `atop()`:

```r
# LaTeX (di .Rmd):
# $$
# H_0 : \mu = 4 \\
# H_1 : \mu \neq 4
# $$

# plotmath (di ggplot):
annotate("text",
  x = 0, y = 0.3,
  label = expression(atop(H[0] : mu == 4, H[1] : mu != 4))
)

# Tiga baris: atop bersarang
expression(atop(atop("Baris 1", "Baris 2"), "Baris 3"))
```

---

## 8. Menggabungkan Teks dan Simbol

Di LaTeX, teks dan simbol bisa bebas dicampurkan. Di `expression()`, ada dua operator penggabung:

| Operator | Efek | Contoh |
|---|---|---|
| `*` | gabung **tanpa spasi** | `"Nilai" * H[0]` → "NilaiH₀" |
| `~` | gabung **dengan spasi** | `"Nilai" ~ H[0]` → "Nilai H₀" |
| `paste()` | string biasa, tidak bisa campur simbol | `paste("A", "B")` |

```r
# LaTeX di .Rmd:
# "Area penerimaan $H_0$ sebesar 95%"

# expression() di ggplot — 3 cara:
expression("Area penerimaan" ~ H[0] ~ "(95%)")       # spasi otomatis
expression("Area penerimaan " * H[0] * " (95%)")     # manual
expression(atop("Area penerimaan" ~ H[0], "(95%)"))   # dua baris
```

---

## 9. Spasi

| Jenis Spasi | LaTeX | `expression()` |
|---|---|---|
| Spasi biasa | `\ ` (backslash spasi) | `~` |
| Spasi tipis | `\,` | tidak ada padanan langsung |
| Spasi lebar | `\quad` | tidak ada padanan langsung |
| Tanpa spasi | (default) | `*` |

```r
# Spasi di expression():
expression(alpha ~ "=" ~ 0.05)       # α = 0.05 dengan spasi
expression(mu[0] == 4 ~ "km")        # μ₀ = 4 km
```

---

## 10. Berbagai Notasi Statistika

Berikut notasi-notasi yang sering muncul di modul statistika:

| Notasi | LaTeX | `expression()` |
|---|---|---|
| H₀ : μ = μ₀ | `$H_0 : \mu = \mu_0$` | `H[0] : mu == mu[0]` |
| H₁ : μ ≠ μ₀ | `$H_1 : \mu \neq \mu_0$` | `H[1] : mu != mu[0]` |
| H₁ : μ < μ₀ | `$H_1 : \mu < \mu_0$` | `H[1] : mu < mu[0]` |
| H₁ : μ > μ₀ | `$H_1 : \mu > \mu_0$` | `H[1] : mu > mu[0]` |
| Z = (x̄ - μ) / (σ/√n) | `$Z = \frac{\bar{x} - \mu}{\sigma/\sqrt{n}}$` | `Z == frac(bar(x) - mu, sigma/sqrt(n))` |
| p̂ | `$\hat{p}$` | `hat(p)` |
| x̄ | `$\bar{x}$` | `bar(x)` |
| s² | `$s^2$` | `s^2` |
| α = 0.05 | `$\alpha = 0.05$` | `alpha == 0.05` |
| ±1.96 | `$\pm 1.96$` | `%+-% ~ 1.96` |

```r
# Contoh penggunaan dalam judul grafik
labs(
  title = expression("Uji Z: " * Z == frac(bar(x) - mu[0], sigma / sqrt(n))),
  subtitle = expression(alpha == 0.05 ~ "(Two-tailed)")
)
```

---

## 11. Notasi Lanjut

### Sigma Notasi (Penjumlahan)
| | LaTeX | `expression()` |
|---|---|---|
| Σ sederhana | `$\sum x_i$` | `sum(x[i])` |
| Σ dengan batas | `$\sum_{i=1}^{n} x_i$` | `sum(x[i], i==1, n)` |

```r
labs(y = expression(sum(x[i]^2, i == 1, n)))
```

### Integral
```r
# Plotmath mendukung integral dasar
expression(integral(f(x)*dx, -infinity, infinity))
```

### Limit
```r
expression(lim(f(x), x %->% infinity))
```

### Matriks / Vektor (tidak tersedia di plotmath)
Untuk notasi matriks yang kompleks, tetap gunakan LaTeX di teks naratif `.Rmd`. `expression()` tidak cocok untuk notasi sekompleks ini.

---

## 12. Cara Pakai di ggplot2

### Di `labs()` — judul, sumbu, caption
```r
ggplot(df, aes(x, y)) +
  labs(
    title = expression("Distribusi Normal: " * alpha == 0.05),
    x = expression(bar(x) ~ "(km)"),
    y = "Densitas",
    caption = expression(H[0] : mu == 4)
  )
```

### Di `annotate()` — label di dalam grafik
```r
annotate("text",
  x = 1, y = 0.2,
  label = expression(atop("Area Penerimaan" ~ H[0], "(95%)")),
  size = 4,
  color = "darkblue"
)
```

### Di `scale_x_continuous()` / `scale_y_continuous()` — label sumbu dengan breaks
```r
scale_x_continuous(
  breaks = c(-1.96, 0, 1.96),
  labels = expression(-z[alpha/2], 0, z[alpha/2])
)
```

### Di `geom_text()` / `geom_label()` — perlu `parse = TRUE`
```r
# Jika label disimpan dalam kolom data frame, gunakan parse = TRUE
df_label <- data.frame(x = 0, y = 0.2, teks = "H[0]")
geom_text(data = df_label, aes(x, y, label = teks), parse = TRUE)
```

> ⚠️ **Perbedaan penting:** `annotate()` langsung menerima `expression()`. Tapi `geom_text()` / `geom_label()` membutuhkan `parse = TRUE` dan label berupa **string karakter**, bukan `expression()`.

---

## Ringkasan Cepat

```r
# Subscript
expression(H[0])           # H₀
expression(mu[0])          # μ₀

# Superscript
expression(sigma^2)        # σ²
expression(chi^2)          # χ²

# Huruf Yunani
expression(alpha)          # α
expression(mu)             # μ

# Pecahan
expression(frac(a, b))     # a/b

# Akar
expression(sqrt(n))        # √n

# Dua baris
expression(atop("Baris 1", "Baris 2"))

# Gabung teks
expression("Teks" ~ H[0])        # spasi
expression("Teks" * H[0])        # tanpa spasi

# Relasi (= pakai ==, bukan =)
expression(mu == 4)        # μ = 4
expression(mu != 4)        # μ ≠ 4
expression(mu <= 4)        # μ ≤ 4
```

---

## Referensi

- Dokumentasi plotmath R: `?plotmath` di konsol R
- [R Graphics Cookbook — Mathematical Annotations](https://r-graphics.org/)
- [ggplot2 — Aesthetic Specifications](https://ggplot2.tidyverse.org/articles/ggplot2-specs.html)
- [LaTeX Mathematical Expressions — Overleaf](https://www.overleaf.com/learn/latex/Mathematical_expressions)
