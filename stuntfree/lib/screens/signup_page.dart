import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
      body: Container(
        decoration: backgroundGradient,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset('assets/images/child.png', height: 180),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: containerDecoration,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Hai\n',
                                      style: orangeTitleTextSmall),
                                  TextSpan(
                                      text: 'Selamat Datang!',
                                      style: blueTitleTextSmall),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sobat Jalu, silahkan daftar untuk mulai menggunakan aplikasi',
                              style: greySubtitleSmall,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                                controller: _namaController, label: 'Nama'),
                            const SizedBox(height: 12),
                            _buildTextField(
                                controller: _emailController, label: 'Email'),
                            const SizedBox(height: 12),
                            _buildTextField(
                                controller: _passwordController,
                                label: 'Kata Sandi',
                                isPassword: true),
                            const SizedBox(height: 12),
                            _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Konfirmasi Kata Sandi',
                                isPassword: true),
                            const SizedBox(height: 12),
                            _buildTextField(
                                controller: _alamatController, label: 'Alamat'),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<Kecamatan>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Pilih Kecamatan',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
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
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _isLoading ? null : register,
                              style: buttonStyleSmall,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Daftar',
                                      style: buttonTextStyle),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                        text: 'Sudah punya akun? ',
                                        style: greySmallText),
                                    TextSpan(
                                      text: 'Masuk di sini',
                                      style: boldBlackSmallText,
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
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      cursorColor: Color(0xFF5D78FD),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(
            color: Color(0xFF5D78FD), fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5D78FD), width: 2),
        ),
      ),
    );
  }
}

// ==============================
// Styling Constants
// ==============================

const backgroundGradient = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color.fromARGB(255, 210, 218, 255), Color(0xFFE1F5FE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

const containerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
);

const orangeTitleTextSmall = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.orange,
);

const blueTitleTextSmall = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF5D78FD),
);

const greySubtitleSmall = TextStyle(
  color: Colors.grey,
  fontSize: 13,
);

const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

final buttonStyleSmall = ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF5D78FD),
  minimumSize: const Size.fromHeight(45),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
);

const greySmallText = TextStyle(
  color: Colors.grey,
  fontSize: 13,
);

const boldBlackSmallText = TextStyle(
  color: Colors.black,
  fontSize: 13,
  fontWeight: FontWeight.bold,
);
