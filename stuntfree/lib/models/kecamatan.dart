class Kecamatan {
  final int id;
  final String nama;

  Kecamatan({
    required this.id,
    required this.nama,
  });

  factory Kecamatan.fromJson(Map<String, dynamic> json) {
    return Kecamatan(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }

  @override
  String toString() => nama;
}