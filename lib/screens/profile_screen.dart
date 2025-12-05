import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Cahya Nayla';
  String email = 'nailacahya580@gmail.com';
  String phone = '08988213616';
  String address = 'Bandar Lampung';
  int age = 0;
  double weight = 0;
  double height = 0;
  double calorieTarget = 2000;
  String? profileImageBase64;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString('current_user_email');
    final usersJson = prefs.getString('users');
    if (usersJson != null && currentEmail != null) {
      try {
        final users = jsonDecode(usersJson) as List;
        final user = users.firstWhere(
          (u) => u['email'] == currentEmail,
          orElse: () => null,
        );
        if (user != null) {
          setState(() {
            name = user['name'] ?? name;
            email = user['email'] ?? email;
            phone = user['phone'] ?? phone;
            address = user['address'] ?? address;
            age = user['age'] ?? 0;
            weight = (user['weight'] is int) ? (user['weight'] as int).toDouble() : (user['weight'] ?? 0);
            height = (user['height'] is int) ? (user['height'] as int).toDouble() : (user['height'] ?? 0);
            calorieTarget = (user['calorieTarget'] is int) ? (user['calorieTarget'] as int).toDouble() : (user['calorieTarget'] ?? 2000);
            profileImageBase64 = user['profileImage'];
          });
          return;
        }
      } catch (_) {}
    }

    // fallback to defaults
    setState(() {
      name = prefs.getString('user_name') ?? name;
      email = prefs.getString('user_email') ?? email;
      phone = prefs.getString('user_phone') ?? phone;
      address = prefs.getString('user_address') ?? address;
    });
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_email');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withAlpha(204),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor.withAlpha(51),
                      backgroundImage: profileImageBase64 != null
                          ? MemoryImage(base64Decode(profileImageBase64!))
                          : null,
                      child: profileImageBase64 == null
                          ? Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileInfoRow(Icons.person, 'Nama', name),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                    _buildProfileInfoRow(Icons.email, 'Email', email),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                    _buildProfileInfoRow(Icons.cake_outlined, 'Umur', age > 0 ? '$age tahun' : '-'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                    _buildProfileInfoRow(Icons.monitor_weight_outlined, 'Berat Badan', weight > 0 ? '${weight.toStringAsFixed(1)} kg' : '-'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                    _buildProfileInfoRow(Icons.height, 'Tinggi Badan', height > 0 ? '${height.toStringAsFixed(0)} cm' : '-'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                    _buildProfileInfoRow(Icons.local_fire_department, 'Target Kalori', '${calorieTarget.toStringAsFixed(0)} kcal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      name: name,
                      email: email,
                      phone: phone,
                      address: address,
                      age: age,
                      weight: weight,
                      height: height,
                      calorieTarget: calorieTarget,
                    ),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
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

                  final idx = users.indexWhere((u) => u['email'] == email);
                  if (idx != -1) {
                    users[idx] = {
                      'name': result['name'] ?? users[idx]['name'],
                      'email': result['email'] ?? users[idx]['email'],
                      'phone': result['phone'] ?? users[idx]['phone'],
                      'address': result['address'] ?? users[idx]['address'],
                      'role': users[idx]['role'] ?? 'user',
                      'password': users[idx]['password'] ?? '',
                      'profileImage':
                          result['profileImage'] ?? users[idx]['profileImage'],
                      'age': result['age'] ?? users[idx]['age'] ?? 0,
                      'weight': result['weight'] ?? users[idx]['weight'] ?? 0,
                      'height': result['height'] ?? users[idx]['height'] ?? 0,
                      'calorieTarget': result['calorieTarget'] ?? users[idx]['calorieTarget'] ?? 2000,
                    };
                    await prefs.setString('users', jsonEncode(users));
                    if ((result['email'] ?? email) != email) {
                      await prefs.setString(
                        'current_user_email',
                        result['email'],
                      );
                    }
                  }

                  setState(() {
                    name = result['name'] ?? name;
                    email = result['email'] ?? email;
                    phone = result['phone'] ?? phone;
                    address = result['address'] ?? address;
                    age = result['age'] ?? age;
                    weight = result['weight'] ?? weight;
                    height = result['height'] ?? height;
                    calorieTarget = result['calorieTarget'] ?? calorieTarget;
                    profileImageBase64 = result['profileImage'];
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: Text(
                'Edit Profil',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _handleLogout,
              icon: Icon(Icons.logout, color: AppTheme.textLight),
              label: Text(
                'Keluar',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
