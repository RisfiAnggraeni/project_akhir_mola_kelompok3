import 'package:flutter/material.dart';
import 'detail_menu_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  double totalKalori = 0;

  // 🔹 Semua Makanan
  final List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Pizza',
      'image': 'assets/images/pizza.jpg',
      'desc': 'Pizza lezat dengan keju melimpah dan topping premium.',
      'nutrition': {'kalori': 285, 'protein': 12, 'lemak': 10, 'karbohidrat': 36},
    },
    {
      'name': 'Burger',
      'image': 'assets/images/burger.jpg',
      'desc': 'Burger daging sapi juicy dengan saus spesial rumah.',
      'nutrition': {'kalori': 354, 'protein': 17, 'lemak': 20, 'karbohidrat': 29},
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
      'nutrition': {'kalori': 300, 'protein': 25, 'lemak': 10, 'karbohidrat': 15},
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
      'nutrition': {'kalori': 310, 'protein': 11, 'lemak': 6, 'karbohidrat': 50},
    },
  ];

  // 🔹 Semua Minuman
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
      'nutrition': {'kalori': 180, 'protein': 3, 'lemak': 12, 'karbohidrat': 15},
    },
    {
      'name': 'Matcha Latte',
      'image': 'assets/images/matcha_latte.jpeg',
      'desc': 'Minuman hijau segar dengan aroma matcha yang menenangkan.',
      'nutrition': {'kalori': 160, 'protein': 5, 'lemak': 4, 'karbohidrat': 20},
    },
  ];

  void tambahKalori(double kalori, String nama) {
    setState(() {
      totalKalori += kalori;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nama ditambahkan! (+${kalori.toStringAsFixed(0)} kcal)'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu & Kalori'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Makanan'),
              Tab(text: 'Minuman'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.redAccent.withOpacity(0.1),
              padding: const EdgeInsets.all(16),
              child: Text(
                'Total Kalori Hari Ini: ${totalKalori.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMenuList(foodItems),
                  _buildMenuList(drinkItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
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
                  onAdd: () => tambahKalori(item['nutrition']['kalori'].toDouble(), item['name']),
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item['desc'], style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Text("Kalori: ${item['nutrition']['kalori']} kcal"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => tambahKalori(item['nutrition']['kalori'].toDouble(), item['name']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Tambah ke Daftar Hari Ini'),
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
