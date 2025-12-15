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
  // 🔧 DEFAULT DIKOSONGKAN (INI PENTING)
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
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
        final List users = jsonDecode(usersJson);
        final user = users.firstWhere(
          (u) => u['email'] == currentEmail,
          orElse: () => null,
        );

        if (user != null && mounted) {
          setState(() {
            name = user['name'] ?? '';
            email = user['email'] ?? '';
            phone = user['phone'] ?? '';
            address = user['address'] ?? '';
            age = user['age'] ?? 0;
            weight = (user['weight'] ?? 0).toDouble();
            height = (user['height'] ?? 0).toDouble();
            calorieTarget =
                (user['calorieTarget'] ?? 2000).toDouble();
            profileImageBase64 = user['profileImage'];
          });
        }
      } catch (e) {
        debugPrint('Error load profile: $e');
      }
    }
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
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        AppTheme.primaryColor.withAlpha(51),
                    backgroundImage: profileImageBase64 != null
                        ? MemoryImage(
                            base64Decode(profileImageBase64!))
                        : null,
                    child: profileImageBase64 == null
                        ? const Icon(Icons.person,
                            size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name.isNotEmpty ? name : '-',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email.isNotEmpty ? email : '-',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildProfileInfoRow(Icons.person, 'Nama', name),
            _buildProfileInfoRow(Icons.email, 'Email', email),
            _buildProfileInfoRow(Icons.cake, 'Umur',
                age > 0 ? '$age tahun' : '-'),
            _buildProfileInfoRow(
                Icons.monitor_weight, 'Berat',
                weight > 0 ? '$weight kg' : '-'),
            _buildProfileInfoRow(
                Icons.height, 'Tinggi',
                height > 0 ? '$height cm' : '-'),
            _buildProfileInfoRow(
                Icons.local_fire_department,
                'Target Kalori',
                '$calorieTarget kcal'),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(
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
                _loadUserData(); // 🔁 refresh setelah edit
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),

            TextButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(
      IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(value.isNotEmpty ? value : '-'),
    );
  }
}
