import 'package:bladnaservices/screens/home/map/explorer_screen.dart';
import 'package:bladnaservices/screens/home/profile/profil_screen.dart';
import 'package:bladnaservices/screens/home/reservation/suivi_screen.dart';
import 'package:bladnaservices/screens/home/services/acceuil_screen.dart';
import 'package:flutter/material.dart';
import 'package:bladnaservices/screens/home/chat/chat_list_screen.dart';
import 'package:bladnaservices/widgets/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // A list of widgets representing each page/screen.
  final List<Widget> _screens = [
    AcceuilScreen(), // Tab 1: Acceuil
    ExplorerScreen(), // Tab 2: Explorer
    SuiviScreen(),   // Tab 3: Suivi
    ChatListScreen(),   // Tab 4: Message  
    ProfileScreen(), // Tab 5: Profil
 
  ];

  // This function is called when a tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body shows the currently selected screen.
      body: _screens[_selectedIndex],
      // The BottomNavigationBar is your custom widget.
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
