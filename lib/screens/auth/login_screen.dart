// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testapp/screens/auth/register_screen.dart';
import '../../main.dart';
import '../profile/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Isi semua field terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🔹 Login Supabase menggunakan email (username dijadikan email di sini)
      final response = await supabase.auth.signInWithPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        // 🔹 Kalau berhasil login, pindah ke ProfileScreen
        Get.offAll(() => const ProfilScreen());
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
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan tidak terduga',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "LOGIN",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  hintText: "Masukkan Email",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText:
                    !_isPasswordVisible, // ✅ ubah dari true jadi tergantung state
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
                        _isPasswordVisible =
                            !_isPasswordVisible; // ✅ toggle status
                      });
                    },
                  ),
                ),
                onSubmitted: (_) => _signIn(), // ✅ tekan Enter untuk login
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.to(() => const RegisterScreen()),
                child: const Text("Belum punya akun? Daftar di sini"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
