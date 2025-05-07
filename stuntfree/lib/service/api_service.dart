import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anak.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api'; // Ganti dengan URL API Anda

  Future<void> tambahDataAnak(Anak anak) async {
    final response = await http.post(
      Uri.parse('$baseUrl/anak'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(anak.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menambahkan data anak');
    }
  }
}