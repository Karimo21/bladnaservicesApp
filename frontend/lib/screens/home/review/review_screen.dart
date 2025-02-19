import 'package:flutter/material.dart';

class ReviewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "khalidDaoudi",
      "rating": 4.5,
      "date": "12/12/2024",
      "avatar": "assets/female.png"
    },
    {
      "name": "ilyass",
      "rating": 3.5,
      "date": "12/12/2024",
      "avatar": "assets/male.png"
    },
    {
      "name": "karim",
      "rating": 4.0,
      "date": "12/12/2024",
      "avatar": "assets/female.png"
    },
    {
      "name": "riwaya",
      "rating": 4.5,
      "date": "12/12/2024",
      "avatar": "assets/male.png"
    },
    {
      "name": "Hassan",
      "rating": 3.5,
      "date": "12/12/2024",
      "avatar": "assets/male.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Avis",
            style: TextStyle(
                color: const Color(0xFF0054A5),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: const Color(0xFF0054A5), size: 22),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            SizedBox(
                height: 10), // ✅ Ajoute un espace entre l'AppBar et la liste
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return ReviewCard(
                    name: reviews[index]['name'],
                    rating: reviews[index]['rating'],
                    date: reviews[index]['date'],
                    avatar: reviews[index]['avatar'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final double rating;
  final String date;
  final String avatar;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.rating,
    required this.date,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: AssetImage(avatar),
                radius: 20,
              ),
              SizedBox(width: 10),

              // ✅ Correction du bug avec Expanded
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow:
                      TextOverflow.ellipsis, // ✅ Coupe le texte si trop long
                  maxLines: 1,
                ),
              ),

              Text(
                date,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          SizedBox(height: 6),
          buildStarRating(rating),
          SizedBox(height: 6),
          Text(
            "Emily Jani exceeded my expectations! Quick, reliable, and fixed my plumbing issue with precision. Highly recommend.",
            style: TextStyle(fontSize: 11.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: const Color(0xFF0054A5), size: 18);
        } else if (index == fullStars && halfStar) {
          return Icon(Icons.star_half,
              color: const Color(0xFF0054A5), size: 18);
        } else {
          return Icon(Icons.star_border,
              color: const Color.fromARGB(255, 255, 255, 255), size: 18);
        }
      }),
    );
  }
}
