import 'package:flutter/material.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';

class DataAnakPage extends StatelessWidget {
  const DataAnakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DATA ANAK',
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 8),
              // Search bar
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari nama anak...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildChildCard(context, false),
              const SizedBox(height: 16),
              _buildChildCard(context, true),
              const SizedBox(height: 100),
            ],
          ),
          // Tombol Tambah Data
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
              Navigator.pushNamed(context, '/tambah');
              },
              backgroundColor: const Color(0xFF5D78FD),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
              'Tambah',
              style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/berita');
          if (index == 3) Navigator.pushReplacementNamed(context, '/profil');
        },
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, bool hasPrediction) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fahzila Raul Ardiansa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text('NIK: 350927002233446611', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.male, size: 16, color: Color(0xFF5D78FD)),
              SizedBox(width: 4),
              Text('Laki-laki'),
              SizedBox(width: 16),
              Icon(Icons.cake, size: 16, color: Color(0xFF5D78FD)),
              SizedBox(width: 4),
              Text('20 tahun'),
            ],
          ),
          
          const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasPrediction) ...[
                        Row(
                          children: const [
                            Icon(Icons.warning_amber, size: 16, color: Colors.redAccent),
                            SizedBox(width: 4),
                            Text('Stunting', style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.analytics, size: 16, color: Colors.deepPurple),
                            SizedBox(width: 4),
                            Text('Z-Score: -2.1'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton.icon(
                    onPressed: () {
                    if (!hasPrediction) {
                      Navigator.pushNamed(context, '/prediksi');
                    }
                    },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF5D78FD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                    icon: Icon(hasPrediction ? Icons.edit : Icons.calculate, color: Colors.white),
                  label: Text(hasPrediction ? 'Edit' : 'Prediksi'),
                ),
              ],
            ),

        ],
      ),
    );
  }
}
