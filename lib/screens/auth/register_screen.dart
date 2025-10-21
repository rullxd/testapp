import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testapp/screens/auth/login_screen.dart';
import '../../main.dart';

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
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field wajib diisi!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🔹 Membuat akun baru di Supabase
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'username': usernameController.text
              .trim(), // 🔹 kirim metadata ke Supabase
        },
      );

      final user = response.user;
      if (user == null) throw Exception('Gagal membuat akun.');

      // 🔹 Tidak perlu insert ke tabel profiles manual,
      // karena sudah otomatis lewat trigger di Supabase.

      Get.snackbar(
        'Sukses',
        'Akun berhasil dibuat! Silakan login.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // 🔹 Arahkan langsung ke halaman Profile setelah register (opsional)
      Get.offAll(() => const LoginScreen());
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
        e.toString(),
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
                onSubmitted: (_) => _signUp(), // ✅ tekan Enter untuk login
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
