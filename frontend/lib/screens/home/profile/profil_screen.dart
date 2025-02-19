import 'package:bladnaservices/screens/home/profile/editProfil_screen.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0054A5);
const Color backgroundColor = Color(0xFFF9F9F9);

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Désactive le debug banner
    home: ProfileScreen(), // Page d'accueil
  ));
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text(
                'Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'),
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hassan Rochdi',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      Text('Médecin',
                          style: TextStyle(color: Colors.grey, fontSize: 18)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.star, color: primaryColor, size: 18),
                          Text(' 4.8',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.emoji_events,
                              color: primaryColor, size: 18),
                          Text(' 320 réservations',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25),
              Text('Informations du profil',
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen()),
                  );
                },
                child: ProfileOption(
                    icon: Icons.person_outline, title: 'Éditer le profil'),
              ),
              ProfileOption(
                  icon: Icons.image_outlined, title: 'Ajouter des images'),
              SizedBox(height: 11),
              Text('Préférences générales',
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              SizedBox(height: 8),
              ProfileOption(
                  icon: Icons.notifications_outlined, title: 'Notification'),
              ProfileOption(
                  icon: Icons.logout, title: 'Déconnexion', isLast: true, showArrow: false),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLast;
  final bool showArrow;

  ProfileOption({required this.icon, required this.title, this.isLast = false, this.showArrow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 4), // Ensure no bottom margin for the last item
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8), // Increased padding for consistency
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 28),
              SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 18)),
            ],
          ),
          if (showArrow)
            Container(
              width: 44,
              height: 44,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 19),
            ),
        ],
      ),
    );
  }
}
