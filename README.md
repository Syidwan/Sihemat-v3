# SiHemat v3
Aplikasi pemantauan kendaraan berbasis Flutter yang dirancang untuk membantu individu dan perusahaan dalam melacak, mengelola, dan menganalisis penggunaan kendaraan secara real-time.
## Tentang Aplikasi
SiHemat merupakan aplikasi mobile yang menyediakan fitur pelacakan kendaraan (*GPS Tracking*), pemutaran ulang riwayat perjalanan (*Playback*), serta pengelolaan informasi kendaraan. Aplikasi ini mendukung tiga jenis pengguna:
- **Pengguna** — Individu/driver yang ditugaskan untuk satu kendaraan.
- **Korporasi** — Pemilik armada yang mengelola beberapa kendaraan.
- **Tamu** — Akses terbatas melalui plat nomor dan kode verifikasi.
## Fitur Utama
| Fitur | Deskripsi |
|---|---|
| 🔐 Login Multi-Role | Login sebagai Pengguna, Korporasi, atau Tamu |
| 🗺️ Live Tracking | Pelacakan posisi kendaraan secara real-time pada Google Maps |
| 🔄 Playback | Pemutaran ulang riwayat perjalanan dengan animasi rute |
| 📋 Daftar Kendaraan | Manajemen armada untuk korporasi |
| 🚗 Tambah Unit | Penambahan data kendaraan baru |
| 📊 Speedometer | Tampilan kecepatan kendaraan secara digital |
| 📄 Cek Pajak | Informasi pajak kendaraan (PKB, SWDKLLJ, PNBP) |
| 🔧 Troubleshoot | Panduan penyelesaian masalah |
| 📝 Laporan | Ringkasan data perjalanan kendaraan |
| ⚙️ Pengaturan | Konfigurasi aplikasi dan notifikasi |
## Tech Stack
- **Framework:** Flutter (Dart)
- **SDK:** `^3.9.2`
- **Maps:** Google Maps Flutter, Flutter Map
- **Backend:** Firebase (Auth, Firestore)
- **Font:** Google Fonts
- **PDF:** Flutter PDFView
- **UI:** Carousel Slider Plus, Material Design
## Struktur Proyek
```
lib/
├── main.dart                  # Entry point
├── pre_splash_screen.dart     # Animasi loading awal
├── splash_screen.dart         # Splash screen dengan logo
│
├── authentication/            # Autentikasi
│   ├── auth_selection_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── register_selection_screen.dart
│
├── home/                      # Halaman utama
│   ├── dashboard_screen.dart
│   ├── notification_screen.dart
│   ├── account/               # Fitur akun
│   ├── menu/                  # Fitur menu (tambah unit, pajak, dll)
│   └── track/                 # Fitur pelacakan
│
├── models/                    # Model data
│   ├── account.dart
│   ├── vehicle_model.dart
│   ├── route_history.dart
│   ├── menu_item.dart
│   └── repositories/         # Repository (data layer)
│
├── components/                # Komponen UI reusable
├── config/                    # Konfigurasi (warna, tema)
└── utils/                     # Utilitas (session, map utils)
```
## Prasyarat
- Flutter SDK `^3.9.2`
- Android SDK (min API 21 / Android 5.0)
- Google Maps API Key
## Instalasi
```bash
# Clone repository
git clone https://github.com/Syidwan/Sihemat-v3.git
# Masuk ke direktori
cd Sihemat-v3
# Install dependencies
flutter pub get
# Jalankan aplikasi
flutter run
```
## Konfigurasi Google Maps
Tambahkan API Key pada file `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
```
## Screenshot
> *Tambahkan screenshot aplikasi di sini*
## Lisensi
Proyek ini dibuat untuk keperluan Kerja Praktik.
---
