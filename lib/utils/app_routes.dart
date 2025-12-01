import 'package:get/get.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/home/notes_list_screen.dart';
import '../screens/home/note_form_screen.dart';
import '../screens/splash_screen.dart';
import '../home_screen.dart';
import '../penghitung_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const penghitung = '/penghitung';
  static const notesList = '/notes';
  static const noteForm = '/noteForm';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: profile, page: () => const ProfilScreen()),
    GetPage(name: penghitung, page: () => const Penghitungscreen()),
    GetPage(name: notesList, page: () => const NotesListScreen()),
    GetPage(name: noteForm, page: () => const NoteFormScreen()),
  ];
}
