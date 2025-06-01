class Faskes {
  final int id;
  final String nama;
  final String alamat;
  final String telepon;
  final String urlMaps;
  final int idKecamatan;
  final String namaKecamatan;

  Faskes({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.urlMaps,
    required this.idKecamatan,
    required this.namaKecamatan,
  });

  factory Faskes.fromJson(Map<String, dynamic> json) {
    return Faskes(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      telepon: json['telepon'],
      urlMaps: json['urlmaps'],
      idKecamatan: json['id_kecamatan'],
      namaKecamatan: json['kecamatan']['nama'],
    );
  }
}
