import 'package:bladnaservices/screens/home/notification/notification_screen.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
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

  List<Map<String, dynamic>> providers = [];
  bool isLoading = true;  
    // Fake provider data
  final List<Map<String, dynamic>> fakeProviders = [
    {
      "provider_id": 1,
      "name": "nom complete",
      "profession": "service",
      "rating": 0,
      "image": "assets/images/placeholder.png",
      "reservations": 3,
      "location": "Location 1",
      "description": "Description 1",
    },
    {
      "provider_id": 2,
      "name": "nom complete",
      "profession": "service",
      "rating": 0,
      "image": "assets/images/placeholder.png",
      "reservations": 2,
      "location": "Location 2",
      "description": "Description 2",
    }
  ];

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
        "city_name": provider["city_name"],
        "rating": double.tryParse(provider["rating"] ?? "0") ?? 0.0,
        "image": "http://localhost:3000" + provider["profile_picture"],
        "reservations": provider["nbr_res"],
        "location": provider["adresse"],
        "description": provider["description"],
      };
    }).toList();
    setState(() {
      providers.clear();
      providers.addAll(fetchedProviders);
      isLoading = false;
    });
  } else {
    print("Erreur lors du chargement des prestataires");
  }
}

int unreadNotifications = 0;
Future<void> fetchUnreadNotifications() async {
  final response = await http.get(Uri.parse('http://localhost:3000/notifications/unread/${User.userId}'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    setState(() {
      unreadNotifications = data['count'];
    });
  } else {
    print("Erreur lors du chargement des notifications non lues");
  }
}
Future<void> markNotificationAsRead() async {
  final response = await http.post(Uri.parse('http://localhost:3000/notifications/read/${User.userId}'));

  if (response.statusCode == 200) {
     print("Notification lues avec success");
  } else {
    print("Erreur lors du chargement des notifications non lues");
  }
}
@override
void initState() {
  super.initState();
  providers=fakeProviders;
  //if(!mounted) return;
  fetchProviders().then((_) => fetchUnreadNotifications());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(8),
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
                        setState(() {
                            unreadNotifications = 0;
                        });
                        markNotificationAsRead();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()),
                        );
                      },
                      child: Stack(
    children: [
      const Icon(Icons.notifications, color: Colors.black, size: 30),
      if (unreadNotifications > 0)
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 10,
              minHeight: 5,
            ),
            child: Text(
              '$unreadNotifications',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
   ),

                          
                    )
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Container pour le titre
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
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

              const SizedBox(height: 0), // Espacement ajusté
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Ombre légère et réaliste
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
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
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Recherche ici...",
                        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey, size: 26),
                        suffixIcon: const Icon(Icons.tune,
                            color: Colors.grey, size: 24), // Icône filtre
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0), // Pas d'arrondi en haut
                            topRight: Radius.circular(0), // Pas d'arrondi en haut
                            bottomLeft: Radius.circular(10), // Arrondi en bas
                            bottomRight: Radius.circular(10), // Arrondi en bas
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          borderSide:
                              BorderSide(color: Color(0xFF0054A5), width: 1),
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
                  const Text(
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
                    child: const Text(
                      "Voir Plus",
                      style: TextStyle(
                        color: Color(0xFF0054A5),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Liste des services
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(services[index]["emoji"],
                              style: const TextStyle(fontSize: 30)),
                          const SizedBox(height: 5),
                          Text(services[index]["name"],
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

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
                    child: const Text(
                      "Voir Plus",
                      style: TextStyle(
                        color: Color(0xFF0054A5),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Liste des prestataires (Expanded pour éviter le débordement)
              SizedBox(
                height: 220, // Augmenter un peu la hauteur
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 10),
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
                            margin: const EdgeInsets.all(8),
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
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  providers[index]["profession"],
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Color(0xFF0054A5)),
                                        const SizedBox(width: 2),
                                        Text(
                                          "${providers[index]["rating"]}",
                                          style: const TextStyle(
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
                                        backgroundColor: const Color(0xFF0054A5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        minimumSize: const Size(80, 30),
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
