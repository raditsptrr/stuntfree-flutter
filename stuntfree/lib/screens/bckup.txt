import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                  Image.asset(
                    'assets/images/child.png',
                    height: 180,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: containerDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hai\n',
                                  style: orangeTitleTextSmall,
                                ),
                                TextSpan(
                                  text: 'Selamat Datang!',
                                  style: blueTitleTextSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sobat Jalu, silahkan daftar untuk mulai menggunakan aplikasi',
                            style: greySubtitleSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(label: 'Nama'),
                          const SizedBox(height: 12),
                          _buildTextField(label: 'Email'),
                          const SizedBox(height: 12),
                          _buildTextField(label: 'Kata Sandi', isPassword: true),
                          const SizedBox(height: 12),
                          _buildTextField(label: 'Konfirmasi Kata Sandi', isPassword: true),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // aksi daftar
                            },
                            style: buttonStyleSmall,
                            child: const Text(
                              'Daftar',
                              style: buttonTextStyle,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Sudah punya akun? ',
                                    style: greySmallText,
                                  ),
                                  TextSpan(
                                    text: 'Masuk di sini',
                                    style: boldBlackSmallText,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  static Widget _buildTextField({required String label, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      cursorColor: Color(0xFF5D78FD),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF5D78FD),
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF5D78FD),
            width: 2,
          ),
        ),
      ),
    );
  }
}

// ==============================
// Styling untuk SignupPage
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
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(30),
  ),
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
