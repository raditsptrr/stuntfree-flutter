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
  List<Edukasi> _allBerita = [];
  List<Edukasi> _filteredBerita = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beritaFuture = ApiService().fetchEdukasi();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredBerita = _allBerita.where((berita) {
        return berita.judul.toLowerCase().contains(keyword) ||
               berita.kategori.toLowerCase().contains(keyword) ||
               berita.content.toLowerCase().contains(keyword);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari berita...',
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

                    _allBerita = snapshot.data!;
                    _filteredBerita = _searchController.text.isEmpty
                        ? _allBerita
                        : _filteredBerita;

                    if (_filteredBerita.isEmpty) {
                      return const Center(child: Text('Tidak ada berita ditemukan.'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredBerita.length,
                      itemBuilder: (context, index) {
                        final berita = _filteredBerita[index];
                        final imageUrl = berita.fullImageUrl != null
                            ? '${AppConstant.imageBaseUrl}${berita.fullImageUrl}'
                            : null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: NewsCard(
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
                                    imagePath: imageUrl,
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

// ==============================
// NewsCard Widget (tidak berubah dari revisimu sebelumnya)
// ==============================
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(color: Colors.grey),
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(date,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
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
