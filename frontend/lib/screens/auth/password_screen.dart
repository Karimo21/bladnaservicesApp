import 'dart:convert';
import 'package:bladnaservices/env.dart';
import 'package:bladnaservices/screens/auth/info_screen.dart';
import 'package:bladnaservices/screens/auth/login_screen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class PasswordScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataUser;

  const PasswordScreen({super.key, required this.dataUser});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  String role="";
  List<Map<String, dynamic>> cities = [];
  
  String? _selectedCity;
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Helper function to determine the MediaType
  MediaType getMediaType(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      default:
        return MediaType('image', 'jpeg'); // Default to jpeg if unknown
    }
  }

  // Fetch cities from the API
  Future<void> fetchCities() async {
    final response = await http.get(Uri.parse('${Environment.apiHost}/cities'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        cities = List<Map<String, dynamic>>.from(data['cities']);
      });
    } else {
    }
  }
  @override
  void initState() {
    super.initState();
    fetchCities();
    print(widget.dataUser);

    role = widget.dataUser.firstWhere(
                              (element) => element.containsKey("role"),
                              orElse: () => {"role": "client"})["role"];
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
          onPressed: () => {
            widget.dataUser.clear(),
            Navigator.pop(context),
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Créez votre mot de passe ",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF565656)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: "Nom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Le nom est obligatoire" : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _prenomController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Prénom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Le prénom est obligatoire" : null,
                ),

                if(role=="client") 
                const SizedBox(height: 20),

                if(role=="client")            // Dropdown for Cities
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_city),
                    hintText: "Sélectionnez une ville",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  value: _selectedCity,
                  items: cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city["city_id"].toString(), // Ensure it's a string
                      child: Text(city["city_name"]),
                      
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                  validator: (value) => value == null ? "Veuillez choisir une ville" : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: "Mot de passe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Le mot de passe est obligatoire";
                    }
                    if (value.length < 6) {
                      return "Le mot de passe doit contenir au moins 6 caractères";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: "Confirmez votre mot de passe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      icon: Icon(_confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() =>
                          _confirmPasswordVisible = !_confirmPasswordVisible),
                    ),
                  ),
                  validator: (value) => value != _passwordController.text
                      ? "Les mots de passe ne correspondent pas"
                      : null,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0054A5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Extract user data from widget.dataUser
                        Map<String, dynamic> userData = {
                          "fname": _nomController.text.trim(),
                          "lname": _prenomController.text.trim(),
                          "phone": widget.dataUser.firstWhere(
                              (element) => element.containsKey("phone"),
                              orElse: () => {"phone": ""})["phone"],
                          "password": _passwordController.text,
                          "ville_id2": _selectedCity,
                          "role": widget.dataUser.firstWhere(
                              (element) => element.containsKey("role"),
                              orElse: () => {"role": "client"})["role"],
                          "ville_id": widget.dataUser.firstWhere(
                                    (element) => element.containsKey("ville"),
                                       orElse: () => {"ville": null}
                                     )["ville"],
                          "service_id":widget.dataUser.firstWhere(
                                   (element) => element.containsKey("service"),
                                     orElse: () => {"service": null}
                                  )["service"],
                          "adresse":widget.dataUser.firstWhere(
                                   (element) => element.containsKey("adresse"),
                                    orElse: () => {"adresse": "Not found"})["adresse"],
                          "description":widget.dataUser.firstWhere(
                                   (element) => element.containsKey("description"),
                                    orElse: () => {"description": "Not found"})["description"],
                        };

                        // Create Multipart Request
                        String url = '';
                        String role = userData["role"];
                        print(userData);
                        if (role == "client") {
                          url = "${Environment.apiHost}/create-client";
                        } else if (role == "provider") {
                          url = "${Environment.apiHost}/create-provider";
                        }

                        var request = http.MultipartRequest('POST', Uri.parse(url))
                          ..fields['fname'] = userData["fname"]
                          ..fields['lname'] = userData["lname"]
                          ..fields['phone'] = userData['phone']
                          ..fields['password'] = userData["lname"]
                          ..fields['adresse'] = userData["adresse"]
                          ..fields['password'] = userData["password"]
                          ..fields['description'] = userData["description"]
                          ..fields['ville_id'] = userData["ville_id"] ?? ""
                          ..fields['ville_id2'] = userData["ville_id2"] ?? ""
                          ..fields['service_id'] = userData["service_id"] ?? ""
                          ..fields['role'] = role;
  
                          
                        // Attach images if available
                        if (widget.dataUser[0]["front_image"] != null) {
                          String frontImagePath = 'front_image.jpg'; // Adjust if necessary
                          MediaType frontImageType = getMediaType(frontImagePath);
                          request.files.add(http.MultipartFile.fromBytes(
                            'front_image',
                            widget.dataUser[0]["front_image"],
                            filename: frontImagePath,
                            contentType: frontImageType,
                          ));
                        }
                        if (widget.dataUser[0]["back_image"] != null) {
                          String backImagePath = 'back_image.jpg'; // Adjust if necessary
                          MediaType backImageType = getMediaType(backImagePath);
                          request.files.add(http.MultipartFile.fromBytes(
                            'back_image',
                            widget.dataUser[0]["back_image"],
                            filename: backImagePath,
                            contentType: backImageType,
                          ));
                        }
                        if (widget.dataUser[0]["diploma_image"] != null) {
                          String diplomaImagePath = 'diploma_image.jpg'; // Adjust if necessary
                          MediaType diplomaImageType = getMediaType(diplomaImagePath);
                          request.files.add(http.MultipartFile.fromBytes(
                            'diploma_image',
                            widget.dataUser[0]["diploma_image"],
                            filename: diplomaImagePath,
                            contentType: diplomaImageType,
                          ));
                        }

                        // Send the request
                        try {
                          var response = await request.send();
                          if (response.statusCode == 200) {

                            if(role=="client"){
                              ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Compte créé avec succès!")),
                            );
                              Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            }
                            if(role=="provider"){
                              Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => ConfirmationScreen()),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Erreur: ${response.statusCode}")),
                            );
                          }
                        } catch (e) {
                          print("Error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Impossible de se connecter au serveur")),
                          );
                        }
                      }
                    },
                    child: const Text("Enregistrer", style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20), // Add some space to avoid overflow
              ],
            ),
          ),
        ),
      ),
    );
  }
}
