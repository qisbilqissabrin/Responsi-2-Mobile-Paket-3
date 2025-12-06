import 'package:responsi_2_paket_3_h1d023002/helper/api_url.dart';
import 'package:responsi_2_paket_3_h1d023002/model/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_2_paket_3_h1d023002/ui/buku_page.dart';
import 'package:responsi_2_paket_3_h1d023002/ui/registrasi_page.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.login), // Menggunakan Helper ApiUrl [cite: 876]
        body: {
          'email': _emailTextboxController.text,
          'password': _passwordTextboxController.text,
        },
      );

      // 1. Decode respon mentah
      var jsonResponse = json.decode(response.body);

      // 2. Cek Status Code dari API
      if (jsonResponse['code'] == 200) {
        // Jika Sukses (Code 200):
        // Kita konversi ke Model Login karena data 'user' dan 'token' tersedia
        Login loginData = Login.fromJson(jsonResponse);

        // (Opsional) Anda bisa mengakses token via loginData.token
        // print("Token: ${loginData.token}");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BukuPage()),
        );
      } else {
        // Jika Gagal (Code 400/404):
        // Pesan error di CI4 dikirim dalam field 'data' sebagai String
        // Contoh: "Email tidak ditemukan" atau "Password salah"
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Gagal"),
            content: Text(jsonResponse['data'] ?? "Login gagal"), 
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Terjadi kesalahan koneksi: $e"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Buku Bilqis'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                const SizedBox(height: 20),
                _buttonLogin(),
                const SizedBox(height: 30),
                _menuRegistrasi()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Email [cite: 1609]
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox Password [cite: 1625]
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Login [cite: 1641]
  Widget _buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown, // Warna Coklat sesuai soal
        foregroundColor: Colors.white,
      ),
      child: _isLoading 
        ? const CircularProgressIndicator(color: Colors.white) 
        : const Text("Login"),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate && !_isLoading) {
          _login();
        }
      },
    );
  }

  // Membuat menu untuk membuka halaman registrasi [cite: 1648]
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.brown), // Warna Teks Coklat
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}