import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:responsi_2_paket_3_h1d023002/model/buku.dart';
import 'package:responsi_2_paket_3_h1d023002/ui/buku_page.dart';
import 'package:responsi_2_paket_3_h1d023002/helper/api_url.dart'; // Import Helper
import 'package:http/http.dart' as http;

class BukuForm extends StatefulWidget {
  final Buku? buku;
  const BukuForm({Key? key, this.buku}) : super(key: key);

  @override
  _BukuFormState createState() => _BukuFormState();
}

class _BukuFormState extends State<BukuForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controller untuk 7 Field
  final _judulCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  final _jumlahCtrl = TextEditingController();
  final _tanggalMasukCtrl = TextEditingController();
  final _volumeCtrl = TextEditingController();
  final _penulisCtrl = TextEditingController();
  final _penerbitCtrl = TextEditingController();

  String judulHalaman = "Tambah Buku Bilqis";
  String tombolSubmit = "Simpan Buku Bilqis";

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  // Cek apakah mode Edit
  isUpdate() {
    if (widget.buku != null) {
      setState(() {
        judulHalaman = "UBAH BUKU";
        tombolSubmit = "UBAH";
        _judulCtrl.text = widget.buku!.judul!;
        _hargaCtrl.text = widget.buku!.harga.toString();
        _jumlahCtrl.text = widget.buku!.jumlah.toString();
        _tanggalMasukCtrl.text = widget.buku!.tanggalMasuk!;
        _volumeCtrl.text = widget.buku!.volume.toString();
        _penulisCtrl.text = widget.buku!.penulis!;
        _penerbitCtrl.text = widget.buku!.penerbit!;
      });
    }
  }

  Future<void> submitData() async {
    setState(() {
      _isLoading = true;
    });

    // Siapkan body data
    var body = {
      'judul': _judulCtrl.text,
      'harga': _hargaCtrl.text,
      'jumlah': _jumlahCtrl.text,
      'tanggal_masuk': _tanggalMasukCtrl.text,
      'volume': _volumeCtrl.text,
      'penulis': _penulisCtrl.text,
      'penerbit': _penerbitCtrl.text,
    };

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (widget.buku == null) {
        // Mode Create: Panggil API Create
        final response = await http.post(
          Uri.parse(ApiUrl.createBuku),
          headers: headers,
          body: jsonEncode(body),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Request timeout - periksa koneksi server backend');
          },
        );
        
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Server error: ${response.statusCode}');
        }
      } else {
        // Mode Update: Panggil API Update dengan ID
        final response = await http.put(
          Uri.parse(ApiUrl.updateBuku(widget.buku!.id!)),
          headers: headers,
          body: jsonEncode(body),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Request timeout - periksa koneksi server backend');
          },
        );
        
        if (response.statusCode != 200) {
          throw Exception('Server error: ${response.statusCode}');
        }
      }
      
      // Jika berhasil, kembali ke list
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BukuPage()),
          (route) => false,
        );
      }
    } catch (e) {
      String errorMsg = e.toString();
      String displayMsg = 'Terjadi kesalahan';
      
      if (errorMsg.contains('CORS') || errorMsg.contains('Failed to fetch')) {
        displayMsg = 'CORS Error: Server backend belum dikonfigurasi CORS.\n'
            'Minta admin untuk enable CORS di backend.';
      } else if (errorMsg.contains('timeout')) {
        displayMsg = 'Request timeout: Server tidak merespons. Periksa koneksi.';
      } else if (errorMsg.contains('Server error')) {
        displayMsg = errorMsg;
      } else {
        displayMsg = 'Error: $errorMsg';
      }
      
      if (mounted) {
        _showErrorDialog(displayMsg);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judulHalaman)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_judulCtrl, "Judul Buku"),
                _buildTextField(_hargaCtrl, "Harga", isNumber: true),
                _buildTextField(_jumlahCtrl, "Jumlah", isNumber: true),
                _buildTextField(_volumeCtrl, "Volume", isNumber: true),
                _buildTextField(_tanggalMasukCtrl, "Tanggal Masuk (YYYY-MM-DD)"),
                _buildTextField(_penulisCtrl, "Penulis"),
                _buildTextField(_penerbitCtrl, "Penerbit"),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : Text(tombolSubmit),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_isLoading) submitData();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}