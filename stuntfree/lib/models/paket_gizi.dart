class PaketGizi {
  final String id;
  final String nama;
  final String alamat;
  final String telepon;
  final String urlmaps;

  PaketGizi({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.urlmaps,
  });

  factory PaketGizi.fromJson(Map<String, dynamic> json) {
    return PaketGizi(
      id: json['_id'],
      nama: json['nama'],
      alamat: json['alamat'],
      telepon: json['telepon'],
      urlmaps: json['urlmaps'],
    );
  }
}
