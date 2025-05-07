import 'package:flutter/material.dart';

class DataDiriForm extends StatelessWidget {
  const DataDiriForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _namaOrtuController = TextEditingController();
    final _emailController = TextEditingController();
    final _telpController = TextEditingController();
    final _kecamatanController = TextEditingController();
    final _alamatController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTextField("Nama Orang Tua", _namaOrtuController),
          _buildTextField("Email", _emailController),
          _buildTextField("Nomor Telepon", _telpController),
          _buildTextField("Kecamatan", _kecamatanController),
          _buildTextField("Alamat", _alamatController),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data Diri berhasil disimpan')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D78FD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text("Simpan Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF5D78FD), width: 1.5),
          ),
        ),
      ),
    );
  }
} 
