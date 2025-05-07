import 'package:flutter/material.dart';

class DataPribadiPage extends StatelessWidget {
  const DataPribadiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DATA PRIBADI',
          style: TextStyle(
            color: Color(0xFF007AFF),
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
            child: Icon(Icons.menu, color: Color(0xFF007AFF)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFB3D6FF),
                child: Icon(Icons.person, size: 50, color: Color(0xFF007AFF)),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'FAHZILA\nRAUL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007AFF),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(label: 'Nama'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Email'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Kecamatan'),
            const SizedBox(height: 16),
            _buildTextField(label: 'Alamat'),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aksi Simpan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007AFF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
