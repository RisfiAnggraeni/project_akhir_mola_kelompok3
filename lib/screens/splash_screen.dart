import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import '../utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if users list exists
      String? usersJson = prefs.getString('users');
      List users = [];

      if (usersJson != null) {
        try {
          users = jsonDecode(usersJson);
        } catch (_) {
          users = [];
        }
      }

      // Create default test account if no users exist
      if (users.isEmpty) {
        final testUser = {
          'name': 'Test User',
          'email': 'test@example.com',
          'password': 'password123',
          'phone': '0812345678',
          'address': 'Test Address',
          'role': 'user',
        };
        users.add(testUser);
        await prefs.setString('users', jsonEncode(users));
        print('✅ Default test user created: test@example.com / password123');
      } else {
        print('✅ Users found: ${users.length} user(s)');
      }
    } catch (e) {
      print('❌ Error initializing app: $e');
    }

    // Navigate after 3 seconds
    if (mounted) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withAlpha(51),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/healthy.jpeg',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fastfood,
                    size: 120,
                    color: AppTheme.primaryColor,
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Info Menu & Kalori',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Kenali Kalori Makananmu',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
