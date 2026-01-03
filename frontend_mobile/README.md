# Frontend Mobile - Masjid Al-Mahally

Aplikasi mobile Flutter untuk Masjid Al-Mahally yang menyediakan informasi kajian, laporan keuangan, dan fitur admin.

## Fitur

### Publik

- **Beranda**: Informasi tentang masjid dengan quote harian dan layanan
- **Tentang**: Visi dan misi masjid
- **Kajian**: Daftar jadwal kajian yang akan datang
- **Keuangan**: Laporan transparansi keuangan masjid
- **Kontak**: Informasi kontak masjid

### Admin

- **Login Admin**: Autentikasi admin
- **Dashboard Admin**: Menu utama admin
- **Kelola Kajian**: Tambah, lihat, dan hapus jadwal kajian
- **Kelola Keuangan**: Tambah transaksi pemasukan/pengeluaran

## Struktur Proyek

```
lib/
├── core/
│   └── app_theme.dart          # Tema aplikasi
├── models/
│   ├── admin.dart              # Model Admin
│   ├── lecture.dart            # Model Lecture
│   └── cashflow.dart           # Model Cashflow
├── providers/
│   ├── auth_provider.dart      # Provider untuk autentikasi
│   └── masjid_provider.dart    # Provider untuk data masjid
├── services/
│   ├── api_service.dart        # Service API base
│   ├── auth_service.dart       # Service autentikasi
│   ├── lecture_service.dart    # Service untuk lectures
│   └── cashflow_service.dart   # Service untuk cashflow
├── screens/
│   ├── home_screen.dart        # Halaman beranda
│   ├── about_screen.dart       # Halaman tentang
│   ├── lectures_screen.dart    # Halaman kajian
│   ├── cashflow_screen.dart    # Halaman keuangan
│   ├── contact_screen.dart     # Halaman kontak
│   └── admin/
│       ├── admin_login_screen.dart      # Login admin
│       ├── admin_dashboard_screen.dart  # Dashboard admin
│       ├── admin_lectures_screen.dart   # Kelola kajian
│       └── admin_cashflow_screen.dart   # Kelola keuangan
├── widgets/
│   └── custom_drawer.dart      # Drawer navigasi
└── main.dart                   # Entry point aplikasi
```

## Setup dan Instalasi

1. **Pastikan Flutter terinstall**:

   ```bash
   flutter --version
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Jalankan backend** (pastikan backend berjalan di localhost:3000):

   ```bash
   cd ../backend
   npm install
   npm run dev
   ```

4. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

## Konfigurasi API

API base URL dikonfigurasi di `services/api_service.dart`:

- Untuk emulator Android: `http://10.0.2.2:3000`
- Untuk device fisik: ganti dengan IP address komputer

## Dependencies

- **provider**: State management
- **http**: HTTP requests
- **intl**: Internationalization (formatting tanggal dan currency)

## Catatan

- Aplikasi ini terintegrasi dengan backend Node.js yang menggunakan Prisma dan SQLite
- Admin login menggunakan username/password dari backend
- Data tersimpan di database backend

## Pengembangan

Untuk menambah fitur baru:

1. Tambahkan model di `models/`
2. Buat service di `services/`
3. Update provider di `providers/`
4. Buat screen di `screens/`
5. Update navigasi di `custom_drawer.dart`
