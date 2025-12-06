class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  // Factory method untuk mengubah JSON menjadi objek Login
  factory Login.fromJson(Map<String, dynamic> obj) {
    if (obj['code'] == 200) {
      // Jika login sukses (Code 200), ambil data token dan user
      return Login(
        code: obj['code'],
        status: obj['status'],
        token: obj['data']['token'],
        userID: int.parse(obj['data']['user']['id'].toString()),
        userEmail: obj['data']['user']['email'],
      );
    } else {
      // Jika login gagal (misal Code 400), hanya ambil status dan code
      return Login(
        code: obj['code'],
        status: obj['status'],
      );
    }
  }
}