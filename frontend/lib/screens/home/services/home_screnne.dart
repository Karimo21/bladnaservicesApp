import 'package:bladnaservices/screens/home/services/profile_screen.dart';
import 'package:bladnaservices/screens/home/services/service_list_screen.dart';
import 'package:bladnaservices/screens/home/services_screen.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {"name": "Coiffeur", "emoji": "✂️"},
    {"name": "Peintre", "emoji": "🖌️"},
    {"name": "Cuisinier", "emoji": "👨‍🍳"},
    {"name": "Plombier", "emoji": "🔧"},
    {"name": "Électricien", "emoji": "💡"},
    {"name": "Jardinier", "emoji": "🌿"},
    {"name": "Maçon", "emoji": "🧱"},
    {"name": "Mécanicien", "emoji": "🚗"},
    {"name": "Menuisier", "emoji": "🪵"},
    {"name": "Développeur", "emoji": "💻"},
    {"name": "Photographe", "emoji": "📷"},
    {"name": "Chauffeur", "emoji": "🚕"},
    {"name": "Professeur", "emoji": "📚"},
    {"name": "Agent de sécurité", "emoji": "🛡️"},
  ];

   final List<Map<String, dynamic>> providers = [
    {
      "name": "Hassan Rochdi",
      "profession": "Plombier",
      "rating": 4.8,
      "image": "assets/images/image.jpg",
      "reservations": 320,
      "location": "Hay Salam, Rue 12",
      "description": "Je suis Hassan Rochdi, un médecin généraliste dévoué, passionné par la santé et le bien-être de mes patients. Mon objectif est de fournir des soins de qualité et d'accompagner chaque personne pour préserver et améliorer sa santé au quotidien.",
    },
    {
      "name": "Samir Janwi",
      "profession": "Électricien",
      "rating": 4.0,
      "image": "assets/images/image.jpg",
      "reservations": 120,
      "location": "Centre Ville, Rue 5",
      "description": "Je suis Samir Janwi, un cuisinier expérimenté...",
    },
    {
      "name": "Ahmed Othman",
      "profession": "Électricien",
      "rating": 4.5,
      "image": "assets/images/image.jpg",
      "reservations": 90,
      "location": "Quartier Industriel, Rue 8",
      "description": "Je suis Ahmed Othman, un électricien qualifié...",
    },
      {
      "name": "Hassan Rochdi",
      "profession": "Plombier",
      "rating": 4.8,
      "image": "assets/images/image.jpg",
      "reservations": 320,
      "location": "Hay Salam, Rue 12",
      "description": "Je suis Hassan Rochdi, un médecin généraliste dévoué, passionné par la santé et le bien-être de mes patients. Mon objectif est de fournir des soins de qualité et d'accompagner chaque personne pour préserver et améliorer sa santé au quotidien.",
    },
    {"name": "Ali Bensaid", "profession": "Électricien", "rating": 4.5, "image": "assets/images/logo.png", "reservations": 200, "location": "Quartier Industriel, Rue 8", "description": "Électricien qualifié, installation et dépannage de circuits électriques pour maisons et entreprises."},

{"name": "Karim El Amrani", "profession": "Électricien", "rating": 4.2, "image": "assets/images/logo.png", "reservations": 150, "location": "Hay Mohammadi, Rue 10", "description": "Spécialiste en systèmes électriques modernes et énergies renouvelables."},

{"name": "Rachid Belhaj", "profession": "Électricien", "rating": 4.7, "image": "assets/images/logo.png", "reservations": 250, "location": "Centre Ville, Rue 15", "description": "Expert en installation électrique pour bâtiments résidentiels et commerciaux."},

{"name": "Yassine Oukili", "profession": "G", "rating": 4.0, "image": "assets/images/logo.png", "reservations": 130, "location": "Hay Salam, Rue 7", "description": "Dépannage et maintenance électrique rapide et efficace."},

{"name": "Omar Zidane", "profession": "Électricien", "rating": 4.3, "image": "assets/images/logo.png", "reservations": 180, "location": "Agadir, Rue 3", "description": "Travaux électriques professionnels pour maisons et bureaux."},

{"name": "Hicham Bakkali", "profession": "CC", "rating": 4.6, "image": "assets/images/logo.png", "reservations": 220, "location": "Tikiouine, Rue 5", "description": "Installation et réparation de tableaux électriques et disjoncteurs."},


  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
  
      body:
    
        SingleChildScrollView(
  
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
                Icon(Icons.notifications, color: Colors.black , size: 30,),
              ],
            ),
          ),


SizedBox(height:15),


              // Container pour le titre
      Container(
  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
  width: double.infinity,
  decoration: BoxDecoration(
    gradient: LinearGradient(
       colors: [Color(0xFF007CF2), Color(0xFF002A52)], // Bleu clair à bleu foncé
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    // borderRadius: BorderRadius.circular(12),
    
  borderRadius: BorderRadius.only(
  topLeft: Radius.circular(12),  // Coin supérieur gauche NON arrondi
  topRight: Radius.circular(12), // Coin supérieur droit NON arrondi
  bottomLeft: Radius.circular(0), // Coin inférieur gauche arrondi
  bottomRight: Radius.circular(0), // Coin inférieur droit arrondi
), // Bordures légèrement plus arrondies
  ),
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Meilleurs Services",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22, // Taille ajustée pour correspondre à l’image
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
        color: Colors.black.withOpacity(0.2), // Ombre légère et réaliste
        blurRadius: 8,
        spreadRadius: 2,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: TextField(
    style: TextStyle(fontSize: 16),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: "Recherche ici...",
      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 26),
      suffixIcon: Icon(Icons.tune, color: Colors.grey, size: 24), // Icône filtre
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),  // Pas d'arrondi en haut
          topRight: Radius.circular(0), // Pas d'arrondi en haut
          bottomLeft: Radius.circular(10), // Arrondi en bas
          bottomRight: Radius.circular(10), // Arrondi en bas
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


      const         SizedBox(height: 20),

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
                        MaterialPageRoute(builder: (context) => ServicesScreen(providers: providers)),
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
                const  Text(
                    "Prestataires",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {

                              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServiceListPage(providers: providers , services: services)),
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
  height: 235, // Augmenter un peu la hauteur
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
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 255, 255, 255), // Ombre plus visible
              blurRadius: 8,
              spreadRadius: 3,
              offset: Offset(2, 4), // Ombre légèrement décalée vers le bas
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFF0054A5)),
                          SizedBox(width: 2),
                          Text(
                            "${providers[index]["rating"]}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(provider: providers[index]),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0054A5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size(80, 30),
                        ),
                        child:const Text(
                          "Détails",
                          style: TextStyle(color: Colors.white, fontSize: 14),
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
