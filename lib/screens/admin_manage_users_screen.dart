import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';

class AdminManageUsersScreen extends StatefulWidget {
  const AdminManageUsersScreen({super.key});

  @override
  State<AdminManageUsersScreen> createState() => _AdminManageUsersScreenState();
}

class _AdminManageUsersScreenState extends State<AdminManageUsersScreen> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      try {
        final loadedUsers = jsonDecode(usersJson) as List;
        setState(() {
          users = loadedUsers.cast<Map<String, dynamic>>();
        });
      } catch (_) {
        setState(() {
          users = [];
        });
      }
    }
  }

  Future<void> _deleteUser(int index) async {
    final prefs = await SharedPreferences.getInstance();
    users.removeAt(index);
    await prefs.setString('users', jsonEncode(users));
    setState(() {});
  }

  Future<void> _toggleAdminRole(int index) async {
    final prefs = await SharedPreferences.getInstance();
    users[index]['role'] = users[index]['role'] == 'admin' ? 'user' : 'admin';
    await prefs.setString('users', jsonEncode(users));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Kelola Pengguna',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
      ),
      body: users.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: AppTheme.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada pengguna',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isAdmin = user['role'] == 'admin';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shadowColor: Colors.black.withAlpha(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isAdmin
                                  ? AppTheme.accentColor.withAlpha(26)
                                  : AppTheme.primaryColor.withAlpha(26),
                              child: Icon(
                                isAdmin
                                    ? Icons.admin_panel_settings
                                    : Icons.person,
                                color: isAdmin
                                    ? AppTheme.accentColor
                                    : AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name'] ?? 'Unknown',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user['email'] ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppTheme.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isAdmin
                                    ? AppTheme.accentColor.withAlpha(26)
                                    : AppTheme.primaryColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isAdmin ? 'Admin' : 'User',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isAdmin
                                      ? AppTheme.accentColor
                                      : AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _toggleAdminRole(index),
                              icon: const Icon(Icons.edit, size: 18),
                              label: Text(
                                'Ubah Role',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Konfirmasi',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      'Yakin ingin menghapus user ini?',
                                      style: GoogleFonts.inter(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Batal',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textLight,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _deleteUser(index);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Hapus',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete, size: 18),
                              label: Text(
                                'Hapus',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
