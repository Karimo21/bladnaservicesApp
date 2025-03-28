import 'package:bladnaservices/screens/auth/login_screen.dart';
import 'package:bladnaservices/screens/home/profile/addImage_screen.dart';
import 'package:bladnaservices/screens/home/profile/editProfil_screen.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color primaryColor = Color(0xFF0054A5);
const Color backgroundColor = Color(0xFFF9F9F9);

class ProfileScreen extends StatelessWidget {

 // Function to update the availability of the provider
Future<void> updateProviderAvailability(int providerId, int value) async {
  final url = Uri.parse('http://localhost:3000/update-provider-availiblity'); // Your API URL

  // Create the data to be sent in the body of the request
  final data = {
    'providerId': providerId,
    'value': value,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Provider availability updated successfully');
      User.availability=value;
    } else {
      print('Failed to update provider availability');
    }
  } catch (e) {
    print('Error: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 15), 
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage("http://localhost:3000${User.profile}"),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${User.fname} ${User.lname}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                      if(User.role=="provider")
                      Text(User.service,
                          style: const TextStyle(color: Colors.grey, fontSize: 18)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if(User.role=="provider")
                          const Icon(Icons.star, color: primaryColor, size: 18),
                          if(User.role=="provider")
                          Text(User.rate,
                              style:
                                  const TextStyle(color: primaryColor, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      if(User.role=="provider")
                      Row(
                        children: [
                          const Icon(Icons.emoji_events,
                              color: primaryColor, size: 18),
                          Text("Total des réservations: ${User.totalreservations.toString()}",
                              style:
                                  const TextStyle(color: primaryColor, fontSize: 18)),
                        ],
                      ), //
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text('Informations du profil',
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              const SizedBox(height: 8),
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
              if(User.role=="provider")
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
              const SizedBox(height: 11),
              const Text('Préférences générales',
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
              const SizedBox(height: 8),
              if(User.role=="provider")
              ProfileOption(
                   icon: Icons.access_alarm,
                    title: 'Disponibilité',
                    showArrow: false,
                    toggle: true,  // Show the toggle button
                    onToggle: (value) {
                      updateProviderAvailability(User.userId, value ? 1 : 0);
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
                            const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.logout, // Using the built-in logout icon
                              size: 60, // Size of the icon
                             color: primaryColor, // Apply the primary color
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Déconnexion",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF565656),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Êtes-vous sûr de vouloir vous déconnecte?",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 86, 86, 86)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                   Navigator.pushReplacement(
                                       context,
                                       MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your login screen
                                   );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    minimumSize: const Size(double.infinity, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Déconnexion",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context); // Fermer la boîte de dialogue
                                  },
                                  child: const Text(
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
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isLast;
  final bool showArrow;
  final Function()? onTap;
  final bool toggle; // New parameter for toggle button
  final ValueChanged<bool>? onToggle; // Callback when toggle is changed

  const ProfileOption({
    required this.icon,
    required this.title,
    this.isLast = false,
    this.showArrow = true,
    this.onTap,
    this.toggle = false, // Default to false
    this.onToggle,
  });

  @override
  _ProfileOptionState createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<ProfileOption> {
  bool _toggleValue = User.availability==0 ? false : true; // Maintain the toggle state



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Handle navigation dynamically
      child: Container(
        margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: primaryColor, size: 28),
                const SizedBox(width: 10),
                Text(widget.title, style: const TextStyle(fontSize: 18)),
              ],
            ),
            // If toggle is true, show the switch button
            if (widget.toggle)
              Switch(
                value: _toggleValue,
                onChanged: (value) {
                  setState(() {
                    _toggleValue = value;
                  });
                  if (widget.onToggle != null) {
                    widget.onToggle!(value);
                  }
                },
                activeColor: primaryColor,
                inactiveTrackColor: Colors.grey,
              ),
            // Show arrow icon by default
            if (widget.showArrow)
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.arrow_forward_ios,
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

  const ProfileTextField({
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
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
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
        const SizedBox(height: 16),
      ],
    );
  }
}

class ProfileDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final Function(String?) onChanged;

  const ProfileDropdown(
      {required this.label, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
            hint: const Text("Sélectionner une ville"),
            underline: const SizedBox(),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
