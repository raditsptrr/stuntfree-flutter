import 'package:flutter/material.dart';

class PrediksiPage extends StatelessWidget {
  const PrediksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PREDIKSI',
          style: TextStyle(
            color: Color(0xFF5D78FD),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500),
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
                const Text(
                  'Silahkan masukan data untuk prediksi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D78FD),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masukan umur, tinggi badan, dan berat badan agar mengetahui pertumbuhan pada balita dengan z-score sesuai standar WHO.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                _buildFieldLabel('Nama Anak'),
                _buildDropdownNama(),
                const SizedBox(height: 16),

                _buildFieldLabel('Umur (bulan)'),
                _buildTextField(),
                const SizedBox(height: 16),

                _buildFieldLabel('Berat Badan (kg)'),
                _buildTextField(),
                const SizedBox(height: 16),

                _buildFieldLabel('Tinggi Badan (cm)'),
                _buildTextField(),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showCancelConfirmation(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika Prediksi di sini
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5D78FD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Prediksi',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
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
              Navigator.pop(context); // tutup dialog
              Navigator.pushReplacementNamed(context, '/dataanak'); // pindah ke /dataanak
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D78FD),
            ),
            child: const Text(
              'Ya',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF5D78FD),
      ),
    );
  }

  Widget _buildTextField() {
    return SizedBox(
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownNama() {
    return SizedBox(
      height: 50,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        hint: const Text('Pilih Nama Anak'),
        items: ['Anak A', 'Anak B', 'Anak C'].map((name) {
          return DropdownMenuItem(
            value: name,
            child: Text(name),
          );
        }).toList(),
        onChanged: (value) {
          // aksi ketika dropdown berubah
        },
      ),
    );
  }
}
