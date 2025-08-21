import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:clinic_booking_app/pages/Landing_page.dart';
// import 'package:clinic_booking_app/pages/Login_page.dart';
import 'package:clinic_booking_app/providers/auth_providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  io.File? _profileImage;
  Uint8List? _webImage;

  bool _isEditing = false;
  String _fullName = "John Doe";
  String _email = "";
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // Load image
    if (kIsWeb) {
      final base64Image = prefs.getString('profile_image_web');
      if (base64Image != null) {
        _webImage = base64Decode(base64Image);
      }
    } else {
      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null && io.File(imagePath).existsSync()) {
        _profileImage = io.File(imagePath);
      }
    }

    // Load name & email
    _fullName = prefs.getString('profile_name') ?? "John Doe";
    _email =
        prefs.getString('profile_email') ??
        context.read<AuthProvider>().email ??
        "";

    _nameController.text = _fullName;
    _emailController.text = _email;

    setState(() {});
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        _webImage = bytes;
        await prefs.setString('profile_image_web', base64Encode(bytes));
      } else {
        final file = io.File(pickedFile.path);
        _profileImage = file;
        await prefs.setString('profile_image_path', pickedFile.path);
      }
      setState(() {});
    }
  }

  Future<void> _updateProfile() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your name")));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_email', email);

    setState(() {
      _fullName = name;
      _email = email;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: authProvider.email == null
          ? const Center(child: Text("No patient logged in"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _webImage != null
                              ? MemoryImage(_webImage!)
                              : _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage("assets/img2.jpg")
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _isEditing
                              ? TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.teal,
                                    ),
                                  ),
                                )
                              : ListTile(
                                  leading: const Icon(
                                    Icons.email,
                                    color: Colors.teal,
                                  ),
                                  title: Text(
                                    "Email",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _email,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                          const Divider(),
                          _isEditing
                              ? TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: "Full Name",
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.teal,
                                    ),
                                  ),
                                )
                              : ListTile(
                                  leading: const Icon(
                                    Icons.person,
                                    color: Colors.teal,
                                  ),
                                  title: Text(
                                    "Full Name",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _fullName,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_isEditing)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _updateProfile,
                      child: Text(
                        "Update",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('profile_image_path');
                      await prefs.remove('profile_image_web');
                      await prefs.remove('profile_name');
                      await prefs.remove('profile_email');

                      authProvider.logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LandingPage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      "Logout",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
