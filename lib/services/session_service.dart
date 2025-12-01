import 'package:get_storage/get_storage.dart';

class SessionService {
  final _box = GetStorage();
  static const _kIsLoggedIn = 'isLoggedIn';
  static const _kUser = 'user'; // Map<String, dynamic>

  bool get isLoggedIn => _box.read(_kIsLoggedIn) ?? false;

  Map<String, dynamic>? get user {
    final data = _box.read(_kUser);
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  Future<void> _setLoggedIn(bool v) => _box.write(_kIsLoggedIn, v);
  Future<void> _saveUser(Map<String, dynamic> u) => _box.write(_kUser, u);

  // Login sederhana: jika belum ada user → buat dari input
  Future<bool> login(String email, String password) async {
    final e = email.trim().toLowerCase();
    final p = password;
    final u = user;

    if (u == null) {
      final newUser = {
        'email': e,
        'password': p, // DEMO: plaintext (untuk belajar)
        'name': e.split('@').first,
        'bio': '',
      };
      await _saveUser(newUser);
      await _setLoggedIn(true);
      return true;
    } else {
      final ok = (u['email'] == e) && (u['password'] == p);
      if (ok) {
        await _setLoggedIn(true);
        return true;
      }
      return false;
    }
  }

  Future<void> logout() async {
    await _box.write(_kIsLoggedIn, false);
  }

  Future<void> updateProfile({String? name, String? bio}) async {
    final u = user ?? {};
    if (name != null) u['name'] = name;
    if (bio != null) u['bio'] = bio;
    await _saveUser(u);
  }
}

final session = SessionService(); // singleton simpel
