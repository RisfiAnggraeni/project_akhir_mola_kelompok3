import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 🔹 Timer untuk berpindah otomatis ke halaman login
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // kamu bisa ganti ke Colors.green[600] kalau mau
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Logo aplikasi
            Image.asset(
              'assets/images/healthy.jpeg', // ubah sesuai file kamu
              width: 130,
              height: 130,
            ),
            const SizedBox(height: 25),

            // 🔹 Nama aplikasi
            const Text(
              'Info Menu & Kalori',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Tagline tambahan
            const Text(
              'Kenali Kalori Makananmu dan Minumanmu 🍱',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Indikator loading
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
