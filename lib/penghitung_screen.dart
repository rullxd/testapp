import 'package:flutter/material.dart';
import 'home_screen.dart';

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
  }

  pindahHalaman() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const HomeScreen()));
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
              child: const Text("Hitung"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                pindahHalaman();
              },
              child: const Text("Home"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Kembali"),
            ),
          ],
        ),
      ),
    );
  }
}
