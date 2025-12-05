import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import '../utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'user';
  bool _allowAdmin = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final usersJson = prefs.getString('users');
      bool hasAdmin = false;
      if (usersJson != null) {
        try {
          final List users = jsonDecode(usersJson);
          hasAdmin = users.any((u) => (u['role'] ?? 'user') == 'admin');
        } catch (_) {}
      }
      if (mounted) setState(() => _allowAdmin = !hasAdmin);
    });
  }

  Future<void> _saveUserData() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi!')));
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

    final exists = users.any((u) => u['email'] == _emailController.text);
    if (exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email sudah terdaftar')));
      return;
    }

    final newUser = {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'role': _selectedRole,
    };
    users.add(newUser);
    await prefs.setString('users', jsonEncode(users));
    await prefs.setString('current_user_email', _emailController.text);

    if (mounted) {
      print(
        'Saved user -> name: ${_nameController.text}, email: ${_emailController.text}, phone: ${_phoneController.text}, address: ${_addressController.text}, role: $_selectedRole',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Daftar',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Buat Akun Baru',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bergabunglah dengan ribuan pengguna lainnya',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 32),
              _buildFieldLabel('Nama Lengkap'),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: const Icon(Icons.person_outline),
                  prefixIconColor: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Email'),
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
              _buildFieldLabel('Nomor Telepon'),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: '08xxxxxxxxxx',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  prefixIconColor: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Alamat'),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  prefixIconColor: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Masukkan password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  prefixIconColor: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Daftar Sebagai'),
              const SizedBox(height: 8),
              if (_allowAdmin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          'User',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        value: 'user',
                        groupValue: _selectedRole,
                        onChanged: (v) => setState(() => _selectedRole = v!),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text(
                          'Admin',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        value: 'admin',
                        groupValue: _selectedRole,
                        onChanged: (v) => setState(() => _selectedRole = v!),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'User (Admin sudah ada)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveUserData,
                child: Text(
                  'Daftar',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textLight,
                        ),
                      ),
                      TextSpan(
                        text: 'Masuk',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
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
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textDark,
      ),
    );
  }
}
