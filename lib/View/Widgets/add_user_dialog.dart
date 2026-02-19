import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Model/user_model.dart';
import '../../ViewModel/user_view_model.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedImagePath;

  // Image picker
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image =
      await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          selectedImagePath = image.path;
        });
      }
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add A New User",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),

                // Image Picker
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF42A5F5),
                            Color(0xFF1976D2)
                          ],
                        ),
                      ),
                      child: ClipOval(
                        child: selectedImagePath != null
                            ? Image.file(
                          File(selectedImagePath!),
                          fit: BoxFit.cover,
                        )
                            : Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.person,
                                size: 65,
                                color: Colors.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                color: Colors.black.withOpacity(0.3),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Name",
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name cannot be empty";
                    }
                    if (value.trim().length < 2) {
                      return "Name must contain at least 2 characters";
                    }
                    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                    if (!nameRegex.hasMatch(value.trim())) {
                      return "Name should contain only letters";
                    }
                    return null;
                  },

                  decoration: InputDecoration(
                    hintText: "Enter name",
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFD1D1D1), width: 1.2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFD1D1D1), width: 1.2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Age",
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Age cannot be empty";
                    }
                    final age = int.tryParse(value.trim());
                    if (age == null) {
                      return "Age must be a number";
                    }
                    if (age <= 0 || age > 110) {
                      return "Please enter a valid age";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter age",
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFD1D1D1), width: 1.2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Color(0xFFD1D1D1), width: 1.2),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE0E0E0),
                        foregroundColor: Colors.grey[700],
                        elevation: 0,
                        minimumSize: Size(110, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        int age =
                        int.parse(ageController.text.trim());
                        context
                            .read<UserViewModel>()
                            .addUser(
                          UserModel(
                            name: nameController.text.trim(),
                            age: age,
                            imagePath: selectedImagePath,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: Size(110, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
