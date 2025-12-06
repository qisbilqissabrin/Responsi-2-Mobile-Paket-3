class ApiUrl {
  // GANTI IP INI SESUAI KEBUTUHAN:
  // - 10.0.2.2 : Jika menggunakan Emulator Android bawaan Android Studio
  // - IP LAN (misal 192.168.1.x) : Jika menggunakan HP fisik (pastikan satu Wi-Fi)
  static const String baseUrl = 'http://192.168.100.22:8080';

  // Endpoint Auth
  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // Endpoint Buku (CRUD)
  static const String listBuku = '$baseUrl/buku';
  static const String createBuku = '$baseUrl/buku';

  // Untuk update dan delete butuh ID, jadi kita buat method statis
  static String updateBuku(int id) {
    return '$baseUrl/buku/$id'; 
  }

  static String showBuku(int id) {
    return '$baseUrl/buku/$id';
  }

  static String deleteBuku(int id) {
    return '$baseUrl/buku/$id';
  }
}