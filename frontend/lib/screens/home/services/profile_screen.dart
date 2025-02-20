import 'package:bladnaservices/screens/home/services/galerie_screen.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> provider;
  ProfilePage({Key? key, required this.provider}) : super(key: key);

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Josh Peter',
      'date': '12/12/2024',
      'comment': 'Excellent service!',
      'rating': 5,
      'profileImage': 'assets/images/image.jpg',
    },
    {
      'name': 'Caleb',
      'date': '12/12/2024',
      'comment': 'Highly recommend!',
      'rating': 4,
      'profileImage': 'assets/images/profile2.png',
    },
    {
      'name': 'Ethan',
      'date': '12/12/2024',
      'comment': 'Very professional!',
      'rating': 3,
      'profileImage': 'assets/images/profile3.png',
    },
    {
      'name': 'Sophia',
      'date': '11/12/2024',
      'comment': 'Friendly and efficient!',
      'rating': 5,
      'profileImage': 'assets/images/profile4.png',
    },
    {
      'name': 'Liam',
      'date': '10/12/2024',
      'comment': 'Good service but a bit slow.',
      'rating': 3,
      'profileImage': 'assets/images/profile5.png',
    },
    {
      'name': 'Olivia',
      'date': '09/12/2024',
      'comment': 'Affordable and high quality!',
      'rating': 4,
      'profileImage': 'assets/images/profile6.png',
    },
    {
      'name': 'Noah',
      'date': '08/12/2024',
      'comment': 'Great communication and timely work.',
      'rating': 5,
      'profileImage': 'assets/images/profile7.png',
    },
    {
      'name': 'Ava',
      'date': '07/12/2024',
      'comment': 'Satisfactory work, could be improved.',
      'rating': 3,
      'profileImage': 'assets/images/profile8.png',
    },
    {
      'name': 'Mason',
      'date': '06/12/2024',
      'comment': 'Very reliable and honest.',
      'rating': 5,
      'profileImage': 'assets/images/profile9.png',
    },
  ];

  final List<String> galleryImages = [
    'assets/images/image.jpg',
    'assets/images/image1.png',
    'assets/images/logo_bladna_service.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];


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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0), 
                          topRight: Radius.circular(0), 
                          bottomLeft: Radius.circular(22), 
                          bottomRight: Radius.circular(22), 
                        ),
                        image: DecorationImage(
                          image: AssetImage(provider['image']),
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
                        icon: Icon(Icons.arrow_back,
                            color: Colors.black, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star,
                                color: Color(0xFF0054A5), size: 18),
                            SizedBox(width: 4),
                            Text(
                              "${provider['rating']}",
                              style: TextStyle(
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
                  padding: EdgeInsets.all(16.0),
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
                                  Icon(Icons.person, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Text(
                                    provider['name'],
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.work, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Text(provider['profession']),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.chat, color: Color(0xFF0054A5)),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.call, color: Color(0xFF0054A5)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.bookmark, color: Colors.grey),
                          SizedBox(width: 5),
                          Text("${provider['reservations']} Réservations"),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(provider['location']),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "À propos",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        provider['description'],
                        textAlign: TextAlign.justify,
                      ),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Galerie',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GaleriePage(galleryImages :galleryImages)),
                      );
                              
                              
                              // Action pour afficher plus d'images
                            },
                            child: Text(
                              "Voire tout",
                              style: TextStyle(
                                  color: Color(0xFF0054A5), fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // Largeur de l'image

                      Container(
                        constraints: BoxConstraints(
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
                                child: Image.asset(
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

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      const    Text(
                            'Avis',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
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

                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: EdgeInsets.all(10),
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
                                            backgroundImage: AssetImage(
                                                review['profileImage']!),
                                            radius: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            review['name']!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        review['date']!,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  // Affichage des étoiles
                                  Row(
                                    children: List.generate(
                                      review['rating'],
                                      (i) => Icon(Icons.star,
                                          color: Color(0xFF0054A5), size: 18),
                                    ),
                                  ),

                                  SizedBox(height: 5),
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
    padding: EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          flex: 3, // 30% de l'espace
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD3D3D3),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Évaluer'),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 7, // 70% de l'espace
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0054A5),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Réserver'),
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
