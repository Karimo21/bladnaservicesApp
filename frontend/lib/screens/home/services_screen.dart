import 'package:bladnaservices/screens/home/services/prestataire_list_screen.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> providers;

  ServicesScreen({required this.providers});


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
    {"name": "Agent de sécurité", "emoji": "🛡️"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Services", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 services par ligne
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            String selectedService = services[index]["name"]; // ✅ Service sélectionné

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProvidersList(
                      providers: providers,
                      services: services,
                      selectedService: selectedService, // ✅ Passe le service sélectionné
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white, // ✅ Fond blanc
                elevation: 2, // ✅ Ajout d'une ombre légère
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300), // ✅ Bordure gris clair
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      services[index]["emoji"],
                      style: TextStyle(fontSize: 40), // Taille des emojis
                    ),
                    SizedBox(height: 5),
                    Text(
                      services[index]["name"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // ✅ Texte en noir pour la lisibilité
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
