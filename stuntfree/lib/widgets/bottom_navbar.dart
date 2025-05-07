import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // <== tambahkan ini

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFF5D78FD),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            iconSize: 20,
            items: const [
              BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Beranda'),
              BottomNavigationBarItem(icon: Icon(Iconsax.edit), label: 'dataanak'),
              BottomNavigationBarItem(icon: Icon(Iconsax.book), label: 'Berita'),
              BottomNavigationBarItem(icon: Icon(Iconsax.setting_2), label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}
