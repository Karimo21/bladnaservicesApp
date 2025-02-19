import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoroccoMap(),
    );
  }
}

class MoroccoMap extends StatefulWidget {
  @override
  _MoroccoMapState createState() => _MoroccoMapState();
}

class _MoroccoMapState extends State<MoroccoMap> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Barre de recherche
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Recherche...",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon:
                        Icon(Icons.my_location, color: Color(0xFF0054A5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(height: 8),

              // Carte
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(31.7917, -7.0926),
                      zoom: 6.0,
                      interactiveFlags:
                          InteractiveFlag.all & ~InteractiveFlag.rotate,
                           maxBounds: LatLngBounds(
                        LatLng(21.0, -20.0), // Coin sud-ouest
                        LatLng(37.5, 2.0),   // Coin nord-est
                      ),
                    ),
                    children: [
                      // Fond de carte OpenStreetMap
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                        
                      ),

                      // Marqueurs des prestataires avec design amélioré
                      MarkerLayer(
                        markers: [
                          _buildMarker(30.5731, -4.5898,
                              "assets/images/khalid.jpg", "Khalid"),
                          _buildMarker(34.0209, -6.8416,
                              "assets/images/khalid.jpg", "Omar"),
                          _buildMarker(35.7595, -5.83395,
                              "assets/images/khalid.jpg", "ahmed"),
                        ],
                      ),

                      // Boutons de zoom
                      Positioned(
                        bottom: 20,
                        right: 10,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              heroTag: "zoomIn",
                              onPressed: () {
                                _mapController.move(
                                  _mapController.center,
                                  _mapController.zoom + 1,
                                );
                              },
                              mini: true,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.add, color: Colors.black),
                            ),
                            SizedBox(height: 5),
                            FloatingActionButton(
                              heroTag: "zoomOut",
                              onPressed: () {
                                _mapController.move(
                                  _mapController.center,
                                  _mapController.zoom - 1,
                                );
                              },
                              mini: true,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.remove, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              // Bouton "Voir tout"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0054A5),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Voir tout",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour créer un marqueur stylisé
  Marker _buildMarker(
      double lat, double lng, String imagePrestataire, String nom) {
    return Marker(
      point: LatLng(lat, lng),
      width: 80,
      height: 90,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PrestataireDetails(nom: nom, image: imagePrestataire),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: const Color.fromARGB(255, 16, 16, 16),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(236, 248, 242, 242),
                    blurRadius: 2,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePrestataire,
                  width: 30, // Adjust the width for square shape
                  height: 30, // Adjust the height for square shape
                  fit: BoxFit.cover, // Ensure the image fills the square
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 68, 187),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 4,
                )
              ],
            ),
            child: Text(
              nom,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Écran des détails du prestataire
class PrestataireDetails extends StatelessWidget {
  final String nom;
  final String image;

  const PrestataireDetails({super.key, required this.nom, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nom),
        backgroundColor: Color(0xFF0054A5),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(image),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 20),
            Text(
              nom,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Informations sur le prestataire...",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
} 