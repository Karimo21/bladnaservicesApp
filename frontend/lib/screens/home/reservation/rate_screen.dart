import 'package:flutter/material.dart';

class RateScreen extends StatefulWidget {
  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int selectedStars = 0; // Default rating
  TextEditingController commentController = TextEditingController();
  bool showWarning = false;

  void submitReview() {
    if (selectedStars == 0) {
      setState(() {
        showWarning = true;
      });
    } else {
      setState(() {
        showWarning = false;
      });
      print("Rating: $selectedStars stars");
      print("Comment: ${commentController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0054A5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
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
            // Profile Card with Rectangle Image
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Container(
                height: 130,
                color: Colors.white,
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 90,
                        height: 130,
                        color: Colors.grey[300],
                        child: Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Hassan Rochdi",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Médecin - Agadir"),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Color(0xFF0054A5), size: 18),
                              Text(" 4.8"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Titre Évaluation
            Text(
              "Évaluer le dernier service",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF565656)),
            ),

            SizedBox(height: 10),

            // Star Rating System inside White Container
            Container(
              padding: EdgeInsets.symmetric(vertical: 16), // Add padding
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedStars ? Icons.star : Icons.star_border,
                      color: Color(0xFF0054A5), // Blue color for stars
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

            SizedBox(height: 20),

            // Comment Input
            Text(
              "Laissez un commentaire (optionnel)",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF565656)),
            ),
            SizedBox(height: 10),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Saisissez votre commentaire ici",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFFC5C6CC)), // Border color
                  
                ),
              ),
            ),

            SizedBox(height: 20),

            // Warning Message
            if (showWarning)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
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

            SizedBox(height: 20),

            // Submit Button (Bigger & Blue)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitReview,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18), // Bigger height
                  backgroundColor: Color(0xFF0054A5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text("Envoyer",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
