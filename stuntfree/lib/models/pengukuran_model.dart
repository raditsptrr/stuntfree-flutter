// model/pengukuran_model.dart

class Pengukuran {
  final int id;
  final int idAnak;
  final double berat;
  final double tinggi;
  final int usiaBulan;
  final double? zsTbu;
  final String? hasil;
  final double? bmi;
  final double? zsBmiU;
  final String? statusGiziBmi;
  final Map<String, dynamic>? anak;

  Pengukuran({
    required this.id,
    required this.idAnak,
    required this.berat,
    required this.tinggi,
    required this.usiaBulan,
    this.zsTbu,
    this.hasil,
    this.bmi,
    this.zsBmiU,
    this.statusGiziBmi,
    this.anak,
  });

  factory Pengukuran.fromJson(Map<String, dynamic> json) {
    return Pengukuran(
      id: json['id'],
      idAnak: json['id_anak'],
      berat: double.tryParse(json['berat'].toString()) ?? 0.0,
      tinggi: double.tryParse(json['tinggi'].toString()) ?? 0.0,
      usiaBulan: json['usia_bulan'],
      zsTbu: json['zs_tbu'] != null ? double.tryParse(json['zs_tbu'].toString()) : null,
      hasil: json['hasil'],
      bmi: json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null,
      zsBmiU: json['zs_bmi_u'] != null ? double.tryParse(json['zs_bmi_u'].toString()) : null,
      statusGiziBmi: json['status_gizi_bmi'],
      anak: json['anak'],
    );
  }
}
