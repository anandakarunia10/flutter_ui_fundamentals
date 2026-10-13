# Course Explorer v2 - State Management & Architecture

Aplikasi Flutter Course Explorer v2 yang diimplementasikan dengan arsitektur modular, penerapan *Separation of Concerns*, dan *State Management* berbasis `Provider`.

## Identitas Mahasiswa
- **Nama**: Gede Ananda Karunia Putra
- **NIM**: 2455011010
- **Kelas**: TRPL 5A

---

## Arsitektur & Tanggung Jawab Folder (`lib/`)

Aplikasi ini menerapkan aliran *Dependency Direction*:
`UI Layer (Screens/Widgets)` → `Provider Layer` → `Repository Layer` → `Service Layer`

Berikut adalah rincian tanggung jawab setiap direktori di dalam project:

- `lib/models/`: Menyimpan class representasi data mentah (misal: `course.dart`) dan menangani parsing data `Course.fromJson()`.
- `lib/services/`: Mengelola detail teknis pengambilan data mentah dari sumber data (`course_service.dart`), seperti membaca file JSON/API tanpa melibatkan elemen UI.
- `lib/repositories/`: Menyediakan lapisan abstraksi data (`course_repository.dart`) yang menghubungkan Service dengan Provider, sehingga sumber data bisa diganti tanpa mengubah logika bisnis UI.
- `lib/providers/`: Mengelola *application state*, logika bisnis, dan *async state* (`loading`, `success`, `error`) menggunakan `ChangeNotifier` (`course_provider.dart`).
- `lib/screens/`: Menampilkan antarmuka halaman utama dan navigasi aplikasi (`home_page.dart`, `courses_list_page.dart`, `favorites_page.dart`, `main_screen.dart`).
- `lib/widgets/`: Menyimpan komponen UI modular yang dapat digunakan kembali (*reusable widgets*), seperti `course_card.dart` dan `student_header_card.dart`.

---

## Fitur Utama
- *Shared Favorites State* yang tersinkronisasi secara *real-time* di seluruh screen.
- Penanganan *Async State* (`Loading`, `Success`, `Error Recovery`).
- Navigasi responsif berbasis Bottom Navigation Bar & Tab View.