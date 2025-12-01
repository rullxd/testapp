// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'utils/constants.dart';
import 'utils/app_routes.dart';

// (Tambahan) Jika kamu pakai SessionService seperti yang kuberikan di canvas,
// aktifkan import ini dan pastikan file-nya ada:
// import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi local storage
  await GetStorage.init();

  // Inisialisasi Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // Tentukan initial route berdasarkan status login
  final initialRoute = _resolveInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

// Supabase client global
final supabase = Supabase.instance.client;

/// Menentukan halaman awal:
/// - Jika ada session Supabase -> Home
/// - Jika tidak ada, cek flag lokal is_logged_in -> Home
/// - Jika keduanya tidak ada -> Login
String _resolveInitialRoute() {
  final session = supabase.auth.currentSession;
  if (session != null) {
    return AppRoutes.home;
  }

  final box = GetStorage();
  final isLoggedIn =
      box.read('is_logged_in') ==
      true; // StorageKeys.isLoggedIn kalau pakai constants.dart-ku
  return isLoggedIn ? AppRoutes.home : AppRoutes.login;

  // Kalau kamu ingin tetap mulai dari Splash:
  // return AppRoutes.splash;
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Supabase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
