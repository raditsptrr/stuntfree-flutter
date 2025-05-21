class Ortu {
  final int id;
  final String nama;
  final String email;
  final int idKecamatan;
  final String alamat;

  Ortu({
    required this.id,
    required this.nama,
    required this.email,
    required this.idKecamatan,
    required this.alamat,
  });

  factory Ortu.fromJson(Map<String, dynamic> json) {
    return Ortu(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      idKecamatan: json['id_kecamatan'],
      alamat: json['alamat'],
    );
  }
}
