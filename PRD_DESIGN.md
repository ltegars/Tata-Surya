# PRD DESIGN — JELAJAH TATA SURYA

## 1. Design Overview

**Nama:** Jelajah Tata Surya  
**Design Direction:** Soft Space UI  
**Target:** Siswa SMP usia 12–15 tahun

### Design Goal

Menciptakan aplikasi edukasi Tata Surya yang:

- mudah dipahami
- modern
- soft
- tenang
- visual
- ramah untuk remaja
- memiliki identitas astronomi yang kuat

### Visual Reference

Arah visual:

> **Modern planetarium + educational mobile app**

Bukan:

- cyberpunk
- neon futuristic
- AI dashboard
- SaaS dashboard
- terlalu childish
- glassmorphism berlebihan

---

# 2. Design Principles

## 2.1 Soft

Warna lembut dan tidak agresif.

## 2.2 Simple

Satu layar memiliki satu fokus utama.

## 2.3 Educational

Informasi harus mudah dibaca siswa SMP.

## 2.4 Visual First

Planet menjadi elemen visual utama.

## 2.5 Consistent

Warna, typography, icon, spacing, card, dan button harus konsisten.

---

# 3. Color Palette

## Base Colors

| Token | Hex | Usage |
|---|---|---|
| Deep Space | `#0E1525` | Main background |
| Surface | `#171F33` | Cards and sections |
| Surface Elevated | `#222B42` | Elevated components |
| Border | `#30394F` | Borders and dividers |

## Accent Colors

| Token | Hex | Usage |
|---|---|---|
| Muted Lavender | `#A59BE8` | Primary action / active state |
| Pale Lavender | `#D8D2F2` | Soft highlight |
| Warm White | `#E6E0D4` | Warm accent |

## Text Colors

| Token | Hex | Usage |
|---|---|---|
| Primary Text | `#F3F3F7` | Main text |
| Secondary Text | `#AEB5C5` | Supporting text |

---

# 4. Color Usage Rules

UI tidak boleh terlihat seperti pelangi.

### Dominant

```text
Navy + Neutral
```

### Primary accent

```text
Muted Lavender
```

### Secondary accent

```text
Warm Neutral
```

### Planet colors

Planet boleh menggunakan warna natural masing-masing.

Contoh:

- Earth → natural blue/green
- Mars → muted red
- Jupiter → cream/brown
- Saturn → pale yellow/brown
- Neptune → muted blue

Warna planet merupakan sumber warna visual utama.

### Hindari

- neon cyan
- neon magenta
- neon green
- gradient ungu-biru yang mencolok
- glow berlebihan
- setiap card memiliki warna berbeda

---

# 5. Typography

## Primary Font

**Plus Jakarta Sans**

Alternative:

**Inter**

## Type Scale

| Style | Size | Weight |
|---|---:|---|
| Display | 32–36 px | Bold |
| Heading | 24–28 px | SemiBold |
| Section | 20–24 px | SemiBold |
| Body | 15–17 px | Regular |
| Caption | 12–14 px | Medium |

### Typography Principles

- mudah dibaca
- tidak terlalu futuristik
- tidak terlalu dekoratif
- line-height nyaman
- gunakan hierarchy yang jelas

---

# 6. Iconography

## Style

Gunakan:

- outline icon
- simple geometric icon
- consistent stroke
- rounded visual language

### Tidak menggunakan emoji.

Contoh:

| Function | Icon Direction |
|---|---|
| Planet | Planet / orbit |
| AR | Scan / cube |
| Quiz | Clipboard / question |
| Settings | Gear |
| Audio | Speaker |
| Play | Triangle |
| Back | Arrow |

Icon harus menggunakan gaya yang konsisten di seluruh aplikasi.

---

# 7. Shape Language

## Border Radius

| Component | Radius |
|---|---:|
| Small component | 12 px |
| Medium component | 16 px |
| Main card | 20–24 px |
| Button | 14–16 px |

Gunakan rounded corners secukupnya.

Hindari bentuk yang terlalu pill-shaped untuk semua komponen.

---

# 8. Card System

## Standard Card

```text
Background: #171F33
Border: #30394F
Radius: 20 px
```

### Character

- soft
- solid
- low contrast
- subtle depth

### Shadow

Gunakan shadow ringan dengan opacity rendah.

Tidak menggunakan dramatic shadow.

---

# 9. Glassmorphism

Glassmorphism digunakan sebagai **aksen**, bukan sebagai identitas seluruh interface.

### Boleh digunakan untuk

- AR overlay
- floating information
- planet information overlay
- bottom navigation jika diperlukan

### Tidak perlu digunakan untuk

- semua feature cards
- seluruh halaman
- setiap button
- setiap component

Tujuan:

> Mempertahankan visual soft dan solid tanpa menjadi template glassmorphism generik.

---

# 10. Background Style

### Base

Deep navy.

### Decorative elements

Gunakan secara minimal:

- star particles
- orbit line
- atmospheric glow
- subtle space texture

### Hindari

- terlalu banyak bintang
- nebula neon
- particle berlebihan
- glow di setiap elemen
- dekorasi acak

Background harus mendukung planet sebagai focal point.

---

# 11. Planet Illustration Style

Planet adalah salah satu identitas visual utama.

### Style

- semi-realistic
- polished
- natural
- clean
- realistic texture
- tidak terlalu cartoon
- tidak seperti clipart

### Focus

Planet harus terlihat jelas bahkan ketika UI sederhana.

---

# 12. Home Screen Design

## Struktur

```text
Header
↓
Hero
↓
Fitur Utama
↓
Tahukah Kamu?
↓
Bottom Navigation
```

---

## 12.1 Header

```text
[Planet Logo]
Jelajah Tata Surya
                         [Settings]
```

### Aturan

- tidak ada profile/avatar
- tidak ada daily mission
- tidak ada progress bar
- tidak ada badge tambahan yang tidak diperlukan

---

# 13. Hero Section

### Content

```text
Halo, Penjelajah!

Jelajahi
Tata Surya

Kenali planet, temukan fakta menarik,
dan jelajahi luar angkasa.

[ Mulai Eksplorasi → ]
```

### Planet Visual

Gunakan Earth atau planet utama:

- besar
- terintegrasi dengan background
- tidak berada di dalam kotak gambar
- sedikit overlap
- subtle lighting

Planet harus terasa sebagai bagian dari scene.

---

# 14. Feature Section

## Title

```text
Fitur Utama
```

## Layout

2 × 2 grid.

### Card 1

```text
Planet Explorer

Kenali 8 planet
```

### Card 2

```text
Tata Surya

Lihat gerakan planet
```

### Card 3

```text
AR Explorer

Lihat planet di sekitarmu
```

### Card 4

```text
Kuis Tata Surya

Uji pengetahuanmu
```

### Card Rules

Setiap card memiliki:

- icon
- title
- short description
- arrow
- generous spacing
- subtle border
- simple illustration bila diperlukan

Jangan memenuhi card dengan terlalu banyak dekorasi.

---

# 15. Tahukah Kamu?

## Layout

Horizontal card.

### Content

```text
Tahukah Kamu?

Jupiter adalah planet terbesar
di Tata Surya.

Pelajari lebih lanjut →
```

### Visual

Tambahkan ilustrasi Jupiter kecil di salah satu sisi.

Fakta harus ditampilkan lengkap dan mudah dibaca.

Jangan memotong teks dengan `...`.

---

# 16. Bottom Navigation

Gunakan empat item:

```text
Beranda
Planet
AR
Quiz
```

### Active state

Muted Lavender.

### Inactive state

Secondary Text.

### Rules

- icon konsisten
- label jelas
- tidak menggunakan emoji
- tidak terlalu tinggi
- mudah disentuh

---

# 17. Planet Explorer Design

### Header

```text
Planet
```

### Layout

Grid planet 2 kolom.

Setiap card:

- planet illustration
- nama planet
- short category
- arrow

### Visual Priority

```text
Planet
↓
Name
↓
Short information
```

Jangan memasukkan terlalu banyak statistik pada card.

---

# 18. Detail Planet Design

### Struktur

```text
Back
↓
Planet Visual
↓
Name + subtitle
↓
Quick Stats
↓
Description
↓
Audio
↓
3D
↓
AR
```

### Planet Visual

Menjadi focal point terbesar.

### Stats

Gunakan card/stat row sederhana.

Contoh:

```text
Diameter
6.779 km

Temperature
-63°C

Moons
2
```

---

# 19. 3D Explorer Design

UI harus minimal.

### Layout

```text
Back

        [3D Planet]

Drag untuk memutar
Pinch untuk memperbesar

[ Information ]
```

Jangan menempatkan banyak button di layar.

---

# 20. Solar System Design

### Visual

Matahari di tengah.

Orbit menggunakan garis lembut.

Planet menggunakan warna natural.

### Controls

```text
[ Play / Pause ]
[ Speed ]
```

Controls harus tetap sederhana.

Tidak menggunakan banyak panel floating.

---

# 21. AR Design

AR screen harus fokus pada kamera dan planet.

### Overlay

Gunakan glass/transparent dark panel secukupnya.

Controls:

- Reset
- Rotate
- Zoom
- Info

### Prinsip

Jangan membuat AR screen terlihat seperti HUD game sci-fi.

---

# 22. Quiz Design

### Layout

```text
Pertanyaan 3 dari 10

Planet manakah yang
dikenal sebagai
Planet Merah?

[ Venus ]
[ Mars ]
[ Jupiter ]
[ Merkurius ]
```

### Design

- typography besar
- option card jelas
- tap target besar
- feedback mudah dibaca

Correct dan incorrect state harus menggunakan perubahan visual yang jelas tetapi tetap soft.

---

# 23. Button System

## Primary Button

```text
Background: #A59BE8
Text: #171426
Radius: 14–16 px
```

Contoh:

```text
Mulai Eksplorasi →
```

## Secondary Button

Gunakan outline/subtle surface.

## Icon Button

Gunakan elevated surface dengan icon yang jelas.

---

# 24. Spacing

Gunakan spacing konsisten.

Recommended base spacing:

```text
4
8
12
16
24
32
48
```

### General Rule

Gunakan whitespace yang cukup.

Jangan memenuhi layar.

---

# 25. Responsive Behavior

Design harus tetap nyaman pada:

- small Android phones
- standard Android phones
- larger Android phones

### Prioritas

1. readable text
2. tap target
3. consistent spacing
4. planet visual tidak terpotong
5. feature card tetap mudah dipahami

---

# 26. Accessibility

### Text

Pastikan kontras memadai.

### Tap Target

Minimal area interaksi sekitar **44–48 dp**.

### Information

Jangan mengandalkan warna saja untuk menyampaikan status.

### Language

Gunakan Bahasa Indonesia yang sederhana.

---

# 27. Design Do / Don't

## Do

- soft colors
- natural planet colors
- simple icons
- strong hierarchy
- generous spacing
- realistic/semi-realistic planets
- calm space atmosphere

## Don't

- emoji
- neon palette
- cyberpunk
- excessive gradient
- excessive glassmorphism
- too many accent colors
- overdecorated cards
- tiny text
- excessive glow
- generic AI dashboard aesthetic

---

# 28. Final Visual Direction

Target visual akhirnya:

> **Soft, calm, modern, educational space interface.**

Visual should feel like:

**digital planetarium + modern educational app**

Bukan:

**AI dashboard + sci-fi game + neon interface.**
