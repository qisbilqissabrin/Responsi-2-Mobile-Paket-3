import 'package:flutter/material.dart';
import 'package:responsi_2_paket_3_h1d023002/model/buku.dart'; // Import Model
import 'package:responsi_2_paket_3_h1d023002/ui/buku_detail.dart';
import 'package:responsi_2_paket_3_h1d023002/ui/buku_form.dart';
import 'package:responsi_2_paket_3_h1d023002/helper/api_url.dart'; // Import Helper
import 'package:http/http.dart' as http;
import 'package:responsi_2_paket_3_h1d023002/ui/login_page.dart';
import 'dart:convert';

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  // Fungsi untuk mengambil data dari API
  Future<List<Buku>> getBuku() async {
    // Panggil API List Buku
    final response = await http.get(Uri.parse(ApiUrl.listBuku));

    if (response.statusCode == 200) {
      // Parsing JSON
      var jsonResponse = json.decode(response.body);
      // Ambil bagian 'data' dari respon JSON CI4
      List data = jsonResponse['data'];
      // Mapping data JSON ke Model Buku
      return data.map((d) => Buku.fromJson(d)).toList();
    } else {
      throw Exception('Gagal memuat data buku');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Buku Bilqis'), // Ganti dengan nama Anda
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                // Navigasi ke Form Tambah
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BukuForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                // Logout sederhana: Kembali ke halaman Login
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List<Buku>>(
        future: getBuku(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("Belum ada data buku"));
          }

          // Tampilkan List Data
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(snapshot.data![index].judul ?? ''),
                  subtitle: Text("Penulis: ${snapshot.data![index].penulis}"),
                  trailing: Text("Rp ${snapshot.data![index].harga}"),
                  onTap: () {
                    // Navigasi ke Detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BukuDetail(buku: snapshot.data![index]),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}