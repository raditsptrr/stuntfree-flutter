import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anak.dart';
import '../models/ortu.dart';
import '../models/kecamatan.dart';
import '../models/pengukuran_model.dart';
import '../models/edukasi.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  // tampil data anak
 Future<List<Map<String, dynamic>>> fetchAnak(int idOrtu) async {
  final url = Uri.parse('$baseUrl/anak');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);

    final anakList = data
        .where((anak) =>
            anak['id_orangtua'] == idOrtu &&
            anak['status'] == 'diterima') // Filter anak diterima
        .cast<Map<String, dynamic>>()
        .toList();

    // Ambil pengukuran
    final pengukuranList = await fetchPengukuran();

    // Gabungkan z_score & usia_bulan ke data anak
    for (var anak in anakList) {
      final pengukuranAnak = pengukuranList
          .where((p) => p.idAnak == anak['id'])
          .toList()
        ..sort((a, b) => b.id.compareTo(a.id)); // ambil pengukuran terbaru

      if (pengukuranAnak.isNotEmpty) {
        final latest = pengukuranAnak.first;
        anak['z_score'] = latest.zsTbu;
        anak['usia_bulan'] = latest.usiaBulan;
        anak['hasil'] = latest.hasil;
        anak['berat'] = latest.berat;
        anak['tinggi'] = latest.tinggi;
      }
    }

    return anakList;
  } else {
    throw Exception('Gagal mengambil data anak');
  }
}



  // Tambah data anak
 Future<void> tambahDataAnak(Anak anak) async {
  final prefs = await SharedPreferences.getInstance();
  final idOrtu = prefs.getInt('id_orangtua');

  if (idOrtu == null) {
    throw Exception('ID orang tua tidak ditemukan. Harus login dulu.');
  }

  final data = anak.toJson();
  data['id_orangtua'] = idOrtu; // override id_orangtua

  final response = await http.post(
    Uri.parse('$baseUrl/anak'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Gagal menambahkan data anak');
  }
}

Future<Map<String, dynamic>?> getDashboardData() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {
        'Accept': 'application/json',
        // no authorization header
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Gagal ambil data dashboard: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error saat ambil dashboard: $e');
    return null;
  }
}



  // Login orang tua
  Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    Ortu ortu = Ortu.fromJson(data['user']);
    String token = data['token'];

    // Simpan token & id_orangtua ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('id_orangtua', ortu.id);
    await prefs.setString('nama_ortu', ortu.nama);

    return {
      'success': true,
      'ortu': ortu,
      'token': token,
    };
  } else {
    return {
      'success': false,
      'message': 'Login gagal, status code: ${response.statusCode}',
    };
  }
}


  // kecamatan
  // ApiService.dart

Future<List<Kecamatan>> fetchKecamatan() async {
  final response = await http.get(Uri.parse('$baseUrl/kecamatan'));

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData['status'] == true) {
      return (responseData['data'] as List)
          .map((item) => Kecamatan.fromJson(item))
          .toList();
    } else {
      throw Exception('API mengembalikan status false');
    }
  } else {
    throw Exception('Gagal memuat kecamatan');
  }
}

  // Register orang tua
  Future<Ortu?> register({
  required String nama,
  required String email,
  required String password,
  required int idKecamatan,
  required String alamat,
}) async {
  final url = Uri.parse('$baseUrl/register');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
        'id_kecamatan': idKecamatan,
        'alamat': alamat,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == true) {
      return Ortu.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Gagal daftar');
    }
  } catch (e) {
    throw Exception('Terjadi kesalahan saat mendaftar: $e');
  }
}

  // pengukuran 
  // Ambil semua data pengukuran (dengan relasi anak)
Future<List<Pengukuran>> fetchPengukuran() async {
  final url = Uri.parse('$baseUrl/pengukuran');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final List list = responseData['data'];
    return list.map((item) => Pengukuran.fromJson(item)).toList();
  } else {
    throw Exception('Gagal mengambil data pengukuran');
  }
}


// Kirim data pengukuran baru
Future<Pengukuran?> submitPengukuran({
  required int idAnak,
  required double berat,
  required double tinggi,
  required int usiaBulan,
}) async {
  final url = Uri.parse('$baseUrl/pengukuran');

  final response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'id_anak': idAnak,
      'berat': berat,
      'tinggi': tinggi,
      'usia_bulan': usiaBulan,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['success'] == true) {
      return Pengukuran.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Pengukuran gagal');
    }
  } else {
    print('Error: ${response.body}');
    throw Exception('Gagal kirim data pengukuran');
  }
}



// edukasi / berita
Future<List<Edukasi>> fetchEdukasi() async {
    final response = await http.get(Uri.parse('$baseUrl/edukasi'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      data.forEach((item) {
        debugPrint("Judul ${item['judul']}");
        debugPrint("Image ${item['image_url']}");
      });
      return data.map((json) => Edukasi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data edukasi');
    }
  }

  

}
