import 'package:bladnaservices/screens/home/services/profile_screen.dart';
import 'package:flutter/material.dart';

class ServiceListPage extends StatelessWidget {
  final List<Map<String, dynamic>> providers;
  final List<Map<String, dynamic>> services;

  const ServiceListPage({required this.providers, required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Services",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Liste des services
        
          
          const SizedBox(height: 20),

          // Liste des prestataires
          Expanded(
            child: ServiceProvidersList(providers: providers),
          ),
        ],
      ),
    );
  }
}

// Écran affichant uniquement les prestataires du service sélectionné
class ProviderListScreen extends StatelessWidget {
  final String profession;
  final List<Map<String, dynamic>> providers;

  const ProviderListScreen({required this.profession, required this.providers});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProviders =
        providers.where((p) => p["profession"] == profession).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Prestataires - $profession"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: filteredProviders.isEmpty
          ? const Center(child: Text("Aucun prestataire trouvé"))
          : ListView.builder(
              itemCount: filteredProviders.length,
              itemBuilder: (context, index) {
                return ProviderCard(provider: filteredProviders[index]);
              },
            ),
    );
  }
}

// Liste des prestataires affichés initialement
class ServiceProvidersList extends StatelessWidget {
  final List<Map<String, dynamic>> providers;

  const ServiceProvidersList({required this.providers});


  @override
  Widget build(BuildContext context) {
    // Grouper les prestataires par profession
    Map<String, List<Map<String, dynamic>>> groupedProviders = {};
    for (var provider in providers) {
      String profession = provider["profession"];
      if (!groupedProviders.containsKey(profession)) {
        groupedProviders[profession] = [];
      }
      groupedProviders[profession]!.add(provider);
    }

    return ListView(
      children: groupedProviders.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "🛠️ ${entry.key}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(
  height: 235, // Hauteur du scroll horizontal
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: entry.value.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), // Espace autour des cartes
        child: ProviderCard(provider: entry.value[index]),
      );
    },
  ),
),

           const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}

// Carte d'un prestataire
class ProviderCard extends StatelessWidget {
  final Map<String, dynamic> provider;

  const ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
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
                provider["image"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(provider["profession"], style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFF0054A5)),
                        const SizedBox(width: 2),
                        Text("${provider["rating"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(provider: provider),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0054A5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(80, 30),
                      ),
                      child: const Text("Détails", style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
