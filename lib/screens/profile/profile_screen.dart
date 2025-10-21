import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../main.dart';
import '../../services/supabase_service.dart';
import '../../models/profile_model.dart';
import '../../utils/app_routes.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Profile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;

  // Controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _hobbyController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final data = await _supabaseService.getProfile();
      if (data != null) {
        final profile = Profile.fromJson(data);
        setState(() {
          _profile = profile;
          _usernameController.text = profile.username;
          _hobbyController.text = profile.hobby ?? '';
          _bioController.text = profile.bio ?? '';
        });
      } else {
        Get.snackbar(
          'Info',
          'Profil belum ditemukan. Silakan isi data profil.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat profil: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    try {
      final fileName =
          '${supabase.auth.currentUser!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      String imageUrl;

      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        imageUrl = await _supabaseService.uploadImageBytes(
          bytes,
          'avatars',
          fileName,
        );
      } else {
        final file = File(picked.path);
        imageUrl = await _supabaseService.uploadImage(
          file,
          'avatars',
          fileName,
        );
      }

      await _supabaseService.updateProfile(
        username: _profile?.username ?? '',
        avatarUrl: imageUrl,
      );

      await _loadProfile();
      Get.snackbar(
        'Sukses',
        'Foto profil berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal upload avatar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _saveProfile() async {
    try {
      final username = _usernameController.text.trim();
      final hobby = _hobbyController.text.trim();
      final bio = _bioController.text.trim();

      if (username.isEmpty && hobby.isEmpty && bio.isEmpty) {
        Get.snackbar(
          'Error',
          'Semua field masih kosong!',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      await _supabaseService.updateProfile(
        username: username,
        hobby: hobby,
        bio: bio,
      );

      Get.snackbar(
        'Sukses',
        'Profil berhasil diperbarui',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      setState(() {
        _isEditing = false;
      });
      await _loadProfile();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan profil: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = _profile;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Profil ${profile?.username ?? 'Pengguna'}"),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          children: [
            GestureDetector(
              onTap: _uploadAvatar,
              child: Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      (profile?.avatarUrl != null &&
                          profile!.avatarUrl!.isNotEmpty)
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child:
                      (profile?.avatarUrl == null ||
                          profile!.avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 80, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile?.username ?? "Belum ada nama",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ---------------------
            // Bagian tampilan normal
            // ---------------------
            if (!_isEditing) ...[
              _buildTile(Icons.info, "Bio", profile?.bio ?? "-"),
              const SizedBox(height: 16),
              _buildTile(Icons.videogame_asset, "Hobi", profile?.hobby ?? "-"),
              const SizedBox(height: 16),
              _buildTile(Icons.email, "Email", profile?.email ?? "-"),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => setState(() => _isEditing = true),
                icon: const Icon(Icons.edit),
                label: const Text("Ubah Data Profil"),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ] else ...[
              // ---------------------
              // Mode Edit Inline
              // ---------------------
              _buildInputField("Nama", _usernameController),
              const SizedBox(height: 12),
              _buildInputField("Hobi", _hobbyController),
              const SizedBox(height: 12),
              _buildInputField("Bio", _bioController),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text("Simpan"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => setState(() => _isEditing = false),
                icon: const Icon(Icons.close),
                label: const Text("Batal"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_circle_right),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
