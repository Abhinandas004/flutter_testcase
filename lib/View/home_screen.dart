import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../ViewModel/user_view_model.dart';
import 'Widgets/add_user_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {

        context.read<UserViewModel>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();
    final users = vm.users;

    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),

      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.black,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddUserDialog(),
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white, size: 22),
            const SizedBox(width: 6),
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

          // SEARCH + FILTER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.grey.shade400, width: 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: Color(0xff484848)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              context
                                  .read<UserViewModel>()
                                  .setSearchQuery(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search by name",
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

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
                    child: const Icon(Icons.filter_list,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.only(left: 16, bottom: 10),
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

          // LIST
          Expanded(
            child: users.isEmpty
                ? Center(
              child: Text(
                "No users.",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              itemCount:
              users.length + (vm.isLoading ? 1 : 0),
              itemBuilder: (context, index) {

                if (index == users.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final user = users[index];

                return Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                  const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                          user.imagePath != null
                              ? FileImage(
                              File(user.imagePath!))
                              : null,
                          child: user.imagePath ==
                              null
                              ? const Icon(
                              Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style:
                              GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Age: ${user.age}",
                              style:
                              GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w500,
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

// Sort bottom sheet
void _showSortBottomSheet(BuildContext parentContext) {
  showModalBottomSheet(
    context: parentContext,
    backgroundColor: Colors.white,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
    ),
    builder: (context) {
      return Consumer<UserViewModel>(
        builder: (context, vm, _) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
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
                const SizedBox(height: 15),

                _buildSortOption("All", vm.selectedSort, (val) {
                  vm.setSort(val!);
                  Navigator.pop(context);
                }),

                _buildSortOption("Age: Elder", vm.selectedSort, (val) {
                  vm.setSort(val!);
                  Navigator.pop(context);
                }),

                _buildSortOption("Age: Younger", vm.selectedSort, (val) {
                  vm.setSort(val!);
                  Navigator.pop(context);
                }),
              ],
            ),
          );
        },
      );
    },
  );
}

// Sort option widget
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
