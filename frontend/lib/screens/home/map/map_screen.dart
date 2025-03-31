import 'package:bladnaservices/screens/home/services/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoroccoMap extends StatefulWidget {
  @override
  _MoroccoMapState createState() => _MoroccoMapState();
}

class _MoroccoMapState extends State<MoroccoMap> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentPosition;
  List<Map<String, dynamic>> _prestataires = [];
  List<Map<String, dynamic>> _filteredPrestataires = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchProviders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProviders() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/providers'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _prestataires = data.map((provider) {
            // Gestion robuste des URLs d'images
            String imageUrl = provider['image']?.toString() ?? '';

            // Correction des chemins Windows
            if (imageUrl.contains('\\')) {
              imageUrl = imageUrl.replaceAll('\\', '/');
            }

            // Suppression des parties de chemin inutiles
            imageUrl = imageUrl.replaceAll('bladnaservicesApp/backend', '');

            // Construction de l'URL complète
            if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
              imageUrl =
                  'http://localhost:3000${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
            }

            // Fallback si l'image est vide
            if (imageUrl.isEmpty) {
              imageUrl =
                  'http://localhost:3000/uploads/profile_pictures/no_profile.jpg';
            }

            return {
              'id': provider['id'] ?? 0, // Ajout de l'ID avec valeur par défaut
              'lat': provider['lat'] != null ? provider['lat'].toDouble() : 0.0,
              'lng': provider['lng'] != null ? provider['lng'].toDouble() : 0.0,
              'image': imageUrl,
              'name': provider['nom']?.toString() ?? 'Inconnu',
              'profession': provider['profession']?.toString() ?? 'Inconnu',
              'cityName': provider['cityName']?.toString()??'Inconnu',
              'location': provider['location']?.toString() ?? 'Inconnu',
              'rating': provider['rating']?.toString() ?? '0',
              'description': provider['description']?.toString() ?? 'Inconnu',
              'reservations': provider['reservations'],
            };
          }).toList();
        });
        print(_prestataires);
      } else {
        throw Exception('Échec du chargement: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de chargement: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de chargement des prestataires')),
      );
    }
  }

  void _onSearchChanged() {
  final query = _searchController.text.trim().toLowerCase();
  print('Searching for: $query'); // Debug print

  setState(() {
    _isSearching = query.isNotEmpty;

    if (_isSearching) {
      _filteredPrestataires = _prestataires.where((prestataire) {
        final name = prestataire['name']?.toString().toLowerCase() ?? '';
        final profession = prestataire['profession']?.toString().toLowerCase() ?? '';
        return name.contains(query) || profession.contains(query);
      }).toList();
      print('Found ${_filteredPrestataires.length} results'); // Debug print
    } else {
      _filteredPrestataires = [];
    }
  });

  if (_filteredPrestataires.isNotEmpty) {
    final firstResult = _filteredPrestataires.first;
    _mapController.move(
      LatLng(firstResult['lat'], firstResult['lng']),
      13.0,
    );
  }
}

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
        13.0,
      );

      await _storeCurrentPosition(position.latitude, position.longitude);
    } catch (e) {
      print('Erreur lors de la récupération de la position: $e');
    }
  }

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

 Marker _buildMarker(double lat, double lng, String? imagePrestataire,
    String? nomComplet, int? id,String? profession,String? location,String? rating,String? description,int? reservations,String?cityName) {
      
  
  bool isCurrentUser = _currentPosition != null &&
      _currentPosition!.latitude == lat &&
      _currentPosition!.longitude == lng;

  String displayName = nomComplet ?? 'Inconnu';
  String imageUrl = _getSafeImageUrl(imagePrestataire);

  return Marker(
    point: LatLng(lat, lng),
    width: 100,
    height: 110,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            print("ID du prestataire : $id");
            if (id != 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    //String? nomComplet, int? id,String? profession,String? location,String? rating,String? description,int? reservations) {
                    provider: {
                      'provider_id': id,
                      'name':nomComplet,
                      'image':imagePrestataire,
                      'profession':profession,
                      'rating':rating,
                      'location':location,
                      'city_name':cityName,
                      'description':description,
                      'reservations':reservations
                    },
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erreur : ID du prestataire invalide")),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(
                color: isCurrentUser
                    ? Colors.blue.shade700
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 1,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48,
                height: 48,
                color: Colors.grey.shade200,
                child: Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.grey.shade600,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          constraints: const BoxConstraints(
            minWidth: 80,  // Augmenté pour mieux contenir les noms
            maxWidth: 120,
          ),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue.shade700 : Colors.blue.shade600,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,  // Changé à Row pour affichage horizontal
            children: [
              if (isCurrentUser) 
                const Icon(Icons.location_on, size: 12, color: Colors.white),
              Flexible(
                child: Text(
                  isCurrentUser ? ' Vous' : displayName,  // Espace ajouté après l'icône
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,  // Légèrement réduit pour mieux fit
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  String _getSafeImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return 'http://localhost:3000/uploads/profile_pictures/no_profile.jpg';
    }

    // Normalisation des chemins
    url = url.replaceAll(r'\', '/');
    url = url.replaceAll('bladnaservicesApp/backend', '');

    // Construction de l'URL complète si nécessaire
    if (!url.startsWith('http')) {
      url = 'http://localhost:3000${url.startsWith('/') ? '' : '/'}$url';
    }

    return url;
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher un prestataire...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _getCurrentLocation();
                      },
                      child: const Icon(Icons.my_location, color: Color(0xFF0054A5)),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              if (_isSearching && _filteredPrestataires.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Aucun prestataire trouvé",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: const LatLng(31.7917, -7.0926),
                          zoom: 6.0,
                          interactiveFlags:
                              InteractiveFlag.all & ~InteractiveFlag.rotate,
                          maxBounds: LatLngBounds(
                            const LatLng(21.0, -20.0),
                            const LatLng(37.5, 2.0),
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: (_isSearching
                                    ? _filteredPrestataires
                                    : _prestataires)
                                .map((prestataire) => _buildMarker(
                                      prestataire['lat'],
                                      prestataire['lng'],
                                      prestataire['image'],
                                      prestataire['name'],
                                      prestataire['id'],
                                      prestataire['profession'],
                                      prestataire['location'],
                                      prestataire['rating'],
                                      prestataire['description'],
                                      prestataire['reservations'],
                                      prestataire['cityName']
                                    ))

                                .toList(),
                          ),
                          if (_currentPosition != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _currentPosition!,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const Positioned(
                        bottom: 20,
                        right: 10,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}