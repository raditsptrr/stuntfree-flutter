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
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: Color(0xFFE3F0FF),
            child: Icon(Icons.person, color: Color(0xFF5D78FD)),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Color(0xFF5D78FD)),
          ),
        ],
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
                _buildFieldLabel('Nama'),
                _buildTextField(),
                const SizedBox(height: 12),

                _buildFieldLabel('NIK'),
                _buildTextField(),
                const SizedBox(height: 12),

                _buildFieldLabel('Jenis Kelamin'),
                _buildTextField(),
                const SizedBox(height: 12),

                _buildFieldLabel('Tanggal Lahir'),
                _buildTextField(),
                const SizedBox(height: 12),

                _buildFieldLabel('Berat Badan'),
                _buildTextField(),
                const SizedBox(height: 12),

                _buildFieldLabel('Tinggi Badan'),
                _buildTextField(),
                const SizedBox(height: 12),

                _buildFieldLabel('Lingkar Lengan'),
                _buildTextField(),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                          backgroundColor: Color(0xFF2A68B2),
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

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF2A68B2),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
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
}
