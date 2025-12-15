import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calorie_history_screen.dart';
import 'detail_menu_screen.dart';
import '../utils/theme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Warna hijau tua baru
  static const Color _darkGreenPrimary = Color(0xFF1E8449); // Warna Hijau Tua yang dipilih

  double totalKalori = 0;
  double dailyTarget = 2000;
  String currentUserEmail = '';
  // State baru untuk fungsionalitas pencarian
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    // Tambahkan listener untuk controller pencarian
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_user_email') ?? '';
    setState(() {
      currentUserEmail = email;
    });
    await _loadDailyTarget();
    await _loadTodaysTotalFromHistory();
  }

  Future<void> _loadDailyTarget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getDouble('daily_target_$currentUserEmail');
      if (saved != null) {
        setState(() {
          dailyTarget = saved;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveDailyTarget(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('daily_target_$currentUserEmail', value);
    setState(() {
      dailyTarget = value;
    });
  }

  void _showEditTargetDialog() {
    final controller = TextEditingController(text: dailyTarget.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah Target Kalori', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Target kalori (kcal)'
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.inter()),
          ),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text.replaceAll(',', '.'));
              if (val != null && val > 0) {
                _saveDailyTarget(val);
              }
              Navigator.pop(context);
            },
            child: Text('Simpan', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Pizza',
      'image': 'assets/images/pizza.jpg',
      'desc': 'Pizza lezat dengan keju melimpah dan topping premium.',
      'nutrition': {
        'kalori': 285,
        'protein': 12,
        'lemak': 10,
        'karbohidrat': 36,
      },
    },
    {
      'name': 'Burger',
      'image': 'assets/images/burger.jpg',
      'desc': 'Burger daging sapi juicy dengan saus spesial rumah.',
      'nutrition': {
        'kalori': 354,
        'protein': 17,
        'lemak': 20,
        'karbohidrat': 29,
      },
    },
    {
      'name': 'Nasi Goreng',
      'image': 'assets/images/nasi_goreng.jpeg',
      'desc': 'Nasi goreng spesial dengan telur, ayam, dan sayuran segar.',
      'nutrition': {'kalori': 250, 'protein': 9, 'lemak': 8, 'karbohidrat': 35},
    },
    {
      'name': 'Mie Goreng',
      'image': 'assets/images/mie_goreng.jpeg',
      'desc': 'Mie goreng gurih dengan bumbu khas Indonesia.',
      'nutrition': {'kalori': 270, 'protein': 8, 'lemak': 9, 'karbohidrat': 40},
    },
    {
      'name': 'Ayam Bakar',
      'image': 'assets/images/ayam_bakar.jpeg',
      'desc': 'Ayam bakar bumbu madu dengan sambal pedas.',
      'nutrition': {
        'kalori': 300,
        'protein': 25,
        'lemak': 10,
        'karbohidrat': 15,
      },
    },
    {
      'name': 'Sate Ayam',
      'image': 'assets/images/sate_ayam.jpeg',
      'desc': 'Sate ayam khas Madura dengan bumbu kacang gurih.',
      'nutrition': {'kalori': 200, 'protein': 14, 'lemak': 9, 'karbohidrat': 8},
    },
    {
      'name': 'Pasta',
      'image': 'assets/images/pasta.jpg',
      'desc': 'Pasta lembut dengan saus tomat dan keju mozzarella.',
      'nutrition': {
        'kalori': 310,
        'protein': 11,
        'lemak': 6,
        'karbohidrat': 50,
      },
    },
  ];

  final List<Map<String, dynamic>> drinkItems = [
    {
      'name': 'Es Teh Manis',
      'image': 'assets/images/es_teh_manis.jpeg',
      'desc': 'Segelas es teh manis yang menyegarkan hari kamu.',
      'nutrition': {'kalori': 90, 'protein': 0, 'lemak': 0, 'karbohidrat': 23},
    },
    {
      'name': 'Es Jeruk',
      'image': 'assets/images/es_jeruk.jpeg',
      'desc': 'Es jeruk peras alami segar kaya vitamin C.',
      'nutrition': {'kalori': 110, 'protein': 1, 'lemak': 0, 'karbohidrat': 27},
    },
    {
      'name': 'Kopi Susu',
      'image': 'assets/images/kopi_susu.jpeg',
      'desc': 'Kopi susu kental manis dengan aroma khas kopi lokal.',
      'nutrition': {'kalori': 150, 'protein': 3, 'lemak': 5, 'karbohidrat': 22},
    },
    {
      'name': 'Cappucino',
      'image': 'assets/images/cappucino.jpeg',
      'desc': 'Kopi cappuccino dengan buih lembut dan aroma khas.',
      'nutrition': {'kalori': 120, 'protein': 4, 'lemak': 4, 'karbohidrat': 14},
    },
    {
      'name': 'Jus Alpukat',
      'image': 'assets/images/jus_alpukat.jpeg',
      'desc': 'Jus alpukat segar dengan cokelat leleh di atasnya.',
      'nutrition': {
        'kalori': 180,
        'protein': 3,
        'lemak': 12,
        'karbohidrat': 15,
      },
    },
    {
      'name': 'Matcha Latte',
      'image': 'assets/images/matcha_latte.jpeg',
      'desc': 'Minuman hijau segar dengan aroma matcha yang menenangkan.',
      'nutrition': {'kalori': 160, 'protein': 5, 'lemak': 4, 'karbohidrat': 20},
    },
    {
      'name': 'Smoothie Pisang',
      'image': 'assets/images/Smoothie_Pisang.jpg',
      'desc': 'Minuman segar, lezat dan bergizi.',
      'nutrition': {'kalori': 180, 'protein': 4, 'lemak': 2, 'karbohidrat': 38},
    }
  ];

  void tambahKalori(double kalori, String nama) {
    setState(() {
      totalKalori += kalori;
    });
    _saveConsumption(nama, kalori);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$nama ditambahkan! (+${kalori.toStringAsFixed(0)} kcal)',
        ),
        backgroundColor: _darkGreenPrimary, // Menggunakan warna baru
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveConsumption(String name, double calories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Simpan history per user dengan key 'consumption_history_EMAIL'
      final historyKey = 'consumption_history_$currentUserEmail';
      final histJson = prefs.getString(historyKey);
      List history = [];
      if (histJson != null) {
        try {
          history = jsonDecode(histJson);
        } catch (_) {
          history = [];
        }
      }

      final now = DateTime.now();
      final entry = {
        'date': now.toIso8601String(),
        'name': name,
        'calories': calories,
        'userEmail': currentUserEmail, // Tambahkan email user
      };
      history.add(entry);
      await prefs.setString(historyKey, jsonEncode(history));

      // Recompute today's total
      _loadTodaysTotalFromHistory();
    } catch (e) {
      print('Error saving consumption: $e');
    }
  }

  Future<void> _loadTodaysTotalFromHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyKey = 'consumption_history_$currentUserEmail';
      final histJson = prefs.getString(historyKey);
      double sum = 0;
      if (histJson != null) {
        final history = jsonDecode(histJson) as List;
        final today = DateTime.now();
        for (final e in history) {
          try {
            final dt = DateTime.parse(e['date']);
            if (dt.year == today.year && dt.month == today.month && dt.day == today.day) {
              sum += (e['calories'] is int) ? (e['calories'] as int).toDouble() : (e['calories'] as num).toDouble();
            }
          } catch (_) {}
        }
      }
      if (mounted) setState(() => totalKalori = sum);
    } catch (e) {
      print('Error loading today\'s total: $e');
    }
  }

  // Fungsi untuk memfilter daftar item
  List<Map<String, dynamic>> _filterItems(List<Map<String, dynamic>> items) {
    if (_searchText.isEmpty) {
      return items;
    }
    final query = _searchText.toLowerCase();
    return items.where((item) {
      final name = (item['name'] as String).toLowerCase();
      final desc = (item['desc'] as String).toLowerCase();
      // Filter berdasarkan nama atau deskripsi
      return name.contains(query) || desc.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.lightBg,
        appBar: AppBar(
          title: Text(
            'Menu & Kalori',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: _darkGreenPrimary, // Ganti warna
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const CalorieHistoryScreen()),
                ).then((_) => _loadTodaysTotalFromHistory());
              },
              icon: const Icon(Icons.history),
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white, // Ganti indikator agar terlihat lebih jelas di atas warna gelap
            indicatorWeight: 3,
            tabs: [
              Tab(
                child: Text(
                  'Makanan',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
              Tab(
                child: Text(
                  'Minuman',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _darkGreenPrimary, // Ganti warna latar belakang ikon
                          shape: BoxShape.circle,
                        ),
                        child: const Icon( // Ganti warna ikon menjadi putih
                          Icons.local_fire_department,
                          color: Colors.white, 
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Kalori Hari Ini',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${totalKalori.toStringAsFixed(0)} kcal',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: _darkGreenPrimary, // Ganti warna teks kalori
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Builder(builder: (context) {
                    final percent = (dailyTarget <= 0)
                        ? 0.0
                        : (totalKalori / dailyTarget).clamp(0, 1).toDouble();
                    final remaining = (dailyTarget - totalKalori).clamp(0, double.infinity);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Target: ${dailyTarget.toStringAsFixed(0)} kcal',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppTheme.textLight,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.edit, size: 18, color: AppTheme.textLight),
                                  onPressed: _showEditTargetDialog,
                                ),
                              ],
                            ),
                            Text(
                              '${(percent * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            minHeight: 12,
                            value: percent,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(_darkGreenPrimary), // Ganti warna progress bar
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Terkumpul: ${totalKalori.toStringAsFixed(0)} kcal',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textLight,
                              ),
                            ),
                            Text(
                              'Sisa: ${remaining.toStringAsFixed(0)} kcal',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            // --- Fitur Pencarian ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari menu...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchText = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
                style: GoogleFonts.inter(),
              ),
            ),
            // ----------------------------------------
            Expanded(
              child: TabBarView(
                children: [
                  _buildMenuList(_filterItems(foodItems)), // Menggunakan fungsi filter
                  _buildMenuList(_filterItems(drinkItems)), // Menggunakan fungsi filter
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(List<Map<String, dynamic>> items) {
    if (items.isEmpty && _searchText.isNotEmpty) {
      return Center(
        child: Text(
          'Tidak ada hasil untuk "$_searchText"',
          style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textLight),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailMenuScreen(
                  name: item['name'],
                  image: item['image'],
                  desc: item['desc'],
                  nutrition: item['nutrition'],
                  onAdd: () => tambahKalori(
                    item['nutrition']['kalori'].toDouble(),
                    item['name'],
                  ),
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shadowColor: Colors.black.withAlpha(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    item['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['desc'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              // Menggunakan background hijau tua
                              color: _darkGreenPrimary, 
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${item['nutrition']['kalori']} kcal",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                // MEMASTIKAN TEKS BERWARNA PUTIH agar kontras dengan background hijau tua
                                color: Colors.white, 
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => tambahKalori(
                            item['nutrition']['kalori'].toDouble(),
                            item['name'],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _darkGreenPrimary, // Ganti warna tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Tambah ke Daftar',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}