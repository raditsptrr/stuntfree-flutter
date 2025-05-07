import 'package:flutter/material.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';
import 'package:stuntfree/screens/news_detail_screen.dart';

class BeritaScreen extends StatelessWidget {
  const BeritaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> beritaList = [
      {
        'title': 'Gizi Bagus',
        'date': '10 April 2025',
        'description':
            'Gizi yang baik penting untuk pertumbuhan anak dan mencegah stunting.',
        'imagePath': 'assets/images/doctor.png',
      },
      {
        'title': '4 Sehat 5 Sempurna',
        'date': '11 April 2025',
        'description':
            'Panduan makanan sehat yang lengkap untuk anak usia dini.',
        'imagePath': 'assets/images/doctor.png',
      },
      {
        'title': 'Makan Gratis',
        'date': '12 April 2025',
        'description':
            'Pemerintah menggalakkan program makan siang gratis di sekolah dasar.',
        'imagePath': 'assets/images/doctor.png',
      },
      {
        'title': 'Air Putih',
        'date': '13 April 2025',
        'description':
            'Air putih membantu metabolisme tubuh dan mencegah dehidrasi.',
        'imagePath': 'assets/images/doctor.png',
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'BERITA',
          style: TextStyle(
            color: Color(0xFF5D78FD),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.person, color: Color(0xFF5D78FD)),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Color(0xFF5D78FD)),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F2FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: beritaList.length,
                  itemBuilder: (context, index) {
                    final berita = beritaList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NewsCard(
                        title: berita['title']!,
                        date: berita['date']!,
                        description: berita['description']!,
                        imagePath: berita['imagePath']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(
                                title: berita['title']!,
                                date: berita['date']!,
                                imagePath: berita['imagePath']!,
                                content: berita['description']! +
                                    "\n\nFull article goes here...",
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/tambah');
          if (index == 2) return;
          if (index == 3) Navigator.pushReplacementNamed(context, '/profil');
        },
      ),
    );
  }
}

// Widget NewsCard langsung di sini
class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imagePath;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(date,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
