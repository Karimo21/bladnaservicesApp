import 'package:bladnaservices/screens/home/notification/notification_screen.dart';
import 'package:bladnaservices/screens/home/services/profile_screen.dart';
import 'package:bladnaservices/screens/home/services/search_screen.dart';
import 'package:bladnaservices/screens/home/services/service_list_screen.dart';
import 'package:bladnaservices/screens/home/services_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<Map<String, dynamic>> services = [
    {"name": "Coiffeur", "emoji": "✂"},
    {"name": "Peintre", "emoji": "🖌"},
    {"name": "Cuisinier", "emoji": "👨‍🍳"},
    {"name": "plombier", "emoji": "🔧"},
    {"name": "Électricien", "emoji": "💡"},
    {"name": "Jardinier", "emoji": "🌿"},
    {"name": "Maçon", "emoji": "🧱"},
    {"name": "Mécanicien", "emoji": "🚗"},
    {"name": "Menuisier", "emoji": "🪵"},
    {"name": "Développeur", "emoji": "💻"},
    {"name": "Photographe", "emoji": "📷"},
    {"name": "Chauffeur", "emoji": "🚕"},
    {"name": "Professeur", "emoji": "📚"},
    {"name": "Agent de sécurité", "emoji": "🛡"},
  ];

  final List<Map<String, dynamic>> providers = [];

Future<void> fetchProviders() async {
  final response = await http.get(Uri.parse('http://localhost:3000/providers'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    print("here");
    List<Map<String, dynamic>> fetchedProviders = data.map((provider) {
      return {
        "provider_id": provider["providers_id"],
        "name": provider["provider_name"],
        "profession": provider["title"],
        "rating": double.tryParse(provider["rating"] ?? "0") ?? 0.0,
        "image": "http://localhost:3000" + provider["profile_picture"],
        "reservations": provider["nbr_res"],
        "location": provider["adresse"],
        "description": provider["description"],
      };
    }).toList();
    setState(() {
      providers.addAll(fetchedProviders);
    });
  } else {
    print("Erreur lors du chargement des prestataires");
  }
}

@override
void initState() {
  super.initState();
  fetchProviders();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      'assets/images/logo.png', // Remplace par le chemin de ton logo
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()),
                        );
                      },
                      child: Icon(Icons.notifications,
                          color: Colors.black, size: 30),
                    )
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Container pour le titre
              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF007CF2),
                      Color(0xFF002A52)
                    ], // Bleu clair à bleu foncé
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  // borderRadius: BorderRadius.circular(12),

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        12), // Coin supérieur gauche NON arrondi
                    topRight:
                        Radius.circular(12), // Coin supérieur droit NON arrondi
                    bottomLeft:
                        Radius.circular(0), // Coin inférieur gauche arrondi
                    bottomRight:
                        Radius.circular(0), // Coin inférieur droit arrondi
                  ), // Bordures légèrement plus arrondies
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meilleurs Services",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            22, // Taille ajustée pour correspondre à l’image
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Il suffit de chercher",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 0), // Espacement ajusté
           Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        spreadRadius: 2,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen(  providers: providers)),
      );
    },
    child: AbsorbPointer(
      child: TextField(
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Recherche ici...",
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 26),
        
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            borderSide: BorderSide(color: Color(0xFF0054A5), width: 1),
          ),
        ),
      ),
    ),
  ),
),

              const SizedBox(height: 20),

              // Services Populaires
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Services populaires",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ServicesScreen(providers: providers)),
                      );
                    },
                    child: Text(
                      "Voir Plus",
                      style: TextStyle(
                        color: Color(0xFF0054A5),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Liste des services
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(services[index]["emoji"],
                              style: TextStyle(fontSize: 30)),
                          SizedBox(height: 5),
                          Text(services[index]["name"],
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Section Prestataires
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Prestataires",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServiceListPage(
                                providers: providers, services: services)),
                      );
                    },
                    child: Text(
                      "Voir Plus",
                      style: TextStyle(
                        color: Color(0xFF0054A5),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Liste des prestataires (Expanded pour éviter le débordement)
              Container(
                height: 220, // Augmenter un peu la hauteur
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow:  [
                          BoxShadow(
                            color:   Colors.grey.shade300, // Ombre plus visible
                            blurRadius: 5,
                            spreadRadius: 1,
                           offset: const Offset(0, -3),
                             // Ombre légèrement décalée vers le bas
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 100,
                            margin: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                providers[index]["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  providers[index]["name"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  providers[index]["profession"],
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Color(0xFF0054A5)),
                                        SizedBox(width: 2),
                                        Text(
                                          "${providers[index]["rating"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                         context,
                                           MaterialPageRoute(
                                           builder: (context) => ProfilePage(
                                                 provider: providers[index]),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF0054A5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        minimumSize: Size(80, 30),
                                      ),
                                      child: const Text(
                                        "Détails",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
     ),
);
}
}
