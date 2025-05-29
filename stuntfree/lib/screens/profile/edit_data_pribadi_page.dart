import 'package:flutter/material.dart';
import '../../models/ortu.dart';
import '../../models/kecamatan.dart';
import '../../service/api_service.dart';

class EditDataPribadiPage extends StatefulWidget {
  final Ortu ortu;

  const EditDataPribadiPage({super.key, required this.ortu});

  @override
  State<EditDataPribadiPage> createState() => _EditDataPribadiPageState();
}

class _EditDataPribadiPageState extends State<EditDataPribadiPage> {
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController alamatController;

  List<Kecamatan> _kecamatanList = [];
  Kecamatan? _selectedKecamatan;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.ortu.nama);
    emailController = TextEditingController(text: widget.ortu.email);
    alamatController = TextEditingController(text: widget.ortu.alamat);

    fetchKecamatan();
  }

  Future<void> fetchKecamatan() async {
    try {
      final data = await ApiService().fetchKecamatan();
      setState(() {
        _kecamatanList = data;
        _selectedKecamatan = _kecamatanList.isNotEmpty
            ? _kecamatanList.firstWhere(
                (kec) => kec.id == widget.ortu.idKecamatan,
                orElse: () => _kecamatanList[0],
              )
            : null;
      });
    } catch (e) {
      print('❌ Error fetch kecamatan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data kecamatan')),
      );
    }
  }

  void _simpanPerubahan() async {
    if (_selectedKecamatan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kecamatan terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updated = await ApiService().updateProfilOrtu(
      id: widget.ortu.id,
      nama: namaController.text,
      email: emailController.text,
      alamat: alamatController.text,
      idKecamatan: _selectedKecamatan!.id,
    );

    setState(() {
      _isLoading = false;
    });

    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Pribadi'),
        backgroundColor: const Color(0xFF007AFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _buildTextField(label: 'Nama', controller: namaController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Email', controller: emailController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Alamat', controller: alamatController),
            const SizedBox(height: 16),

            // Dropdown Kecamatan
            DropdownButtonFormField<Kecamatan>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Pilih Kecamatan',
                filled: true,
                fillColor: const Color(0xFFF1F1F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              value: _selectedKecamatan,
              items: _kecamatanList.map((kec) {
                return DropdownMenuItem(
                  value: kec,
                  child: Text(kec.nama),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKecamatan = value;
                });
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _simpanPerubahan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
