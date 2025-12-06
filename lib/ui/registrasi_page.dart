import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_2_paket_3_h1d023002/helper/api_url.dart'; // Menggunakan Helper
import 'dart:convert';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.registrasi), // Panggil API Registrasi
        body: {
          'nama': _namaTextboxController.text,
          'email': _emailTextboxController.text,
          'password': _passwordTextboxController.text,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Sukses"),
            content: const Text("Registrasi Berhasil, silakan login."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Gagal"),
            content: Text(data['data'] ?? "Registrasi gagal."),
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
      // Error handling
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Bilqis")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Nama", _namaTextboxController),
                _buildTextField("Email", _emailTextboxController),
                _buildTextField("Password", _passwordTextboxController, isPassword: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator() : const Text("Registrasi"),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      _submit();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool isPassword = false}) {
    return TextFormField(
      controller: ctrl,
      obscureText: isPassword,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? "$label harus diisi" : null,
    );
  }
}