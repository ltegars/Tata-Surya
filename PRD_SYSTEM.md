# PRD & SYSTEM — JELAJAH TATA SURYA

## 1. Product Overview

**Nama aplikasi:** Jelajah Tata Surya  
**Jenis:** Aplikasi edukasi interaktif  
**Target pengguna:** Siswa SMP, sekitar 12–15 tahun  
**Platform utama:** Android  
**Framework:** Flutter  
**Bahasa:** Bahasa Indonesia

### Tujuan Produk

Membantu siswa memahami Tata Surya melalui pengalaman interaktif berupa eksplorasi planet, animasi orbit, 3D, AR, audio, dan kuis.

### Prinsip Utama

> **Explore → Learn → Interact**

Pengguna melihat, mengeksplorasi, lalu memahami materi.

---

## 2. Problem Statement

Pembelajaran Tata Surya sering bergantung pada gambar 2D, buku teks, diagram statis, dan penjelasan panjang. Hal tersebut dapat membuat konsep seperti ukuran planet, urutan planet, orbit, dan karakteristik planet sulit divisualisasikan.

Aplikasi ini memberikan pengalaman yang lebih interaktif melalui:

- Visual planet
- Informasi singkat
- Animasi orbit
- Eksplorasi 3D
- Augmented Reality (AR)
- Audio narasi
- Kuis interaktif

---

## 3. Product Goals

Aplikasi harus membantu pengguna:

1. Mengenali 8 planet dalam Tata Surya.
2. Memahami karakteristik dasar setiap planet.
3. Memahami posisi dan pergerakan planet.
4. Melihat planet dalam bentuk 3D.
5. Mengeksplorasi planet menggunakan AR.
6. Mendengarkan penjelasan singkat tentang planet.
7. Menguji pemahaman melalui kuis.

### Non-Goals

Versi awal aplikasi tidak memerlukan:

- Sistem akun kompleks
- Daily mission
- Streak
- Learning progress
- Leaderboard
- Ranking
- Sistem poin yang kompleks
- Pembayaran
- Backend kompleks

---

## 4. Information Architecture

```text
Jelajah Tata Surya
│
├── Beranda
│
├── Planet
│   ├── Daftar Planet
│   └── Detail Planet
│       ├── Informasi
│       ├── Audio
│       ├── 3D Explorer
│       └── AR
│
├── Tata Surya
│   └── Orbit Animation
│
├── AR
│   └── AR Explorer
│
├── Quiz
│   ├── Pertanyaan
│   ├── Feedback
│   └── Hasil
│
└── Tentang / Sumber
```

---

# 5. Functional Requirements

## 5.1 Beranda

### Tujuan

Beranda menjadi pusat navigasi aplikasi dan memberikan akses cepat ke fitur utama.

### Konten

- Header aplikasi
- Hero section
- Visual planet
- Planet Explorer
- Tata Surya
- AR Explorer
- Kuis Tata Surya
- Tahukah Kamu?

### Tidak termasuk

- Daily mission
- Streak
- Progress belajar
- Profile system

---

## 5.2 Planet Explorer

Menampilkan delapan planet:

1. Merkurius
2. Venus
3. Bumi
4. Mars
5. Jupiter
6. Saturnus
7. Uranus
8. Neptunus

Setiap planet memiliki:

- Ilustrasi planet
- Nama
- Kategori/tipes planet
- Akses ke halaman detail

---

## 5.3 Detail Planet

Setiap halaman planet minimal memiliki:

- Nama planet
- Urutan dari Matahari
- Diameter
- Jarak dari Matahari
- Suhu rata-rata
- Jumlah satelit
- Deskripsi
- Fakta menarik

### Fitur

- Audio
- 3D Explorer
- AR Explorer

### Contoh struktur

```text
Mars
Planet Merah

[ Planet 3D ]

Jarak dari Matahari
227,9 juta km

Diameter
6.779 km

Suhu rata-rata
-63°C

Jumlah satelit
2

Tentang Mars
...

[ Dengarkan ]
[ Jelajahi 3D ]
[ Buka AR ]
```

---

## 5.4 Audio

Audio tersedia pada halaman Detail Planet.

### Tujuan

Memberikan narasi pendek agar pengguna dapat belajar melalui suara.

### Kontrol

- Play
- Pause
- Seek
- Progress indicator

Durasi target:

**20–60 detik per planet**

Audio bukan fitur navigasi utama dan tidak perlu memiliki halaman tersendiri.

---

## 5.5 3D Explorer

Menampilkan model planet dalam bentuk 3D.

### Interaksi

- Drag → rotate
- Pinch → zoom
- Double tap → reset view
- Tombol informasi → menampilkan informasi singkat

### Prinsip

UI dibuat minimal agar planet menjadi fokus utama.

---

## 5.6 Tata Surya

Menampilkan Matahari dan delapan planet dalam visualisasi orbit.

### Fitur

- Play
- Pause
- Kontrol kecepatan
- Pilih planet
- Info singkat planet
- Navigasi ke Detail Planet

### Contoh

```text
        Neptune
    Uranus
       Saturn
        Jupiter
          Mars
         Earth
        Venus
      Mercury
          Sun

[ Play / Pause ]   [ Speed ]
```

---

## 5.7 AR Explorer

### Tujuan

Memungkinkan pengguna menempatkan planet virtual pada lingkungan nyata.

### User Flow

```text
Open AR
   ↓
Scan Surface
   ↓
Tap Surface
   ↓
Place Planet
   ↓
Rotate / Zoom
   ↓
View Information
```

### Interaction

- Scan permukaan
- Menempatkan planet
- Rotate
- Zoom
- Reset
- Melihat informasi

### Compatibility

Fitur AR bergantung pada kemampuan dan kompatibilitas perangkat Android.

Jika perangkat tidak mendukung AR, aplikasi harus memberikan informasi yang jelas dan menyediakan fallback menuju mode 3D.

---

## 5.8 Quiz

Format utama:

**Multiple Choice**

### Contoh

```text
Planet manakah yang dikenal
sebagai Planet Merah?

A. Venus
B. Mars
C. Jupiter
D. Merkurius
```

### Setelah menjawab

Tampilkan:

- Correct / Incorrect
- Penjelasan singkat
- Tombol pertanyaan berikutnya

### Result

```text
Quiz selesai!

8 / 10

Kamu menjawab 8 pertanyaan
dengan benar.

[ Ulangi Quiz ]
[ Kembali ke Beranda ]
```

Tidak menggunakan leaderboard atau ranking.

---

# 6. Navigation System

## Bottom Navigation

```text
Beranda
Planet
AR
Quiz
```

### Tab

- **Beranda** → Home
- **Planet** → Planet Explorer
- **AR** → AR Explorer
- **Quiz** → Quiz

### Tata Surya

Tidak menjadi tab utama. Fitur diakses dari Beranda atau Planet Explorer.

---

# 7. Route Structure

Contoh route:

```text
/
 /planets
 /planet/:id
 /solar-system
 /ar
 /quiz
 /quiz/result
 /about
```

Implementasi route dapat menggunakan pendekatan Flutter yang sesuai dengan kebutuhan project.

---

# 8. User Flow

```text
                     HOME
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
      PLANET      SOLAR SYSTEM      AR
        │             │             │
        ▼             ▼             │
   PLANET DETAIL   SELECT PLANET    │
        │             │             │
    ┌───┼───┐         │             │
    ▼   ▼   ▼         ▼             ▼
  Audio 3D  AR   Planet Detail   AR Explorer

                      │
                      ▼
                    QUIZ
                      │
                      ▼
                    RESULT
```

---

# 9. Data Model

Contoh model data planet:

```dart
class Planet {
  final String id;
  final String name;
  final int orderFromSun;
  final String type;
  final String description;
  final String diameter;
  final String distanceFromSun;
  final String temperature;
  final int moons;
  final String imageAsset;
  final String model3dAsset;
  final String audioAsset;
}
```

Data dapat disimpan secara lokal untuk versi prototype.

---

# 10. Quiz Data Model

Contoh:

```dart
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}
```

---

# 11. Technical Architecture

```text
Flutter App
│
├── Presentation
│   ├── Screens
│   ├── Widgets
│   └── Theme
│
├── Data
│   ├── Planet Data
│   ├── Quiz Data
│   └── Facts
│
├── Services
│   ├── Audio
│   ├── 3D
│   └── AR
│
└── Navigation
```

### Teknologi utama

- Flutter
- Dart
- Local data/assets
- Audio player
- 3D rendering solution
- AR framework/plugin

Backend tidak wajib untuk prototype.

---

# 12. Asset Requirements

Aplikasi membutuhkan:

### Planet

- 8 visual planet
- Model 3D planet
- Thumbnail planet
- Visual Tata Surya

### Audio

- Narasi untuk setiap planet
- Format audio yang sesuai untuk mobile

### AR

- 3D assets yang kompatibel dengan sistem AR yang dipilih

### Quiz

- Ilustrasi pendukung jika dibutuhkan

---

# 13. Error & Empty States

Aplikasi harus menyediakan feedback untuk kondisi seperti:

### AR tidak tersedia

```text
Perangkat ini belum mendukung AR.

Coba gunakan mode 3D untuk
tetap menjelajahi planet.
```

### Audio gagal dimuat

```text
Audio belum dapat diputar.

Coba lagi.
```

### Asset gagal dimuat

Tampilkan placeholder yang jelas tanpa merusak layout.

---

# 14. Non-functional Requirements

Aplikasi harus:

- mudah digunakan siswa SMP
- memiliki navigasi konsisten
- responsif terhadap berbagai ukuran layar Android
- memiliki feedback yang jelas untuk tindakan pengguna
- tidak bergantung pada backend untuk konten dasar
- memiliki fallback untuk fitur yang bergantung pada perangkat
- menghindari layar yang penuh informasi
- mengutamakan performa pada perangkat mobile

---

# 15. MVP Scope

### Wajib untuk MVP

- Beranda
- Planet Explorer
- Detail Planet
- Informasi 8 planet
- Audio planet
- Tata Surya + orbit animation
- Quiz
- Navigation
- 3D planet basic

### Setelah MVP

- AR
- Audio lebih lengkap
- Animasi tambahan
- Sumber/materi tambahan
- Optimasi performa

---

# 16. Success Criteria

Prototype dianggap berhasil ketika:

- Pengguna dapat menemukan 8 planet.
- Pengguna dapat membuka Detail Planet.
- Pengguna dapat membaca informasi planet.
- Pengguna dapat memutar audio.
- Pengguna dapat melihat planet dalam 3D.
- Pengguna dapat melihat animasi orbit.
- Pengguna dapat mengerjakan quiz.
- Navigasi antar fitur berjalan konsisten.
- AR dapat dibuka pada perangkat yang kompatibel.
