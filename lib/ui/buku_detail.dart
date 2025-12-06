import 'package:flutter/material.dart';
import 'package:responsi_2_paket_3_h1d023002/model/buku.dart';
import 'package:responsi_2_paket_3_h1d023002/ui/buku_form.dart';
import 'package:responsi_2_paket_3_h1d023002/ui/buku_page.dart';
import 'package:responsi_2_paket_3_h1d023002/helper/api_url.dart'; // Import Helper
import 'package:http/http.dart' as http;
import 'dart:convert';

class BukuDetail extends StatefulWidget {
  final Buku? buku;
  const BukuDetail({Key? key, this.buku}) : super(key: key);

  @override
  _BukuDetailState createState() => _BukuDetailState();
}

class _BukuDetailState extends State<BukuDetail> {
  bool _isDeleting = false;
  
  // Fungsi Hapus Data
  void deleteBuku(int id) async {
    setState(() {
      _isDeleting = true;
    });
    
    try {
      // Panggil API Delete dengan headers CORS-friendly
      final response = await http.delete(
        Uri.parse(ApiUrl.deleteBuku(id)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - periksa koneksi server backend');
        },
      );

      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body);
          if (data['code'] == 200 || data['status'] == 'success') {
            // Jika berhasil, kembali ke halaman list
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BukuPage()),
              );
            }
          } else {
            _showErrorDialog('Gagal menghapus data: ${data['message'] ?? "Unknown error"}');
          }
        } catch (e) {
          _showErrorDialog('Error parsing response: $e');
        }
      } else {
        _showErrorDialog('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } on Exception catch (e) {
      String errorMsg = e.toString();
      if (errorMsg.contains('CORS') || errorMsg.contains('Failed to fetch')) {
        _showErrorDialog(
          'CORS Error: Server backend belum dikonfigurasi untuk menerima request dari aplikasi ini.\n\n'
          'Solusi:\n'
          '1. Hubungi admin backend untuk enable CORS\n'
          '2. Atau run backend di localhost untuk development'
        );
      } else {
        _showErrorDialog('Error: $errorMsg');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
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

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: _isDeleting ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ) : const Text("Ya"),
          onPressed: _isDeleting ? null : () {
            // Jalankan fungsi hapus
            deleteBuku(widget.buku!.id!);
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: _isDeleting ? null : () => Navigator.pop(context),
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku Bilqis')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul: ${widget.buku!.judul}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Penulis: ${widget.buku!.penulis}", style: const TextStyle(fontSize: 18)),
              Text("Penerbit: ${widget.buku!.penerbit}", style: const TextStyle(fontSize: 18)),
              Text("Harga: Rp ${widget.buku!.harga}", style: const TextStyle(fontSize: 18)),
              Text("Jumlah: ${widget.buku!.jumlah}", style: const TextStyle(fontSize: 18)),
              Text("Volume: ${widget.buku!.volume}", style: const TextStyle(fontSize: 18)),
              Text("Tgl Masuk: ${widget.buku!.tanggalMasuk}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("EDIT"),
                    onPressed: () {
                      // Navigasi ke Form Edit
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BukuForm(buku: widget.buku),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("DELETE"),
                    onPressed: () => confirmHapus(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}