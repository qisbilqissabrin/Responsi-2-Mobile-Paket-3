# Responsi 2 Mobile Programming - Inventaris Buku
| Keterangan | Detail |
| :--- | :--- |
| **Nama** | Bilqis Sabrina Shatila |
| **NIM** | H1D023002 |
| **Shift Baru** | F |
| **Shift Asal** | H |

## Video Demo Aplikasi
*https://github.com/user-attachments/assets/22f1be79-01ed-4039-a226-85b9eb1c669e*

---

## Spesifikasi API

Aplikasi ini menggunakan REST API yang dibangun dengan CodeIgniter 4. Semua pertukaran data menggunakan format JSON.

**Base URL:** `http://localhost/toko-api/public` (atau sesuaikan dengan IP server Anda)

### A. Autentikasi

#### 1. Registrasi Member
Digunakan untuk mendaftarkan akun pengguna baru.

* **URL:** `/registrasi`
* **Method:** `POST`
* **Headers:** `Content-Type: application/json`
* **Body Request:**
  ```json
  {
    "nama": "Nama Lengkap",
    "email": "email@contoh.com",
    "password": "password123"
  }


  * **Response Success (200 OK):**
    ```json
    {
      "code": 200,
      "status": true,
      "data": "Registrasi Berhasil"
    }
    ```
  * **Response Error (400 Bad Request):**
    ```json
    {
      "code": 400,
      "status": false,
      "data": "Email sudah terdaftar" 
    }
    ```

#### 2\. Login Member

Digunakan untuk masuk dan mendapatkan akses token (jika diimplementasikan) atau validasi pengguna.

  * **URL:** `/login`
  * **Method:** `POST`
  * **Headers:** `Content-Type: application/json`
  * **Body Request:**
    ```json
    {
      "email": "email@contoh.com",
      "password": "password123"
    }
    ```
  * **Response Success (200 OK):**
    ```json
    {
      "code": 200,
      "status": true,
      "data": {
        "token": "auth_key_string_random...",
        "user": {
          "id": "1",
          "email": "email@contoh.com"
        }
      }
    }
    ```
  * **Response Error (400 Bad Request):**
    ```json
    {
      "code": 400,
      "status": false,
      "data": "Password tidak valid"
    }
    ```

-----

### B. Manajemen Data Buku (CRUD)

#### 1\. List Buku (Read All)

Menampilkan daftar seluruh buku yang tersimpan di database.

  * **URL:** `/buku`
  * **Method:** `GET`
  * **Response Success (200 OK):**
    ```json
    {
      "code": 200,
      "status": true,
      "data": [
        {
          "id": "1",
          "judul": "Pemrograman Flutter",
          "harga": "150000",
          "jumlah": "10",
          "tanggal_masuk": "2023-12-01",
          "volume": "1",
          "penulis": "Budi Santoso",
          "penerbit": "Tech Press"
        },
        {
          "id": "2",
          "judul": "Belajar CodeIgniter 4",
          "harga": "120000",
          "jumlah": "5",
          "tanggal_masuk": "2023-11-20",
          "volume": "2",
          "penulis": "Andi Wijaya",
          "penerbit": "Dev Books"
        }
      ]
    }
    ```

#### 2\. Detail Buku (Read One)

Menampilkan detail satu buku berdasarkan ID.

  * **URL:** `/buku/{id}`
  * **Method:** `GET`
  * **URL Params:** `id` (Integer)
  * **Response Success (200 OK):**
    ```json
    {
      "code": 200,
      "status": true,
      "data": {
        "id": "1",
        "judul": "Pemrograman Flutter",
        "harga": "150000",
        "jumlah": "10",
        "tanggal_masuk": "2023-12-01",
        "volume": "1",
        "penulis": "Budi Santoso",
        "penerbit": "Tech Press"
      }
    }
    ```

#### 3\. Tambah Buku (Create)

Menambahkan data buku baru ke dalam inventaris.

  * **URL:** `/buku`
  * **Method:** `POST`
  * **Headers:** `Content-Type: application/json`
  * **Body Request:**
    ```json
    {
      "judul": "Judul Buku Baru",
      "harga": "100000",
      "jumlah": "50",
      "tanggal_masuk": "2023-12-06",
      "volume": "1",
      "penulis": "Nama Penulis",
      "penerbit": "Nama Penerbit"
    }
    ```
  * **Response Success (200 OK):**
    ```json
    {
      "code": 200,
      "status": true,
      "data": {
        "id": "3",
        "judul": "Judul Buku Baru",
        "harga": "100000",
        "jumlah": "50",
        "tanggal_masuk": "2023-12-06",
        "volume": "1",
        "penulis": "Nama Penulis",
        "penerbit": "Nama Penerbit"
      }
    }
    ```

#### 4\. Ubah Buku (Update)

Memperbarui data buku yang sudah ada berdasarkan ID.

  * **URL:** `/buku/{id}`
  * **Method:** `PUT` (atau POST tergantung konfigurasi server)
  * **URL Params:** `id` (Integer)
  * **Headers:** `Content-Type: application/json`
  * **Body Request:**
    ```json
    {
      "judul": "Judul Buku Revisi",
      "harga": "125000",
      "jumlah": "45",
      "tanggal_masuk": "2023-12-06",
      "volume": "2",
      "penulis": "Nama Penulis Edit",
      "penerbit": "Nama Penerbit Edit"
    }
    ```
  * **Response Success (200 OK):**
    ```json
    {
      "code": 200,
      "status": true,
      "data": {
         "id": "1",
         "judul": "Judul Buku Revisi",
         ...
      }
    }
    ```

#### 5\. Hapus Buku (Delete)

Menghapus data buku dari database berdasarkan ID.

  * **URL:** `/buku/{id}`
  * **Method:** `DELETE`
  * **URL Params:** `id` (Integer)
  * **Response Success (200 OK):**
    ```json
    {
      "code": 200,
      "status": true,
      "data": {
         "id": "1",
         "judul": "Judul Buku Revisi",
         ...
      }
      // Note: Data yang dikembalikan bisa berupa objek buku yang dihapus atau pesan sukses
    }
    ```

<!-- end list -->

```
```

---

## Penjelasan Kode Aplikasi

Berikut adalah penjelasan fungsi dari setiap file utama dalam struktur proyek Flutter:

### 1. Helper & Konfigurasi
* **`lib/main.dart`**
    * Titik awal (*entry point*) aplikasi.
    * Mengatur tema aplikasi (Warna Coklat/`Colors.brown`).
    * Mengarahkan tampilan awal ke halaman `LoginPage`.
* **`lib/helper/api_url.dart`**
    * Kelas statis yang menyimpan seluruh *URL Endpoint* API di satu tempat agar mudah dikelola.
    * Menyediakan metode statis untuk *endpoint* yang membutuhkan ID (seperti `update`, `show`, `delete`).

### 2. Model (Data Layer)
* **`lib/model/login.dart`**
    * Memetakan respon JSON dari endpoint `/login` ke dalam objek Dart.
    * Menyimpan status autentikasi, token, dan ID user.
* **`lib/model/buku.dart`**
    * Memetakan respon JSON data buku ke dalam objek Dart.
    * Menangani konversi tipe data (misal: dari String JSON ke Integer Dart) untuk 7 atribut buku (`judul`, `harga`, `jumlah`, `tanggalMasuk`, `volume`, `penulis`, `penerbit`).

### 3. User Interface (UI)
* **`lib/ui/registrasi_page.dart`**
    * Menampilkan form pendaftaran (Nama, Email, Password, Konfirmasi Password).
    * **Fungsi `_submit()`**: Mengirim data via HTTP POST ke API registrasi dan menangani validasi input.
* **`lib/ui/login_page.dart`**
    * Menampilkan form login (Email, Password).
    * **Fungsi `_login()`**: Mengirim kredensial ke API. Jika kode respon 200, pengguna diarahkan ke halaman dashboard (`BukuPage`).
* **`lib/ui/buku_page.dart` (List Buku)**
    * Halaman utama setelah login.
    * **Fungsi `getBuku()`**: Mengambil daftar buku dari API menggunakan HTTP GET dan menampilkannya dalam `ListView`.
    * Memiliki navigasi ke halaman tambah buku dan fitur logout.
* **`lib/ui/buku_detail.dart`**
    * Menampilkan detail lengkap dari sebuah buku yang dipilih dari list.
    * Memiliki tombol **Edit** (navigasi ke form) dan **Delete**.
    * **Fungsi `deleteBuku()`**: Mengirim permintaan HTTP DELETE ke API untuk menghapus data.
* **`lib/ui/buku_form.dart`**
    * Halaman *reusable* untuk **Tambah Data** dan **Ubah Data**.
    * **Fungsi `isUpdate()`**: Mengecek apakah form menerima data buku (mode Edit) atau kosong (mode Tambah), lalu mengisi kolom teks secara otomatis jika mode Edit.
    * **Fungsi `submitData()`**: Menentukan apakah harus mengirim HTTP POST (Create) atau HTTP PUT (Update) berdasarkan keberadaan data buku.

---
