import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {

   final List<dynamic> reviews;
   const ReviewsScreen({super.key, required this.reviews});
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int providerId = 2;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.reviews); // Récupérer les avis dès le chargement de l'écran
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Avis",
          style: TextStyle(
              color: Color(0xFF0054A5),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color(0xFF0054A5), size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : widget.reviews.isEmpty
                      ? const Center(child: Text("Aucun avis disponible."))
                      : ListView.builder(
                          itemCount: widget.reviews.length,
                          itemBuilder: (context, index) {
                            return ReviewCard(
                              name: widget.reviews[index]['name'],
                              rating: widget.reviews[index]['rating'],
                              date: widget.reviews[index]['date'],
                              avatar: "${widget.reviews[index]['profileImage']}",
                              feedback: widget.reviews[index]['comment'],
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
    super.key,
    required this.name,
    required this.rating,
    required this.date,
    required this.avatar,
    required this.feedback,
  });

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
                backgroundImage: NetworkImage(avatar),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          buildStarRating(rating),
          const SizedBox(height: 6),
          Text(
            feedback,
            style: const TextStyle(fontSize: 12.5, color: Colors.black87),
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
          return const Icon(Icons.star, color: Color(0xFF0054A5), size: 18);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half,
              color: Color(0xFF0054A5), size: 18);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 18);
        }
      }),
    );
  }
}
