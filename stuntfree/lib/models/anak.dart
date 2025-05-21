class Anak {
  final int? id;
  final String nik;
  final String nama;
  final String jenisKelamin;
  final String tanggalLahir;
  final int? idOrangtua;
  final String? status;  // tambah status

  Anak({
    this.id,
    required this.nik,
    required this.nama,
    required this.jenisKelamin,
    required this.tanggalLahir,
    this.idOrangtua,
    this.status,
  });

  factory Anak.fromJson(Map<String, dynamic> json) {
    return Anak(
      id: json['id'],
      nik: json['nik'],
      nama: json['nama'],
      jenisKelamin: json['jenis_kelamin'],
      tanggalLahir: json['tanggal_lahir'],
      idOrangtua: json['id_orangtua'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama': nama,
      'jenis_kelamin': jenisKelamin,
      'tanggal_lahir': tanggalLahir,
      'status': status ?? 'proses',  // default status
      // 'id_orangtua' jangan di sini, biar api_service yang set otomatis
    };
  }
}
