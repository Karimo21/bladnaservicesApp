import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Color(0xFF0054A5), // Active icon color
      unselectedItemColor: Color(0xFF565656), // Inactive icon color
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed, // To keep all labels visible
      items:  [
        BottomNavigationBarItem(
          icon: _buildSvgIcon("assets/icons/acceuil.svg", 0),
          label: "Acceuil",
        ),
        BottomNavigationBarItem(
          icon: _buildSvgIcon("assets/icons/explorer.svg", 1),
          label: "Explorer",
        ),
        BottomNavigationBarItem(
          icon: _buildSvgIcon("assets/icons/suivi.svg", 2),
          label: "Suivi",
        ),
        BottomNavigationBarItem(
          icon: _buildSvgIcon("assets/icons/discussions.svg", 3),
          label: "Messages",
        ),
        BottomNavigationBarItem(
          icon: _buildSvgIcon("assets/icons/profil.svg", 4),
          label: "Profil",
        ),

      ],
    );
  }
  Widget _buildSvgIcon(String assetName, int index) {
    return SvgPicture.asset(
      assetName,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        selectedIndex == index ? Color(0xFF0054A5) : Color(0xFFD4D6DD),
        BlendMode.srcIn,
      ),
    );
}
}
