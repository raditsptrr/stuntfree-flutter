import 'package:flutter/material.dart';
import '../../models/ortu.dart'; // Pastikan path ini benar
import '../../service/api_service.dart'; // Pastikan path ini benar
import '../profile/edit_data_pribadi_page.dart';

class DataPribadiPage extends StatefulWidget {
  const DataPribadiPage({super.key});

  @override
  State<DataPribadiPage> createState() => _DataPribadiPageState();
}

class _DataPribadiPageState extends State<DataPribadiPage> {
  late Future<Ortu?> _ortuFuture;

  @override
  void initState() {
    super.initState();
    _ortuFuture = ApiService().fetchProfilOrtu();
  }

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController kecamatanController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

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
      body: FutureBuilder<Ortu?>(
        future: _ortuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final ortu = snapshot.data!;
          // Isi controller
          namaController.text = ortu.nama;
          emailController.text = ortu.email;
          kecamatanController.text = ortu.namaKecamatan ?? 'Tidak diketahui';
          alamatController.text = ortu.alamat;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFFB3D6FF),
                    child:
                        Icon(Icons.person, size: 50, color: Color(0xFF007AFF)),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    ortu.nama.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(label: 'Nama', controller: namaController),
                const SizedBox(height: 16),
                _buildTextField(label: 'Email', controller: emailController),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Kecamatan', controller: kecamatanController),
                const SizedBox(height: 16),
                _buildTextField(label: 'Alamat', controller: alamatController),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditDataPribadiPage(ortu: ortu),
                            ),
                          );
                          // Tambahkan aksi simpan di sini
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007AFF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true, // Ubah jadi false kalau mau bisa diedit
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
