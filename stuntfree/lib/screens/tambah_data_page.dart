import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TambahDataAnakPage extends StatefulWidget {
  const TambahDataAnakPage({super.key});

  @override
  State<TambahDataAnakPage> createState() => _TambahDataAnakPageState();
}

class _TambahDataAnakPageState extends State<TambahDataAnakPage> {
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  int? _jenisKelaminValue;
  bool _isSending = false;

  Future<void> _kirimData() async {
    final prefs = await SharedPreferences.getInstance();
    final idOrtu = prefs.getInt('id_orangtua');

    if (idOrtu == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda belum login, silakan login dulu')),
      );
      return;
    }

    if (_namaController.text.isEmpty ||
        _nikController.text.isEmpty ||
        _tanggalLahirController.text.isEmpty ||
        _jenisKelaminValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    final url = Uri.parse('http://127.0.0.1:8000/api/anak');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nama': _namaController.text,
        'nik': _nikController.text,
        'jenis_kelamin': _jenisKelaminValue.toString(),
        'tanggal_lahir': _tanggalLahirController.text,
        'id_orangtua': idOrtu,
        'status': 'proses',
      }),
    );

    setState(() {
      _isSending = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/dataanak');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dikirim!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal kirim data.')),
      );
    }
  }

  Future<void> _selectTanggalLahir() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalLahirController.text =
            pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin membatalkan pengisian form?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dataanak');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D78FD),
            ),
            child: const Text('Ya', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validasi Data'),
        content: const Text(
          'Apakah data anak sudah sesuai? \n\n'
          'Catatan: Setelah disimpan, data anak tidak akan langsung tampil. '
          'Data perlu diverifikasi terlebih dahulu oleh admin.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _kirimData(); // hanya kirim setelah klik "Ya"
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D78FD),
            ),
            child: const Text('Ya', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF0F3FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      style: const TextStyle(color: Colors.black),
      decoration: _inputDecoration(),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: Color(0xFF5D78FD),
      ),
    );
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
          'Tambah Data',
          style: TextStyle(
            color: Color(0xFF5D78FD),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF5D78FD)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Silakan isi data anak \nAnda di sini.',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D78FD),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Data akan diverifikasi oleh petugas selama jam kerja.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                _buildLabel('Nama Anak'),
                const SizedBox(height: 6),
                _buildTextField(controller: _namaController),

                const SizedBox(height: 16),
                _buildLabel('NIK'),
                const SizedBox(height: 6),
                _buildTextField(controller: _nikController),

                const SizedBox(height: 16),
                _buildLabel('Jenis Kelamin'),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  value: _jenisKelaminValue,
                  decoration: _inputDecoration(),
                  style: const TextStyle(color: Colors.black),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Perempuan')),
                    DropdownMenuItem(value: 1, child: Text('Laki-laki')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _jenisKelaminValue = value;
                    });
                  },
                ),

                const SizedBox(height: 16),
                _buildLabel('Tanggal Lahir'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _tanggalLahirController,
                  onTap: _selectTanggalLahir,
                ),

                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showCancelConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSending ? null : _showSubmitConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5D78FD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _isSending
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Tambah Data'),
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
}
