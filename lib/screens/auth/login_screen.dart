// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import '../../utils/app_routes.dart';
// Jika kamu punya StorageKeys di constants.dart, import dan gunakan:
// import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final resp = await supabase.auth.signInWithPassword(
        email: _emailC.text.trim(),
        password: _passC.text,
      );

      if (resp.user != null) {
        // Opsional: simpan flag lokal (Supabase sudah persist session)
        final box = GetStorage();
        await box.write('is_logged_in', true);
        // Jika pakai constants.dart:
        // await box.write(StorageKeys.isLoggedIn, true);

        // Arahkan ke Home (atau Profile, sesuai kebutuhan rute kamu)
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Error',
          'Gagal login. Periksa email/password.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Login gagal',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan tak terduga',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 420.0;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Email
                  TextFormField(
                    controller: _emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Masukkan Email',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      final email = v.trim();
                      final ok = RegExp(
                        r'^[^@]+@[^@]+\.[^@]+$',
                      ).hasMatch(email);
                      if (!ok) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    controller: _passC,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Masukkan Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (_) => _signIn(),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password wajib diisi';
                      if (v.length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Button Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Link ke Register (pakai route kalau sudah didaftarkan)
                  TextButton(
                    onPressed: () {
                      // Kalau ada route: Get.toNamed(AppRoutes.register);
                      // Jika belum, dan kamu punya RegisterScreen:
                      // Get.to(() => const RegisterScreen());
                      Get.toNamed(AppRoutes.register);
                    },
                    child: const Text('Belum punya akun? Daftar di sini'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
