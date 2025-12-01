import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../utils/app_routes.dart'; // Tambahkan ini

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _signUp() async {
    // Validasi input
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field wajib diisi!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Sign up dengan Supabase Auth
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {'username': usernameController.text.trim()},
      );

      final user = response.user;

      if (user == null) {
        throw Exception('User tidak dibuat.');
      }

      // 2. Create profile secara manual
      try {
        await supabase.from('profiles').insert({
          'id': user.id,
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      } catch (profileError) {
        // Ignore jika profil sudah ada atau error kecil
      }

      Get.snackbar(
        'Sukses!',
        'Akun berhasil dibuat. Silakan login.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Redirect ke login
      Get.offAllNamed(AppRoutes.login);
    } on AuthException catch (e) {
      // Tampilkan error detail dari Supabase
      String errorMessage = e.message;

      // Translate common errors to Indonesian
      if (e.message.contains('already registered')) {
        errorMessage = 'Email sudah terdaftar. Gunakan email lain.';
      } else if (e.message.contains('weak password')) {
        errorMessage = 'Password terlalu lemah. Minimal 6 karakter.';
      } else if (e.message.contains('invalid email')) {
        errorMessage = 'Format email tidak valid.';
      }

      Get.snackbar(
        'Gagal Mendaftar',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Error System',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  hintText: "Masukkan Username",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  hintText: "Masukkan Email",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Password",
                  hintText: "Masukkan Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                onSubmitted: (_) => _signUp(),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Daftar"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Sudah punya akun? Login di sini"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
