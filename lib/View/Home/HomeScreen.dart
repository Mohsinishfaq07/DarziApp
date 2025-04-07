import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/View/Pages/Data/Dress/Saveddress.dart';
import 'package:tailor_app/View/Pages/Data/NewEntry/NewEntryPage.dart';
import 'package:tailor_app/View/Pages/Data/SavedMeasures/SavedScreen.dart';
import 'package:tailor_app/View/Pages/ProfilePage/Profilepage.dart';
import 'package:tailor_app/Widgets/BannerAd/BannerAdWidget.dart';
import 'package:tailor_app/Widgets/ExitDialoge/ExitDialoge.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int _currentIndex = 0; // Tracks the selected tab index
  final PageController _pageController =
      PageController(); // Controls page switching

  @override
  Widget build(BuildContext context) {
    return ExitDialog(
      child: Scaffold(
        backgroundColor: Colors.blue.shade200,

        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                FocusScope.of(context).unfocus();
              },
              children: [
                // New Entry Page
                NewEntryPage(),
                // Saved Screen Page
                SavedScreen(),
                // Dresses Page
                SavedDress(),
                ProfileScreen(),
              ],
            ),

            // Banner Ad Positioned at the bottom of the screen
            Positioned(bottom: 0, left: 0, right: 0, child: BannerAdWidget()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex, // Tracks selected tab
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index); // Switch pages on tab click
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'New Entry',
              backgroundColor: Colors.blue, // Active tab background color
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              label: 'Saved',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/tshirt.png")),
              label: 'Dresses',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile', // Profile tab
            ),
          ],
          selectedItemColor: Colors.white, // Active item color
          unselectedItemColor: Colors.grey, // Inactive item color
          backgroundColor: Colors.blue, // Bottom navigation bar background
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

final pageIndexProvider = StateProvider<int>((ref) => 0);
