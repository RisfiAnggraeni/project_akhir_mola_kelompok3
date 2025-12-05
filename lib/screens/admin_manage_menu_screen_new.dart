import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';

class AdminManageMenuScreen extends StatefulWidget {
  const AdminManageMenuScreen({super.key});

  @override
  State<AdminManageMenuScreen> createState() => _AdminManageMenuScreenState();
}

class _AdminManageMenuScreenState extends State<AdminManageMenuScreen> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Nasi Goreng',
      'price': 25000,
      'description': 'Nasi goreng spesial dengan telur dan sayuran',
    },
    {
      'name': 'Mie Goreng',
      'price': 20000,
      'description': 'Mie goreng lezat dengan bumbu pilihan',
    },
    {
      'name': 'Soto Ayam',
      'price': 18000,
      'description': 'Soto ayam tradisional yang hangat',
    },
  ];

  void _addMenu() {
    showDialog(context: context, builder: (context) => const AddMenuDialog());
  }

  void _editMenu(int index) {
    showDialog(
      context: context,
      builder: (context) => EditMenuDialog(item: menuItems[index]),
    );
  }

  void _deleteMenu(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Konfirmasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Yakin ingin menghapus menu ini?',
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
              setState(() {
                menuItems.removeAt(index);
              });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Kelola Menu',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        actions: [IconButton(onPressed: _addMenu, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['description'],
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
                          color: AppTheme.accentColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Rp${item['price']}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accentColor,
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
                        onPressed: () => _editMenu(index),
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(
                          'Edit',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _deleteMenu(index),
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

class AddMenuDialog extends StatelessWidget {
  const AddMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Tambah Menu',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: Text(
        'Feature belum diimplementasikan',
        style: GoogleFonts.inter(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Tutup',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class EditMenuDialog extends StatelessWidget {
  final Map<String, dynamic> item;

  const EditMenuDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Menu',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: Text(
        'Feature belum diimplementasikan',
        style: GoogleFonts.inter(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Tutup',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
