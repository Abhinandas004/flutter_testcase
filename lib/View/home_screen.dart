import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Model/user_model.dart';
import '../ViewModel/user_view_model.dart';
import 'Widgets/add_user_dialog.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.watch<UserViewModel>().users;

    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      // Floating Action Button
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.black,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddUserDialog();
              },
            );
          },
          child: Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text(
              "Nilambur",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar & filter
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Color(0xff484848)),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search by name",
                              hintStyle: GoogleFonts.montserrat(
                                color: Color(0xff919191),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // filter button
                InkWell(
                  onTap: () {
                    _showSortBottomSheet(context);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.filter_list, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Users Lists",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // User list
          Expanded(
            child: users.isEmpty
                ? Center(
              child: Text(
                "No users added yet.",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            )
                :
            ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  color: Colors.white,
                  elevation: 1,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: user.imagePath != null
                              ? FileImage(File(user.imagePath!))
                              : null,
                          child: user.imagePath == null
                              ? Icon(Icons.person)
                              : null,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Age: ${user.age}",
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
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
}

void _showSortBottomSheet(BuildContext context) {
  String selectedSort = 'All';

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(24, 30, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sort",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 15),
                _buildSortOption("All", selectedSort, (val) {
                  setModalState(() => selectedSort = val!);
                }),
                _buildSortOption("Age: Elder", selectedSort, (val) {
                  setModalState(() => selectedSort = val!);
                }),
                _buildSortOption("Age: Younger", selectedSort, (val) {
                  setModalState(() => selectedSort = val!);
                }),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildSortOption(
    String title,
    String currentGroup,
    ValueChanged<String?> onChanged,
    ) {
  bool isSelected = title == currentGroup;

  return InkWell(
    onTap: () => onChanged(title),
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.grey.shade300),
            child: Transform.scale(
              scale: 1.3,
              child: Radio<String>(
                value: title,
                groupValue: currentGroup,
                activeColor: Color(0xFF2196F3),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}