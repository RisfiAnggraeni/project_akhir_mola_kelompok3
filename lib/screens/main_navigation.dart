import 'package:flutter/material.dart';
import 'menu_screen.dart';       // 🥗 Akan diubah jadi tampilan info gizi
import 'profile_screen.dart';    // 👤 Tetap ada untuk profil
import 'login_screen.dart';      // 🚪 Untuk logout dan login ulang

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MenuScreen(),        // Beranda / Info Makanan
    ProfileScreen(),     // Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex < 2 ? _pages[_currentIndex] : const SizedBox(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.redAccent, // 🔴 warna bawah
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Logout
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Apakah kamu yakin ingin keluar?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Ya, Logout'),
                  ),
                ],
              ),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
