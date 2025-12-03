import 'package:flutter/material.dart';

class DetailMenuScreen extends StatelessWidget {
  final String name;
  final String image;
  final String desc;
  final Map<String, dynamic> nutrition;
  final VoidCallback onAdd;

  const DetailMenuScreen({
    super.key,
    required this.name,
    required this.image,
    required this.desc,
    required this.nutrition,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 50)),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(desc, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 25),
            const Text('Info Nutrisi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            _buildNutritionRow('Kalori', '${nutrition["kalori"]} kkal'),
            _buildNutritionRow('Protein', '${nutrition["protein"]} g'),
            _buildNutritionRow('Lemak', '${nutrition["lemak"]} g'),
            _buildNutritionRow('Karbohidrat', '${nutrition["karbohidrat"]} g'),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  onAdd();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah ke Daftar Hari Ini'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
