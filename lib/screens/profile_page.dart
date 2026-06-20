import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'register_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isUploading = false;
  final User? user = FirebaseAuth.instance.currentUser;

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => const RegisterPage()), (route) => false);
  }

  Future<void> updateProfilePicture() async {
    if (user == null) return;
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        imageQuality: 50,
      );
      
      if (image != null) {
        setState(() => isUploading = true);
        
        Uint8List data = await image.readAsBytes();
        String base64Image = "data:image/jpeg;base64,${base64Encode(data)}";
        
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'foto': base64Image});
            
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupload foto: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
      }
    }
  }

  ImageProvider _getProfileImage(String? foto) {
    if (foto == null || foto.isEmpty) {
      return const NetworkImage('https://via.placeholder.com/150');
    }
    if (foto.startsWith('http')) {
      return NetworkImage(foto);
    }
    final String base64String = foto.contains(',') ? foto.split(',').last : foto;
    return MemoryImage(base64Decode(base64String));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: isUploading ? null : updateProfilePicture,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _getProfileImage(data?['foto']),
                        child: data?['foto'] == null || data!['foto'].isEmpty
                            ? const Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                      if (isUploading)
                        const CircularProgressIndicator(color: Colors.white),
                      if (!isUploading)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Nama: ${data?['nama']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Email: ${data?['email']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Instagram: ${data?['instagram']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => logout(context),
                  child: const Text('Log Out'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}