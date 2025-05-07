import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TambahDataAnakPage extends StatefulWidget {
  const TambahDataAnakPage({super.key});

  @override
  State<TambahDataAnakPage> createState() => _TambahDataAnakPageState();
}

class _TambahDataAnakPageState extends State<TambahDataAnakPage> {
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _jkController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  Future<void> _kirimData() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/anak'); // Ganti jika pakai emulator Android

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nama': _namaController.text,
        'nik': _nikController.text,
        'jenis_kelamin': _jkController.text,
        'tanggal_lahir': _tanggalLahirController.text,
        'id_orangtua': 1 // Sementara, sesuaikan dengan user login
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dikirim!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal kirim data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'TAMBAH DATA',
          style: TextStyle(
            color: Color(0xFF5D78FD),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Nama'),
                _buildTextField(controller: _namaController),

                const SizedBox(height: 12),
                _buildLabel('NIK'),
                _buildTextField(controller: _nikController),

                const SizedBox(height: 12),
                _buildLabel('Jenis Kelamin'),
                _buildTextField(controller: _jkController),

                const SizedBox(height: 12),
                _buildLabel('Tanggal Lahir (YYYY-MM-DD)'),
                _buildTextField(controller: _tanggalLahirController),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _kirimData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5D78FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Tambah Data'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF5D78FD),
      ),
    );
  }
}
