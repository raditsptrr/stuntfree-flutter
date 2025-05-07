import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundGradient,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/images/child.png',
                          height: 150, // ✅ lebih kecil
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                            decoration: containerDecoration,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Hai\n',
                                        style: orangeTitleText,
                                      ),
                                      TextSpan(
                                        text: 'Selamat Datang!',
                                        style: blueTitleText,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Sobat Jalu silahkan masuk untuk melaporkan',
                                  style: greySubtitleText,
                                ),
                                const SizedBox(height: 20),
                                _buildTextField(label: 'Email'),
                                const SizedBox(height: 20),
                                _buildTextField(label: 'Kata Sandi', isPassword: true),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () { Navigator.pushReplacementNamed(context, '/home');},
                                  style: buttonStyle,
                                  child: const Text(
                                    'Masuk',
                                    style: buttonTextStyle,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Belum punya akun? ',
                                          style: greySmallText,
                                        ),
                                        TextSpan(
                                          text: 'Daftar di sini',
                                          style: boldBlackSmallText,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(context, '/signup');
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
                    ),
                  ),
                ),
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
// Styling
// ==============================

const backgroundGradient = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
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

const orangeTitleText = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.orange,
);

const blueTitleText = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Color(0xFF5D78FD),
);

const greySubtitleText = TextStyle(
  color: Colors.grey,
  fontSize: 14,
);

const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF5D78FD),
  minimumSize: const Size.fromHeight(50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
);

const greySmallText = TextStyle(
  color: Color.fromARGB(255, 212, 212, 212),
  fontSize: 12,
);

const boldBlackSmallText = TextStyle(
  color: Colors.black,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

