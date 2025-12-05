import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi!')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString('users');
    List users = [];
    if (usersJson != null) {
      try {
        users = jsonDecode(usersJson);
      } catch (_) {
        users = [];
      }
    }

    final matched = users.firstWhere(
      (u) =>
          u['email'] == _emailController.text &&
          u['password'] == _passwordController.text,
      orElse: () => null,
    );

    if (matched == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau password salah!')),
        );
      }
      return;
    }

    final savedRole = (matched['role'] ?? 'user') as String;
    if (_selectedRole != savedRole) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role mismatch: account is "$savedRole"')),
        );
      }
      return;
    }

    // Set session current user
    await prefs.setString('current_user_email', _emailController.text);

    if (mounted) {
      if (savedRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
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
            // Logo
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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.primaryColor,
                      child: const Icon(
                        Icons.restaurant,
                        size: 60,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Judul
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
                fontWeight: FontWeight.w400,
                color: AppTheme.textLight,
              ),
            ),

            const SizedBox(height: 32),

            // Email Input
            Text(
              'Email',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'nama@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                prefixIconColor: AppTheme.textLight,
              ),
            ),

            const SizedBox(height: 20),

            // Password Input
            Text(
              'Password',
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
                prefixIconColor: AppTheme.textLight,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.textLight,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Role Selection
            Text(
              'Login sebagai',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: _selectedRole,
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: 'user',
                    child: Text(
                      'User',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text(
                      'Admin',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _selectedRole = v ?? 'user'),
              ),
            ),

            const SizedBox(height: 32),

            // Login Button
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text(
                'Masuk',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                Expanded(
                  child: Divider(color: AppTheme.textLight.withAlpha(77)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'atau',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: AppTheme.textLight.withAlpha(77)),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Register Link
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Belum punya akun? ',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textLight,
                      ),
                    ),
                    TextSpan(
                      text: 'Daftar',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
