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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final histJson = prefs.getString('consumption_history');
    if (histJson != null) {
      try {
        final raw = jsonDecode(histJson) as List;
        setState(() {
          history = raw
              .map((e) => {
                    'date': DateTime.parse(e['date']),
                    'name': e['name'],
                    'calories': (e['calories'] is int) ? (e['calories'] as int).toDouble() : (e['calories'] as num).toDouble(),
                  })
              .toList();
        });
      } catch (_) {
        setState(() => history = []);
      }
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
    final weekAgo = now.subtract(const Duration(days: 6)); // last 7 days including today
    return history.where((e) {
      final d = e['date'] as DateTime;
      return d.isAfter(weekAgo.subtract(const Duration(seconds: 1))) && d.isBefore(now.add(const Duration(days: 1)));
    }).toList();
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Text('Tidak ada catatan', style: GoogleFonts.inter(color: AppTheme.textLight)),
      );
    }
    // sort descending by date
    items.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final e = items[index];
        final dt = e['date'] as DateTime;
        final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(e['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            subtitle: Text(time, style: GoogleFonts.inter()),
            trailing: Text('${(e['calories'] as double).toStringAsFixed(0)} kcal', style: GoogleFonts.poppins(color: AppTheme.accentColor, fontWeight: FontWeight.w700)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Kalori', style: GoogleFonts.poppins()),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Hari ini'), Tab(text: 'Kemarin'), Tab(text: 'Minggu ini')],
        ),
      ),
      backgroundColor: AppTheme.lightBg,
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(onRefresh: _loadHistory, child: _buildList(_filterToday())),
          RefreshIndicator(onRefresh: _loadHistory, child: _buildList(_filterYesterday())),
          RefreshIndicator(onRefresh: _loadHistory, child: _buildList(_filterThisWeek())),
        ],
      ),
    );
  }
}
