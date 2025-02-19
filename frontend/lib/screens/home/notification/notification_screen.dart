import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0054A5); // Nouvelle couleur

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // ✅ Fond gris clair pour l'écran
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Color(0xFF0054A5),
            fontWeight: FontWeight.bold,
            
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationItem(
              image: "assets/user.png",
              message: "Hassan rochdi a confirmé votre réservation",
              date: "1 min",
            ),
            _buildNotificationItem(
              image: "assets/user.png",
              message: "Hassan rochdi a confirmé votre réservation",
              date: "15 min",
            ),
            _buildNotificationItem(
              image: "assets/user.png",
              message: "Hassan rochdi a confirmé votre réservation",
              date: "2 mois",
            ),
            _buildNotificationItem(
              image: "assets/user.png",
              message: "Hassan rochdi a confirmé votre réservation",
              date: "1 min",
            ),
            _buildNotificationItem(
              image: "assets/user.png",
              message: "Hassan rochdi a confirmé votre réservation",
              date: "15 min",
            ),
            _buildNotificationItem(
              image: "assets/user.png",
              message: "Hassan rochdi a confirmé votre réservation",
              date: "2 mois",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String image,
    required String message,
    required String date,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // ✅ Radius 8px
      color: Colors.white, // ✅ Fond blanc pour chaque notification
      child: Padding(
        padding: const EdgeInsets.all(12), // ✅ Ajustement de l'espacement interne
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ Alignement en haut pour les éléments
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 22, // ✅ Ajusté pour ressembler à l'exemple
            ),
            const SizedBox(width: 12), // ✅ Espacement entre l'image et le texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4), // ✅ Petit espacement avant la date
                  Align(
                    alignment: Alignment.bottomRight, // ✅ Alignement bas-droit
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
