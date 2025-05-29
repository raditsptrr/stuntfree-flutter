import 'package:flutter/material.dart';
import 'package:stuntfree/util/app_constant.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';
import 'package:stuntfree/screens/news_detail_screen.dart';
import '../service/api_service.dart';
import '../models/edukasi.dart';

class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  late Future<List<Edukasi>> _beritaFuture;

  @override
  void initState() {
    super.initState();
    _beritaFuture = ApiService().fetchEdukasi();
  }

  @override
  Widget build(BuildContext context) {
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
          // Ganti dengan ikon yang sesuai atau biarkan jika ini disengaja
          child: Icon(Icons.article_outlined, color: Color(0xFF5D78FD)),
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
                    boxShadow: const [ // Sedikit shadow untuk search bar
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TextField(
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
                child: FutureBuilder<List<Edukasi>>(
                  future: _beritaFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final beritaList = snapshot.data!;
                    if (beritaList.isEmpty) {
                       return const Center(child: Text('Tidak ada berita.'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: beritaList.length,
                      itemBuilder: (context, index) {
                        final berita = beritaList[index];
                        final imageUrl = berita.fullImageUrl != null
                            ? '${AppConstant.imageBaseUrl}${berita.fullImageUrl}'
                            : null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: NewsCard( // <-- Gunakan NewsCard yang sudah direvisi
                            title: berita.judul,
                            date: berita.kategori,
                            description: berita.content,
                            imageUrl: imageUrl,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewsDetailScreen(
                                    title: berita.judul,
                                    date: berita.kategori,
                                    imagePath: imageUrl, // Kirim URL atau null
                                    content: berita.content,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
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
          if (index == 1) Navigator.pushReplacementNamed(context, '/dataanak');
          if (index == 2) return;
          if (index == 3) Navigator.pushReplacementNamed(context, '/profil');
        },
      ),
    );
  }
}

// ===================================================
// REVISI NewsCard agar sama dengan HomeScreen
// ===================================================
class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String? imageUrl;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container( // Gunakan Container
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Samakan radius
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Material( // Gunakan Material + InkWell
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding( // Tambahkan Padding
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // Sudut tumpul semua sisi
                  child: Container(
                    width: 80, // Ukuran 80x80
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 40, color: Colors.white);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                          )
                        : const Icon(Icons.image, size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12), // Jarak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14), // Ukuran font 14
                          maxLines: 2, // Batasi judul 2 baris
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(date,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12), // Ukuran font 12
                        maxLines: 2, // Batasi deskripsi jadi 2 baris
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ===================================================