import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';

class CalorieHistoryScreen extends StatefulWidget {
  const CalorieHistoryScreen({super.key});

  @override
  State<CalorieHistoryScreen> createState() => _CalorieHistoryScreenState();
}

class _CalorieHistoryScreenState extends State<CalorieHistoryScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> history = [];
  late TabController _tabController;
  String currentUserEmail = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCurrentUserAndHistory();
  }

  Future<void> _loadCurrentUserAndHistory() async {
    setState(() {
      isLoading = true;
    });
    
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_user_email') ?? '';
    
    setState(() {
      currentUserEmail = email;
    });
    
    await _loadHistory();
    
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyKey = 'consumption_history_$currentUserEmail';
    final histJson = prefs.getString(historyKey);
    
    if (histJson != null) {
      try {
        final raw = jsonDecode(histJson) as List;
        setState(() {
          history = raw
              .map((e) => {
                    'date': DateTime.parse(e['date']),
                    'name': e['name'],
                    'calories': (e['calories'] is int) 
                        ? (e['calories'] as int).toDouble() 
                        : (e['calories'] as num).toDouble(),
                    'userEmail': e['userEmail'] ?? currentUserEmail,
                  })
              .toList();
        });
      } catch (e) {
        print('Error loading history: $e');
        setState(() => history = []);
      }
    } else {
      setState(() => history = []);
    }
  }

  List<Map<String, dynamic>> _filterToday() {
    final today = DateTime.now();
    return history.where((e) {
      final d = e['date'] as DateTime;
      return d.year == today.year && d.month == today.month && d.day == today.day;
    }).toList();
  }

  List<Map<String, dynamic>> _filterYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return history.where((e) {
      final d = e['date'] as DateTime;
      return d.year == yesterday.year && d.month == yesterday.month && d.day == yesterday.day;
    }).toList();
  }

  List<Map<String, dynamic>> _filterThisWeek() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));
    return history.where((e) {
      final d = e['date'] as DateTime;
      return d.isAfter(weekAgo.subtract(const Duration(seconds: 1))) && 
             d.isBefore(now.add(const Duration(days: 1)));
    }).toList();
  }

  List<Map<String, dynamic>> _filterThisMonth() {
    final now = DateTime.now();
    return history.where((e) {
      final d = e['date'] as DateTime;
      return d.year == now.year && d.month == now.month;
    }).toList();
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppTheme.textLight.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada riwayat',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai tambahkan menu untuk\nmelihat riwayat kalori Anda',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textLight.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    // Sort descending by date
    items.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    
    // Group by date
    Map<String, List<Map<String, dynamic>>> groupedByDate = {};
    for (var item in items) {
      final dt = item['date'] as DateTime;
      final dateKey = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      if (!groupedByDate.containsKey(dateKey)) {
        groupedByDate[dateKey] = [];
      }
      groupedByDate[dateKey]!.add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedByDate.length,
      itemBuilder: (context, index) {
        final dateKey = groupedByDate.keys.elementAt(index);
        final itemsForDate = groupedByDate[dateKey]!;
        final firstDate = itemsForDate.first['date'] as DateTime;
        
        // Calculate total calories for this date
        double totalCaloriesForDate = itemsForDate.fold(
          0, 
          (sum, item) => sum + (item['calories'] as double)
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shadowColor: Colors.black.withAlpha(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(firstDate),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${totalCaloriesForDate.toStringAsFixed(0)} kcal',
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
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 12),
                ...itemsForDate.map((item) {
                  final dt = item['date'] as DateTime;
                  final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.restaurant,
                            size: 20,
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Text(
                                time,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${(item['calories'] as double).toStringAsFixed(0)} kcal',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Hari Ini';
    } else if (dateToCheck == yesterday) {
      return 'Kemarin';
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Semua Riwayat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'Apakah Anda yakin ingin menghapus semua riwayat? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: GoogleFonts.inter()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Hapus',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      final historyKey = 'consumption_history_$currentUserEmail';
      await prefs.remove(historyKey);
      
      if (mounted) {
        setState(() {
          history = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Riwayat berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Kalori', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearHistory,
              tooltip: 'Hapus Semua',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.accentColor,
          indicatorWeight: 3,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Hari ini'),
            Tab(text: 'Kemarin'),
            Tab(text: 'Minggu ini'),
            Tab(text: 'Bulan ini'),
          ],
        ),
      ),
      backgroundColor: AppTheme.lightBg,
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            onRefresh: _loadHistory,
            child: _buildList(_filterToday()),
          ),
          RefreshIndicator(
            onRefresh: _loadHistory,
            child: _buildList(_filterYesterday()),
          ),
          RefreshIndicator(
            onRefresh: _loadHistory,
            child: _buildList(_filterThisWeek()),
          ),
          RefreshIndicator(
            onRefresh: _loadHistory,
            child: _buildList(_filterThisMonth()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}