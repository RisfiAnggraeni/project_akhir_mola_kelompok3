import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main_navigation.dart';
import 'register_screen.dart';
import 'admin_dashboard.dart';
import '../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'user';
  bool _obscurePassword = true;
  bool _rememberMe = false;

  static const List<Map<String, String>> _defaultAdmins = [
    {'email': 'admin1@email.com', 'password': 'admin123', 'name': 'Admin 1'},
    {'email': 'nailacahya580@gmail.com', 'password': '123456', 'name': 'cahya nayla'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAdmins();
    _loadSavedLogin();
  }

  Future<void> _initializeAdmins() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('admins')) {
      await prefs.setString('admins', jsonEncode(_defaultAdmins));
    }
  }

  Future<void> _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString('saved_admin_email');
    final savedPassword = prefs.getString('saved_admin_password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
        _rememberMe = true;
        _selectedRole = 'admin';
      });
    }
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // =======================
    // LOGIN ADMIN (LOCAL)
    // =======================
    if (_selectedRole == 'admin') {
      final adminsJson = prefs.getString('admins');
      List admins = [];

      try {
        admins = adminsJson != null ? jsonDecode(adminsJson) : _defaultAdmins;
      } catch (_) {
        admins = _defaultAdmins;
      }

      final matchedAdmin = admins.where((a) =>
          a['email'] == _emailController.text &&
          a['password'] == _passwordController.text).toList();

      if (matchedAdmin.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau password admin salah!')),
        );
        return;
      }

      if (_rememberMe) {
        await prefs.setString('saved_admin_email', _emailController.text);
        await prefs.setString('saved_admin_password', _passwordController.text);
      } else {
        await prefs.remove('saved_admin_email');
        await prefs.remove('saved_admin_password');
      }

      await prefs.setString('current_user_email', _emailController.text);
      await prefs.setString('current_user_role', 'admin');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      }
      return;
    }

    // =======================
    // LOGIN USER (FIREBASE)
    // =======================
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await prefs.setString('current_user_email', _emailController.text);
      await prefs.setString('current_user_role', 'user');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email atau password salah"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER IMAGE
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/healthy.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'Masuk',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Akses informasi menu dan kalori',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textLight,
              ),
            ),

            const SizedBox(height: 32),

            // EMAIL
            Text(
              "Email",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'nama@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 20),

            // PASSWORD
            Text(
              "Password",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Masukkan password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ROLE DROPDOWN
            Text(
              "Login sebagai",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _selectedRole,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('User')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (v) {
                  setState(() {
                    _selectedRole = v!;
                  });
                },
              ),
            ),

            if (_selectedRole == 'admin') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (v) {
                      setState(() {
                        _rememberMe = v ?? false;
                      });
                    },
                  ),
                  const Text("Ingat saya"),
                ],
              )
            ],

            const SizedBox(height: 32),

            // BUTTON LOGIN
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text(
                "Masuk",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: Divider(color: AppTheme.textLight)),
                const SizedBox(width: 12),
                Text("atau",
                    style: GoogleFonts.inter(color: AppTheme.textLight)),
                const SizedBox(width: 12),
                Expanded(child: Divider(color: AppTheme.textLight)),
              ],
            ),

            const SizedBox(height: 24),

            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Belum punya akun? ',
                      style: GoogleFonts.inter(color: AppTheme.textLight),
                    ),
                    TextSpan(
                      text: 'Daftar',
                      style: GoogleFonts.inter(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
