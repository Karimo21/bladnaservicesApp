import 'package:bladnaservices/screens/home/chat/chat_screen.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:bladnaservices/screens/home/reservation/rate_screen.dart';
import 'package:bladnaservices/screens/home/reservation/reservation_prestataire_screen.dart';
import 'package:bladnaservices/screens/home/review/review_screen.dart';
import 'package:bladnaservices/screens/home/services/galerie_screen.dart';
import 'package:bladnaservices/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> provider;
  const ProfilePage({super.key, required this.provider});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, dynamic>> reviews = [];
   SocketService socketService = SocketService();

  final List<String> galleryImages = [];

  // Future method to fetch data from API
  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/provider/${widget.provider['provider_id']}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Add fetched images to galleryImages list
        for (var image in data['images']) {
          setState(() {
            galleryImages.add('http://localhost:3000${image['image_url']}');
          });
        }

        // Add fetched reviews to reviews list
        for (var rating in data['ratings']) {
          setState(() {
            reviews.add({
              'name': '${rating['firstname']} ${rating['lastname']}',
              'date': rating['created_at'],
              'comment': rating['feedback'],
              'rating': rating['rating'],
              'profileImage':'http://localhost:3000${rating['profile_picture']}'
            });
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  //create-contact 
 Future<void> createContact(int senderId, int receiverId) async {
  const String url = 'http://localhost:3000/add-contact';
  print(senderId);
  print(receiverId);

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Specify JSON format
      },
      body: jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
      }),
    );

    if (response.statusCode == 201) {
      print("Contact created successfully");
    } else {
      print("Failed to create contact: ${response.body}");
    }
  } catch (e) {
    print("Error creating contact: $e");
  }
}

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetch data method when the page loads
    print(widget.provider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(widget.provider['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      clipBehavior: Clip
                          .hardEdge, // Permet de s'assurer que l'image respecte le borderRadius
                    ),
                    Positioned(
                      top: 1,
                      left: 1,
                      child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 30),
                          onPressed: () => {
                                Navigator.pop(context),
                              }),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFF0054A5), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.provider['rating']}",
                              style: const TextStyle(
                                color: Color(0xFF0054A5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.provider['name'],
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.work, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Text(widget.provider['profession']),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          if(User.userId != widget.provider['provider_id'])
                          IconButton(
                            icon: const Icon(Icons.chat, color: Color(0xFF0054A5)),
                            onPressed: () async {

                            await createContact(User.userId, widget.provider['provider_id']);

                            socketService.markMessagesAsRead(User.userId, widget.provider['provider_id'] );
                            
                            Navigator.push(
                             context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    userId: User.userId,
                                    contactId: widget.provider['provider_id'] ,
                                    contactRole: "provider",
                                    profile_picture:widget.provider['image'],
                                    name:widget.provider['name']),
                                    ),        
                          );

                            },
                          ),

                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.bookmark, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                              "${widget.provider['reservations']} Réservations"),
                        ],
                      ),
                     const  SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(widget.provider['city_name']+", "+widget.provider['location']),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      const Text(
                        "À propos",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.provider['description'],
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      if(galleryImages.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          const Text(
                            'Galerie',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                         
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GaleriePage(
                                        galleryImages: galleryImages)),
                              );

                              // Action pour afficher plus d'images
                            },
                            child: const Text(
                              "Voire tout",
                              style: TextStyle(
                                  color: Color(0xFF0054A5), fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      if(galleryImages.isNotEmpty)
                      const SizedBox(height: 10),

                      // Largeur de l'image
                     if(galleryImages.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(
                          maxHeight: 120, // Hauteur maximale
                          maxWidth: double
                              .infinity, // Largeur infinie pour que ListView s'affiche correctement
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: galleryImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  galleryImages[index],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      if(galleryImages.isNotEmpty)
                      const SizedBox(height: 20),
                      if(reviews.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Avis',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReviewsScreen(
                                       reviews: reviews
                                        )),
                              );
                            },
                            child: const Text(
                              "Voire tout",
                              style: TextStyle(
                                  color: Color(0xFF0054A5), fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      if(reviews.isEmpty)
                      const SizedBox(height: 50),
                      if(reviews.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ligne avec l'avatar, le nom et la date
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                review['profileImage']!),
                                            radius: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            review['name']!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        review['date']!,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  // Affichage des étoiles
                                  Row(
                                    children: List.generate(
                                      review['rating'],
                                      (i) => const Icon(Icons.star,
                                          color: Color(0xFF0054A5), size: 18),
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                  // Commentaire
                                  Text(review['comment']!),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [

                  if(User.userId != widget.provider['provider_id'])
                  Expanded(
                    flex: 3, // 30% de l'espace
                    child: ElevatedButton(
                      onPressed: () {
                          Navigator.push(
                            context,
                             MaterialPageRoute(
                                builder: (context) =>  RateScreen(
                                    providerId: widget.provider['provider_id'].toString(),
                                    profileImage:widget.provider['image'],
                                    providerName: widget.provider['name'].toString(),
                                    serviceName: widget.provider['profession'].toString(),
                                    city: widget.provider['city_name'].toString(),
                                    rate: widget.provider['rating'].toString(),
                                )),
                          );                         
                      },
                      style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0xFF28A745 ), // Couleur de fond
                               padding: const EdgeInsets.symmetric(vertical: 15), // Padding interne
                               shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(5), // Coins carrés
                                ),
                            ),
                      child: const Text('Évaluer',style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),
                  if(User.userId != widget.provider['provider_id'])
                  const SizedBox(width: 10),
                  if(User.userId != widget.provider['provider_id'])
                  Expanded(
                    flex: 7, // 70% de l'espace
                    child: ElevatedButton(
                      onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReservationPrestataireScreen(provider:widget.provider)),
                              );     
                      },
                      style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0xFF0054A5), // Couleur de fond
                               padding: const EdgeInsets.symmetric(vertical: 15), // Padding interne
                               shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(5), // Coins carrés
                                ),
                            ),
                      child: const Text('Réserver',style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
