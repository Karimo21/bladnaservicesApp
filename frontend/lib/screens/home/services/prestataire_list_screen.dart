import 'package:bladnaservices/screens/home/services/profile_screen.dart';  
import 'package:flutter/material.dart';

class ProvidersList extends StatelessWidget {
  final List<Map<String, dynamic>> providers;
  final List<Map<String, dynamic>> services;
  final String selectedService;

  ProvidersList({
    required this.providers,
    required this.services,
    required this.selectedService,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrer les prestataires selon le service sélectionné
    List<Map<String, dynamic>> filteredProviders = providers
        .where((provider) => provider["profession"] == selectedService)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(" $selectedService", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0, 
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: filteredProviders.isEmpty
          ? Center(child: Text("Aucun prestataire trouvé pour $selectedService"))
          : Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Deux prestataires par ligne
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, // Ajuste la taille des cartes
                ),
                itemCount: filteredProviders.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
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
                          width: double.infinity,
                          height: 100,
                          margin: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              filteredProviders[index]["image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredProviders[index]["name"],
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(filteredProviders[index]["profession"],
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Color(0xFF0054A5)),
                                      SizedBox(width: 2),
                                      Text("${filteredProviders[index]["rating"]}",
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(provider: filteredProviders[index]),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0054A5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      minimumSize: Size(80, 30),
                                    ),
                                    child: Text(
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
    );
  }
}
