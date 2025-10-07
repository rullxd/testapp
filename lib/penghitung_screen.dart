import 'package:flutter/material.dart';
import 'Profile_screen.dart';

class Penghitungscreen extends StatefulWidget {
  const Penghitungscreen({super.key});

  @override
  State<Penghitungscreen> createState() => _PenghitungscreenState();
}

class _PenghitungscreenState extends State<Penghitungscreen> {
  int nilai = 0;

  menghitung() {
    setState(() {});
    nilai = nilai + 1;
    print("ini nilai = $nilai");
  }

  pindahHalaman() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfilScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hitung $nilai"),
            ElevatedButton(
              onPressed: () {
                menghitung();
              },
              child: Text("Hitung"),
            ),
            TextButton(onPressed: () {}, child: Text("Pindah Profil")),
          ],
        ),
      ),
    );
  }
}
