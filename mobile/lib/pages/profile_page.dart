import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final Color primaryColor = const Color(0xFFB89A5A);
  final Color backgroundColor = const Color(0xFFFFF8E7);
  final Color textColor = const Color(0xFF5B4636);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 30),

            // Foto profil
            Container(
              width: 130,
              height: 130,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 3,
                ),
              ),

              child: ClipOval(
                child: Image.asset(
                  'images/pp.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nama
            const Text(
              'Ibnu Hasan Abinaya',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B4636),
              ),
            ),

            const SizedBox(height: 6),

            // Keterangan
            const Text(
              'Penulis Blog',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            // Informasi
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),

                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.25),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Tentang',
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5B4636),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Blog App ini digunakan untuk membuat, '
                    'membaca, mengubah, dan menghapus artikel. '
                    'Aplikasi dibuat menggunakan Flutter dan '
                    'terhubung dengan REST API.',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}