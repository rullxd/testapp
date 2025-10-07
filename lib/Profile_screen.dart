import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Profil"),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            Image.asset("assets/Logo for all crypto.jpeg", height: 200),
            const SizedBox(height: 16),
            const Text(
              "Hiyosashii",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Alamat",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.favorite, color: Colors.red),
                Icon(Icons.favorite, color: Colors.red),
                Icon(Icons.favorite, color: Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text("Alamat"),
              subtitle: Text("Arabasta"),
              trailing: Icon(Icons.arrow_circle_right),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text("Hobi"),
              subtitle: Text("Game"),
              trailing: Icon(Icons.arrow_circle_right),
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text("Umur"),
              subtitle: Text("20"),
              trailing: Icon(Icons.arrow_circle_right),
            ),
          ],
        ),
      ),
    );
  }
}
