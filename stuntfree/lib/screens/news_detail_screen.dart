import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String date;
  final String? imagePath; // <-- Ubah ke String? (nullable)
  final String content;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.date,
    this.imagePath, // <-- Jadikan nullable
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar custom (Tetap Sama)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left,
                        color: Color(0xFF5D78FD), size: 32),
                  ),
                  const Spacer(),
                  const Text(
                    "Berita",
                    style: TextStyle(
                      color: Color(0xFF5D78FD),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 32), // Sesuaikan ukuran
                ],
              ),
            ),

            // <-- REVISI DI SINI: Header image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                // Cek apakah imagePath ada dan tidak kosong
                child: (imagePath != null && imagePath!.isNotEmpty)
                    ? Image.network( // <-- Gunakan Image.network
                        imagePath!, // <-- Gunakan imagePath
                        height: 180, // Sedikit lebih tinggi mungkin?
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                           if (loadingProgress == null) return child;
                           return Container(
                             height: 180,
                             color: Colors.grey.shade300,
                             child: const Center(child: CircularProgressIndicator()),
                           );
                         },
                        errorBuilder: (context, error, stackTrace) {
                           // Tampilkan placeholder jika gagal load
                           return Container(
                             height: 180,
                             color: Colors.grey.shade300,
                             child: Center(
                               child: Icon(Icons.broken_image,
                                   color: Colors.grey.shade600, size: 60),
                             ),
                           );
                        },
                      )
                    : Container( // <-- Tampilkan placeholder jika URL null/kosong
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(Icons.image,
                              color: Colors.grey.shade600, size: 60),
                        ),
                      ),
              ),
            ),
            // <-- Akhir Revisi Header image

            const SizedBox(height: 20),

            // Title & date (Tetap Sama)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Content (Tetap Sama)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}