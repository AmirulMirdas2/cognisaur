import 'package:flutter/material.dart';
import 'halaman_beranda.dart';
import 'halaman_koleksi.dart';
import 'latihan_screen.dart';
import 'halaman_perulangan.dart';
import 'halaman_profil.dart';

// --- WIDGET NAVIGASI BAWAH (BOTTOM NAVBAR) UTAMA ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2; // Default ke tab 'Latihan' sesuai desain

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CollectionScreen(),
    VocabularyDetailScreen(),
    ReviewScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Koleksi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Latihan'),
          BottomNavigationBarItem(icon: Icon(Icons.loop), label: 'Perulangan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
