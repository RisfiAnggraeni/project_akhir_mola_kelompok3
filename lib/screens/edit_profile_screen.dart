import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = 'Cahya Nayla';
  String email = 'nailacahya580@gmail.com';
  String phone = '08988213616';
  String address = 'Bandar Lampung';
  String password = '1234';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.redAccent, // 🔴 biar seragam
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => name = value,
                validator: (value) =>
                    value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Email cannot be empty' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => phone = value,
                validator: (value) =>
                    value!.isEmpty ? 'Phone cannot be empty' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => address = value,
                validator: (value) =>
                    value!.isEmpty ? 'Address cannot be empty' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => password = value,
                validator: (value) =>
                    value!.isEmpty ? 'Password cannot be empty' : null,
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // 🔹 Kirim data balik ke ProfileScreen
                    Navigator.pop(context, {
                      'name': name,
                      'email': email,
                      'phone': phone,
                      'address': address,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
