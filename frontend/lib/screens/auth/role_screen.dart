import 'package:flutter/material.dart';
import 'phone_screen.dart'; // Importation de la page où on va envoyer le rôle

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? selectedRole; // Variable pour stocker le rôle sélectionné
  late List<Map<String, dynamic>> dataUser; // Correction du nom

  @override
  void initState() {
    super.initState();
    // Initialisation de la liste des utilisateurs
    dataUser = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            dataUser.clear();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Je suis",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xFF565656),
              ), 
            ),
            const SizedBox(height: 30),
            _buildRoleCard("provider", "Je propose un service"),
            const SizedBox(height: 20),
            _buildRoleCard("client", "Je cherche des services"),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0054A5),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              onPressed: selectedRole == null
                  ? null
                  : () {
                      // Ajouter l'utilisateur avec le rôle sélectionné
                      dataUser.add({"role": selectedRole});

                      // Redirection vers PhoneScreen avec le rôle et la liste
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneScreen(
                            role: selectedRole!,
                            dataUser: dataUser, // Passage de la liste
                          ),
                        ),
                      );
                    },
              child: const Center(
                child: Text(
                  "Suivant",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(String role, String description) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300,
            width: 2,
          ),
          color: isSelected ? const Color(0xFFE6F1FB) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFF0054A5), size: 24),
          ],
        ),
      ),
    );
  }
}
