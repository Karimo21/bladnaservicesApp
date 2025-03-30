import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bladnaservices/screens/home/profile/User.dart';

class RateScreen extends StatefulWidget {
  final providerId;
  final profileImage;
  final providerName;
  final serviceName;
  final city;
  final rate;

  const RateScreen(
      {super.key,
      required this.providerId,
      this.providerName,
      this.serviceName,
      this.city,
      this.rate,
      this.profileImage});

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int selectedStars = 0; // Default rating
  TextEditingController commentController = TextEditingController();
  bool showWarning = false;
  int loggedUser = User.userId; // Replace with actual logged-in user ID

  // Function to send the rating to the backend API
  Future<void> submitReview() async {
    if (selectedStars == 0) {
      setState(() {
        showWarning = true;
      });
      return;
    }

    setState(() {
      showWarning = false;
    });

    const String apiUrl = 'http://localhost:3000/api/ratings'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "clientId": loggedUser, // Assuming `User.userId` is the client ID
          "providerId": widget.providerId,
          "rating": selectedStars,
          "feedback": commentController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully saved rating
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Évaluation envoyée avec succès!")),
        );
        Navigator.pop(context); // Close the screen
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'envoi de l'évaluation.")),
        );
      }
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de la connexion: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0054A5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Évaluez votre expérience",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Container(
                height: 130,
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 90,
                        height: 130,
                        color: Colors.grey[300],
                        child: widget.profileImage != null &&
                                widget.profileImage.isNotEmpty
                            ? Image.network(widget.profileImage, fit: BoxFit.cover)
                            : const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.providerName ?? "",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.serviceName ?? ""),
                          Text(widget.city ?? ""),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFF0054A5), size: 18),
                              Text(widget.rate.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Star Rating
            const Text(
              "Évaluer le dernier service",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF565656)),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedStars ? Icons.star : Icons.star_border,
                      color: const Color(0xFF0054A5),
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStars = index + 1;
                      });
                    },
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Comment Input
            const Text(
              "Laissez un commentaire (optionnel)",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF565656)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Saisissez votre commentaire ici",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFC5C6CC)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Warning Message
            if (showWarning)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "L'évaluation du dernier prestataire est obligatoire !",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitReview,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFF0054A5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text("Envoyer",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
