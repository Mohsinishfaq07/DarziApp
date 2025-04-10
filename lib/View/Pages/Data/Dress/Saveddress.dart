import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/Utils/Provider/DressProvider.dart';
import 'package:tailor_app/View/Pages/Data/Dress/DressDetail.dart';
import 'package:tailor_app/View/Pages/Data/Dress/NewDress.dart';
import 'package:tailor_app/Widgets/Appbar/Customappbar.dart';
import 'package:tailor_app/Widgets/Genderwidget/GenderWidget.dart';
import 'package:tailor_app/Widgets/Progressbar/progressbar.dart';
import 'package:tailor_app/Widgets/SavedDressWidgets/DressTile.dart';
import 'package:tailor_app/Widgets/Searchbar/Searchbar.dart'; // ✅ Import SearchBarWidget

class SavedDress extends ConsumerStatefulWidget {
  const SavedDress({super.key});

  @override
  ConsumerState<SavedDress> createState() => _SavedDressState();
}

class _SavedDressState extends ConsumerState<SavedDress> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  void _onSearchChanged(String value) {
    setState(() => searchText = value.toLowerCase());
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => searchText = '');
  }

  @override
  Widget build(BuildContext context) {
    final dressList = ref.watch(dressProvider);

    return Scaffold(
      appBar: CustomAppbar("Saved Dresses"),
      body: dressList.when(
        data: (dresses) {
          // ✅ Filter dresses
          final filtered =
              dresses.where((dress) {
                final name = dress.name.toLowerCase();
                final number = dress.number.toLowerCase();
                return name.contains(searchText) || number.contains(searchText);
              }).toList();

          return Column(
            children: [
              SearchBarWidget(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onClear: _clearSearch,
                showClear: searchText.isNotEmpty,
              ),
              CustomButton2(() {
                FocusScope.of(context).unfocus();
                Get.to(const NewDress());
              }, "Add New Dress"),
              Expanded(
                child:
                    filtered.isEmpty
                        ? const EmptyStateText("No matching dresses found")
                        : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final dress = filtered[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color:
                                  dress.isCompleted
                                      ? Colors.grey.shade50
                                      : Colors.white,
                              child: ListTile(
                                onTap: () => Get.to(DressDetail(dress: dress)),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                leading: DressAvatar(dress: dress),
                                title: DressTitle(dress: dress),
                                subtitle: DressSubtitle(dress: dress),
                                trailing: DressTrailing(
                                  dress: dress,
                                  index: index,
                                  ref: ref,
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
        loading: () => const Center(child: Circleloading()),
        error:
            (error, stack) => Center(
              child: Text(
                "Error loading dresses",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 50, right: 5),
      //   child: FloatingActionButton(
      //     onPressed: () => Get.to(const NewDress()),
      //     child: const Icon(Icons.add, color: Colors.orange),
      //   ),
      // ),
    );
  }
}
