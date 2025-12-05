import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/theme.dart';

class AdminManageMenuScreen extends StatefulWidget {
  const AdminManageMenuScreen({super.key});

  @override
  State<AdminManageMenuScreen> createState() => _AdminManageMenuScreenState();
}

class _AdminManageMenuScreenState extends State<AdminManageMenuScreen> {
  String _selectedCategory = 'makanan';

  // 🔹 Semua Makanan
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
      'name': 'Jus Strawberry',
      'image': 'assets/images/jus_strawberry.jpeg',
      'desc': 'Jus strawberry alami tanpa pemanis buatan.',
      'nutrition': {'kalori': 120, 'protein': 1, 'lemak': 0, 'karbohidrat': 30},
    },
    {
      'name': 'Smoothie Pisang',
      'image': 'assets/images/smoothie_pisang.jpeg',
      'desc': 'Smoothie pisang dengan yogurt dan madu alami.',
      'nutrition': {'kalori': 180, 'protein': 4, 'lemak': 2, 'karbohidrat': 38},
    },
  ];

  void _addMenu() {
    showDialog(
      context: context,
      builder: (context) => AddMenuDialog(category: _selectedCategory),
    );
  }

  void _editMenu(int index) {
    final item = _selectedCategory == 'makanan'
        ? foodItems[index]
        : drinkItems[index];
    showDialog(
      context: context,
      builder: (context) => EditMenuDialog(
        item: item,
        category: _selectedCategory,
      ),
    );
  }

  void _deleteMenu(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus menu ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (_selectedCategory == 'makanan') {
                  foodItems.removeAt(index);
                } else {
                  drinkItems.removeAt(index);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
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
      body: Column(
        children: [
          // Category Tabs
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = 'makanan'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedCategory == 'makanan'
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedCategory == 'makanan'
                              ? AppTheme.primaryColor
                              : AppTheme.textLight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Makanan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedCategory == 'makanan'
                                ? Colors.white
                                : AppTheme.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = 'minuman'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedCategory == 'minuman'
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedCategory == 'minuman'
                              ? AppTheme.primaryColor
                              : AppTheme.textLight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Minuman',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedCategory == 'minuman'
                                ? Colors.white
                                : AppTheme.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Menu List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _selectedCategory == 'makanan'
                  ? foodItems.length
                  : drinkItems.length,
              itemBuilder: (context, index) {
                final item = _selectedCategory == 'makanan'
                    ? foodItems[index]
                    : drinkItems[index];
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
                        // Foto Menu
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item['image'] ?? 'assets/images/pizza.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.restaurant_menu,
                                  size: 60,
                                  color: Colors.grey[400],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Nama Menu
                        Text(
                          item['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Deskripsi Menu
                        Text(
                          item['desc'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Kalori Menu
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${item['nutrition']['kalori']} Kalori',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Nutrisi: Protein / Karbo / Lemak
                        Row(
                          children: [
                            Expanded(
                              child: _buildNutrientCard(
                                'Protein',
                                '${item['nutrition']['protein']}g',
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildNutrientCard(
                                'Karbo',
                                '${item['nutrition']['karbohidrat']}g',
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildNutrientCard(
                                'Lemak',
                                '${item['nutrition']['lemak']}g',
                                Colors.red,
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
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class AddMenuDialog extends StatefulWidget {
  final String category;

  const AddMenuDialog({super.key, required this.category});

  @override
  State<AddMenuDialog> createState() => _AddMenuDialogState();
}

class _AddMenuDialogState extends State<AddMenuDialog> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Tambah ${widget.category == 'makanan' ? 'Makanan' : 'Minuman'}',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _imageFile == null
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Kalori'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: proteinController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Protein (g)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: carbsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Karbo (g)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: fatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Lemak (g)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Simpan',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.dispose();
  }
}

class EditMenuDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  final String category;

  const EditMenuDialog({super.key, required this.item, required this.category});

  @override
  State<EditMenuDialog> createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends State<EditMenuDialog> {
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController caloriesController;
  late TextEditingController proteinController;
  late TextEditingController carbsController;
  late TextEditingController fatController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item['name']);
    descController = TextEditingController(text: widget.item['desc']);
    caloriesController = TextEditingController(
      text: widget.item['nutrition']['kalori'].toString(),
    );
    proteinController = TextEditingController(
      text: widget.item['nutrition']['protein'].toString(),
    );
    carbsController = TextEditingController(
      text: widget.item['nutrition']['karbohidrat'].toString(),
    );
    fatController = TextEditingController(
      text: widget.item['nutrition']['lemak'].toString(),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit ${widget.category == 'makanan' ? 'Makanan' : 'Minuman'}',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _imageFile == null
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Kalori'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: proteinController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Protein (g)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: carbsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Karbo (g)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: fatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Lemak (g)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Simpan',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.dispose();
  }
}
