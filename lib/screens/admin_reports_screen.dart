import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';
import 'admin_manage_users_screen.dart';
import 'admin_manage_menu_screen.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Laporan',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatCard(context,
              title: 'Total Pengguna',
              value: '24',
              icon: Icons.people,
              color: const Color(0xFF3B82F6),
            ),
            const SizedBox(height: 16),
            _buildStatCard(context,
              title: 'Total Menu Kalori',
              value: '4250',
              icon: Icons.local_fire_department,
              color: const Color(0xFFFF6B6B),
            ),
            const SizedBox(height: 16),
            _buildReportSection(context,
              title: 'Pencarian Terpopuler',
              items: const ['Nasi Goreng', 'Burger', 'Kopi Susu'],
              icon: Icons.trending_up,
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 16),
            _buildReportSection(context,
              title: 'Menu Kalori Tertinggi/Terendah',
              items: const ['Tertinggi: Pasta (310)', 'Terendah: Es Teh Manis (90)'],
              icon: Icons.trending_down,
              color: const Color(0xFFFFA500),
            ),
            const SizedBox(height: 16),
            _buildReportSection(context,
              title: 'Menu Ditambahkan Bulan Ini',
              items: const ['Pasta', 'Smoothie Pisang', 'Sate Ayam'],
              icon: Icons.add_circle_outline,
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Build content with optional action buttons depending on the card
        final List<Widget> actions = [];
        if (title.toLowerCase().contains('pengguna')) {
          actions.add(ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => const AdminManageUsersScreen()),
              );
            },
            child: Text('Lihat Pengguna', style: GoogleFonts.inter()),
          ));
        }
        if (title.toLowerCase().contains('menu')) {
          actions.add(ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => const AdminManageMenuScreen()),
              );
            },
            child: Text('Buka Kelola Menu', style: GoogleFonts.inter()),
          ));
        }

        _showDetailDialog(
          context,
          title,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Lihat detail lebih lanjut atau filter data di sini.',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textLight),
              ),
              const SizedBox(height: 12),
              if (actions.isNotEmpty)
                Row(
                  children: actions
                      .map((w) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: w,
                          ))
                      .toList(),
                ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withAlpha(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportSection(BuildContext context, {
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        _showDetailDialog(
          context,
          title,
          SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items
                  .map((i) => ListTile(
                        title: Text(i, style: GoogleFonts.inter()),
                        onTap: () {
                          Navigator.pop(context);
                          _showDetailDialog(
                            context,
                            i,
                            Text('Detail untuk "$i"', style: GoogleFonts.inter()),
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withAlpha(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...items.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      _showDetailDialog(
                        context,
                        e.value,
                        Text('Detail untuk "${e.value}"', style: GoogleFonts.inter()),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            e.value,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: SingleChildScrollView(child: content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}