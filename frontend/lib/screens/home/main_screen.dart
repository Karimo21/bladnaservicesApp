
import 'package:bladnaservices/screens/home/map/map_screen.dart';
import 'package:bladnaservices/screens/home/profile/profil_screen.dart';
import 'package:bladnaservices/screens/home/reservation/reservation_screen.dart';
import 'package:bladnaservices/screens/home/services/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:bladnaservices/screens/home/chat/chat_list_screen.dart';
import 'package:bladnaservices/widgets/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  static final GlobalKey<_MainScreenState> mainScreenKey = GlobalKey<_MainScreenState>();
  final int initialIndex;
  const MainScreen({super.key,this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Utilisation de l'index initial
  }


  // A list of widgets representing each page/screen.
  final List<Widget> _screens = [
    Homescreen(), // Tab 1: Acceuil
    MoroccoMap(), // Tab 2: Explorer
    ReservationsPage(),   // Tab 3: Suivi
    ChatListScreen(),   // Tab 4: Message  
    ProfileScreen(), // Tab 5: Profil
 
  ];

  // This function is called when a tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
    void updateIndex(int index) {
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
