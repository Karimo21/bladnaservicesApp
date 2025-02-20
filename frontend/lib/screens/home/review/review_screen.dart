import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int providerId = 2;
  List< dynamic> reviews = [
  ];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchReviews(); // Récupérer les avis dès le chargement de l'écran
  }

  Future<void> fetchReviews() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/provider-ratings/$providerId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            reviews = data;
          });

          print(reviews);
          print(data);
        }
      } else {
        throw Exception('Échec du chargement des avis.');
      }
    } catch (e) {
      print('Erreur : $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Avis",
          style: TextStyle(
              color: const Color(0xFF0054A5),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: const Color(0xFF0054A5), size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : reviews.isEmpty
                      ? Center(child: Text("Aucun avis disponible."))
                      : ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return ReviewCard(
                              name: reviews[index]['client_name'],
                              rating: reviews[index]['rating'],
                              date: reviews[index]['rating_time'],
                              avatar: 'frontend/assets/images7khalid.jpg',
                              feedback: reviews[index]['feedback'],
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
  final String feedback;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.rating,
    required this.date,
    required this.avatar,
    required this.feedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
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
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
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
            feedback,
            style: TextStyle(fontSize: 12.5, color: Colors.black87),
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
          return Icon(Icons.star_border, color: Colors.grey, size: 18);
        }
      }),
    );
  }
}
