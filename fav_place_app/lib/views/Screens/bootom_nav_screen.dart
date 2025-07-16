import 'package:flutter/material.dart';

class BootomNavScreen extends StatelessWidget {
  const BootomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (value) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BootomNavScreen()));
        },
      ),
    );
  }
}
