import 'package:bladnaservices/screens/home/notification/notification_screen.dart';
import 'package:bladnaservices/screens/home/profile/addImage_screen.dart';
import 'package:bladnaservices/screens/home/profile/editProfil_screen.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0054A5);
const Color backgroundColor = Color(0xFFF9F9F9);

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
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage("http://localhost:3000"+User.profile),
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
                      ), //
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25),
              Text('Informations du profil',
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              SizedBox(height: 8),
              ProfileOption(
                icon: Icons.person_outline,
                title: 'Éditer le profil',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.image_outlined,
                title: 'Ajouter des images',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageUploadPage()),
                  );
                },
              ),
              SizedBox(height: 11),
              Text('Préférences générales',
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              SizedBox(height: 8),
              ProfileOption(
                icon: Icons.notifications_outlined,
                title: 'Notification',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  ); // Navigate to Notification Page (Create one if needed)
                },
              ),
              ProfileOption(
                icon: Icons.logout,
                title: 'Déconnexion',
                isLast: true,
                showArrow: false,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Arrondir les coins
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              'https://cdn-icons-png.flaticon.com/512/1828/1828479.png', // Image de déconnexion
                              width: 60,
                              height: 60,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Déconnexion",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF565656),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Are you sure to logout?",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 86, 86, 86)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Fermer la boîte de dialogue
                                    // Logique de déconnexion ici
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    minimumSize: Size(double.infinity, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Déconnexion",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Fermer la boîte de dialogue
                                  },
                                  child: Text(
                                    "Annuler",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
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
  final Function()? onTap;

  ProfileOption({
    required this.icon,
    required this.title,
    this.isLast = false,
    this.showArrow = true,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle navigation dynamically
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 4),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                child: Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 19),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final String? errorText;

  ProfileTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class ProfileDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final Function(String?) onChanged;

  ProfileDropdown(
      {required this.label, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            onChanged: onChanged,
            hint: Text("Sélectionner une ville"),
            underline: SizedBox(),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
