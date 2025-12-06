class Buku {
  int? id;
  String? judul;
  int? harga;
  int? jumlah;
  String? tanggalMasuk;
  int? volume;
  String? penulis;
  String? penerbit;

  Buku({
    this.id,
    this.judul,
    this.harga,
    this.jumlah,
    this.tanggalMasuk,
    this.volume,
    this.penulis,
    this.penerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: int.parse(json['id'].toString()),
      judul: json['judul'],
      harga: int.parse(json['harga'].toString()),
      jumlah: int.parse(json['jumlah'].toString()),
      tanggalMasuk: json['tanggal_masuk'],
      volume: int.parse(json['volume'].toString()),
      penulis: json['penulis'],
      penerbit: json['penerbit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'harga': harga.toString(),
      'jumlah': jumlah.toString(),
      'tanggal_masuk': tanggalMasuk,
      'volume': volume.toString(),
      'penulis': penulis,
      'penerbit': penerbit,
    };
  }
}