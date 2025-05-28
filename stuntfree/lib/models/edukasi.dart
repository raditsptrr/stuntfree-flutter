class Edukasi {
  final int id;
  final String judul;
  final String kategori;
  final String content;
  final String? imageUrl;

  Edukasi({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.content,
    this.imageUrl,
  });

  factory Edukasi.fromJson(Map<String, dynamic> json) {
    return Edukasi(
      id: json['id'],
      judul: json['judul'],
      kategori: json['kategori'],
      content: json['content'],
      imageUrl: json['image_url'], 
    );
  }

  String? get fullImageUrl => imageUrl;

  // String get fullImageUrl {
  //   return 'http://localhost:8000/${imageUrl ?? ""}'; 
  // }
}
