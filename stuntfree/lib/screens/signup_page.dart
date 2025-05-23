import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';
import '../models/kecamatan.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _alamatController = TextEditingController();

  List<Kecamatan> _kecamatanList = [];
  Kecamatan? _selectedKecamatan;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchKecamatan();
  }

  Future<void> fetchKecamatan() async {
    try {
      final data = await ApiService().fetchKecamatan();
      setState(() {
        _kecamatanList = data;
      });
    } catch (e) {
      print('❌ Error ambil kecamatan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data kecamatan')),
      );
    }
  }

  Future<void> register() async {
    if (_selectedKecamatan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kecamatan terlebih dahulu')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final ortu = await ApiService().register(
        nama: _namaController.text,
        email: _emailController.text,
        password: _passwordController.text,
        idKecamatan: _selectedKecamatan!.id,
        alamat: _alamatController.text,
      );

      if (ortu != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil daftar')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mendaftar, coba lagi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image dengan overlay hitam transparan
          Positioned.fill(
            child: Image.asset(
              'assets/images/1.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/images/jerapahputih.png',
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hai,\nSelamat Datang!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D78FD),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Sobat Jalu silakan daftar untuk mulai menggunakan aplikasi',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),

                        // Input Nama
                        _buildTextField(_namaController, 'Nama'),
                        const SizedBox(height: 12),

                        // Input Email
                        _buildTextField(_emailController, 'Email'),
                        const SizedBox(height: 12),

                        // Password
                        _buildTextField(_passwordController, 'Kata Sandi', isPassword: true),
                        const SizedBox(height: 12),

                        // Konfirmasi Password
                        _buildTextField(_confirmPasswordController, 'Konfirmasi Kata Sandi', isPassword: true),
                        const SizedBox(height: 12),

                        // Alamat
                        _buildTextField(_alamatController, 'Alamat'),
                        const SizedBox(height: 12),

                        // Dropdown Kecamatan
                        DropdownButtonFormField<Kecamatan>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Pilih Kecamatan',
                            filled: true,
                            fillColor: const Color(0xFFF4F6FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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

                        // Daftar Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                          onPressed: _isLoading ? null : register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5D78FD),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: Colors.white, // Set text color to white
                          ),
                          child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Ensure text is white
                              ),
                              ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Navigasi ke login
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Sudah punya akun? ',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                TextSpan(
                                  text: 'Masuk di sini',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
