import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  LatLng? _currentPosition;
  List<Map<String, dynamic>> _prestataires =
      []; // Liste pour stocker les prestataires depuis la base de données

  @override
  void initState() {
    super.initState();
    _fetchProviders(); // Charger les prestataires au démarrage
  }

  // Charger les prestataires depuis la base de données
  Future<void> _fetchProviders() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/providers'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _prestataires = data
              .map((provider) => {
                    'lat': provider['lat'] ?? 0.0, // Valeur par défaut si null
                    'lng': provider['lng'] ?? 0.0, // Valeur par défaut si null
                    'image': provider['image'] ??
                        'assets/images/khalid.jpg', // Image par défaut si null
                    'nom':
                        provider['nom'] ?? 'Inconnu', // Nom par défaut si null
                  })
              .toList();
        });
      } else {
        throw Exception('Échec du chargement des prestataires');
      }
    } catch (e) {
      print('Erreur lors du chargement des prestataires: $e');
    }
  }

  // Obtenir la position actuelle et la stocker dans la base de données
  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Permission refusée");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(
        _currentPosition!,
        13.0, // Zoom sur la position actuelle
      );

      // Stocker la position actuelle dans la base de données
      await _storeCurrentPosition(position.latitude, position.longitude);
    } catch (e) {
      print('Erreur lors de la récupération de la position: $e');
    }
  }

  // Stocker la position actuelle dans la base de données
  Future<void> _storeCurrentPosition(double latitude, double longitude) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/providers/2/position'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Échec du stockage de la position');
      }
    } catch (e) {
      print('Erreur lors du stockage de la position: $e');
    }
  }

  // Créer un marqueur stylisé
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
                  imagePrestataire ??
                      'assets/images/default.jpg', // Image par défaut si null
                  width: 40, // Ajuster la largeur pour une forme carrée
                  height: 40, // Ajuster la hauteur pour une forme carrée
                  fit: BoxFit.cover, // Assurer que l'image remplit le carré
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
              nom ?? 'Inconnu', // Nom par défaut si null
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
                    suffixIcon: GestureDetector(
                      onTap:
                          _getCurrentLocation, // Fonction pour la localisation
                      child: Icon(Icons.my_location, color: Color(0xFF0054A5)),
                    ),
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
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: LatLng(31.7917, -7.0926),
                          zoom: 6.0,
                          interactiveFlags:
                              InteractiveFlag.all & ~InteractiveFlag.rotate,
                          maxBounds: LatLngBounds(
                            LatLng(21.0, -20.0), // Coin sud-ouest
                            LatLng(37.5, 2.0), // Coin nord-est
                          ),
                        ),
                        children: [
                          // Fond de carte OpenStreetMap
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),

                          // Marqueurs des prestataires
                          MarkerLayer(
                            markers: _prestataires
                                .map((prestataire) => _buildMarker(
                                      prestataire['lat'],
                                      prestataire['lng'],
                                      prestataire['image'],
                                      prestataire['nom'],
                                    ))
                                .toList(),
                          ),

                          // Marqueur de position actuelle
                          if (_currentPosition != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _currentPosition!,
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
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
}

// Page fictive pour les détails du prestataire
class PrestataireDetails extends StatelessWidget {
  final String nom;
  final String image;

  const PrestataireDetails({super.key, required this.nom, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nom ?? 'Inconnu'), // Nom par défaut si null
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              image ?? 'assets/images/khalid.jpg', // Image par défaut si null
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Détails de ${nom ?? 'Inconnu'}", // Nom par défaut si null
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
