import 'package:bladnaservices/screens/auth/role_screen.dart';
import 'package:bladnaservices/screens/home/main_screen.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHovered = false; // Variable pour l'effet hover

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle login request
  Future<void> login() async {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    // Make an API call to Node.js backend for authentication
    final response = await http.post(
      Uri.parse('http://localhost:3000/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': phone,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('user')) {
        User.setUserData(
            data['user']['userId'],
            data['user']['role'],
            data['user']['profile'],
            data['user']['fname'] ?? '',
            data['user']['lname'] ?? '',
            data['user']['adresse'] ?? '',
            data['user']['description'] ?? '',
            data['user']['rate'] ?? '',
            data['user']['city'] ?? '',
            data['user']['totalreservations'] ?? '',
            data['user']['service'] ?? '',
            data['user']['availability'] ?? ''
              );

              //SocketService();
      }


      

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
      print("Logged in");
    } else {
      print('Login failed: ${response.body}');
    }
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
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // ✅ Permet de scroller pour éviter l'overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70), // ✅ Utiliser SizedBox au lieu de Padding
              const Text(
                "Connectez-vous",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF565656),
                ),
              ),
              const SizedBox(height: 90),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: "Entrez votre téléphone",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: "Entrez votre mot de passe",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _isHovered ? Colors.blue[700] : const Color(0xFF0054A5),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      "Se Connecter",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Êtes-vous nouveau ? ",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: const Text(
                      "Inscrivez-vous",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0054A5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 50), // ✅ Ajout d'espace en bas pour éviter l'overflow
            ],
          ),
        ),
      ),
    );
  }
}
