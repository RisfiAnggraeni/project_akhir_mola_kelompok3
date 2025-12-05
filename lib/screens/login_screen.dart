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
  bool _rememberMe = false;

  // Admin credentials yang sudah tersimpan
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
    
    // Cek apakah admin sudah tersimpan
    final adminsJson = prefs.getString('admins');
    if (adminsJson == null) {
      // Simpan admin default jika belum ada
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

    if (_selectedRole == 'admin') {
      // Check admin credentials
      final adminsJson = prefs.getString('admins');
      List admins = [];
      if (adminsJson != null) {
        try {
          admins = jsonDecode(adminsJson);
        } catch (_) {
          admins = _defaultAdmins;
        }
      } else {
        admins = _defaultAdmins;
      }

      final matchedAdmin = admins.firstWhere(
        (a) =>
            a['email'] == _emailController.text &&
            a['password'] == _passwordController.text,
        orElse: () => null,
      );

      if (matchedAdmin == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email atau password admin salah!')),
          );
        }
        return;
      }

      // Simpan login jika remember me diaktifkan
      if (_rememberMe) {
        await prefs.setString('saved_admin_email', _emailController.text);
        await prefs.setString('saved_admin_password', _passwordController.text);
      } else {
        await prefs.remove('saved_admin_email');
        await prefs.remove('saved_admin_password');
      }

      // Set session current user
      await prefs.setString('current_user_email', _emailController.text);
      await prefs.setString('current_user_role', 'admin');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      }
    } else {
      // Check user credentials
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
        // Check if email exists at all
        final exists = users.any((u) => u['email'] == _emailController.text);
        if (!exists) {
          // Offer to register with this email
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Akun tidak ditemukan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                content: Text('Email belum terdaftar. Ingin mendaftar sekarang?', style: GoogleFonts.inter()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Batal', style: GoogleFonts.inter()),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(
                            initialEmail: _emailController.text,
                            initialPassword: _passwordController.text,
                          ),
                        ),
                      );
                    },
                    child: Text('Daftar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            );
          }
          return;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email atau password salah!')),
          );
        }
        return;
      }

      // Set session current user
      await prefs.setString('current_user_email', _emailController.text);
      await prefs.setString('current_user_role', 'user');

      if (mounted) {
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

            const SizedBox(height: 16),

            // Remember Me Checkbox (hanya untuk admin)
            if (_selectedRole == 'admin')
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  Text(
                    'Ingat saya',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
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
