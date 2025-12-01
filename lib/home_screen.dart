// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'main.dart';
import 'utils/app_routes.dart';
import 'screens/profile/profile_screen.dart';
import 'penghitung_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout() async {
    // 🔹 Logout dari Supabase
    await supabase.auth.signOut();

    // 🔹 Hapus flag login lokal
    final box = GetStorage();
    await box.remove('is_logged_in');

    // 🔹 Kembali ke halaman login
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    // Ambil user login dari Supabase
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${user?.email ?? "Pengguna"}'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol ke halaman Profil
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(160, 48),
              ),
              onPressed: () => Get.to(() => const ProfilScreen()),
              icon: const Icon(Icons.person),
              label: const Text('Profile'),
            ),
            const SizedBox(height: 16),

            // Tombol ke halaman Penghitung
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(160, 48),
              ),
              onPressed: () => Get.to(() => const Penghitungscreen()),
              icon: const Icon(Icons.calculate),
              label: const Text('Penghitung'),
            ),
          ],
        ),
      ),
    );
  }
}
