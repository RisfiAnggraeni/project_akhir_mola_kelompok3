import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../utils/theme.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late String name;
  late String email;
  late String phone;
  late String address;
  String password = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    phone = widget.phone;
    address = widget.address;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(26),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: _profileImage != null
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(_profileImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pilih Foto',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildFieldLabel('Nama Lengkap'),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: const Icon(Icons.person_outline),
                  prefixIconColor: AppTheme.textLight,
                ),
                onChanged: (value) => name = value,
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Email'),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(
                  hintText: 'nama@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  prefixIconColor: AppTheme.textLight,
                ),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Nomor Telepon'),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: phone,
                decoration: InputDecoration(
                  hintText: '08xxxxxxxxxx',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  prefixIconColor: AppTheme.textLight,
                ),
                onChanged: (value) => phone = value,
                validator: (value) =>
                    value!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Alamat'),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: address,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  prefixIconColor: AppTheme.textLight,
                ),
                onChanged: (value) => address = value,
                validator: (value) =>
                    value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Password'),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Masukkan password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  prefixIconColor: AppTheme.textLight,
                ),
                onChanged: (value) => password = value,
                validator: (value) =>
                    value!.isEmpty ? 'Password tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String? profileImageBase64;
                    if (_profileImage != null) {
                      final bytes = _profileImage!.readAsBytesSync();
                      profileImageBase64 = base64Encode(bytes);
                    }
                    Navigator.pop(context, {
                      'name': name,
                      'email': email,
                      'phone': phone,
                      'address': address,
                      'profileImage': profileImageBase64,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Profil berhasil diperbarui!',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(
                  'Simpan Perubahan',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textDark,
      ),
    );
  }
}
