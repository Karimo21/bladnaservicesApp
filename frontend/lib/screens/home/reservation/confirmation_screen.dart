import 'package:bladnaservices/screens/home/main_screen.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic>? reservationUtilisateur;

  const ConfirmationScreen({super.key, required this.reservationUtilisateur});

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> createReservation() async {
    const String apiUrl = 'http://localhost:3000/create-reservation';

    final Map<String, dynamic> reservationData = {
      "role": User.role,
      "clientId": User.userId,
      "providerId": widget.reservationUtilisateur?['provider_id'],
      "startDate": widget.reservationUtilisateur?['date_debut'],
      "endDate": widget.reservationUtilisateur?['date_fin'],
      "address": widget.reservationUtilisateur?['address'],
      "hour": widget.reservationUtilisateur?['hour'],
      "statutId": 1
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reservationData),
      );

      if (response.statusCode == 200) {
        debugPrint("Réservation créée avec succès !");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Réservation confirmée avec succès !")));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false, // This removes all previous routes from the stack
        );
      } else {
        debugPrint("Échec de la création de la réservation : ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors de la confirmation !")));
      }
    } catch (e) {
      debugPrint("Erreur de connexion : $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Problème de connexion au serveur !")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reservationUtilisateur == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: const Center(child: Text("Aucune réservation disponible.")),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text("Résumé de la réservation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.reservationUtilisateur?['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            widget.reservationUtilisateur?['profile']),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  _buildDetailRow("Service",
                      widget.reservationUtilisateur?['profession'], true),
                  _buildDetailRow(
                      "Date de début",
                      widget.reservationUtilisateur?["date_debut"]
                              ?.toString() ??
                          "Non spécifiée",
                      true),
                  _buildDetailRow(
                      "Date de fin",
                      widget.reservationUtilisateur?["date_fin"]?.toString() ??
                          "Non spécifiée",
                      true),
                  _buildDetailRow(
                      "Heure",
                      widget.reservationUtilisateur?["hour"]?.toString() ??
                          "Non spécifiée",
                      true),
                  _buildDetailRow(
                      "Lieu de réservation",
                      widget.reservationUtilisateur?["address"]?.toString() ??
                          "Non spécifié",
                      true),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildCard(child: _buildInfoBox()),
            const SizedBox(height: 70),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Confirmation",
          style: TextStyle(color: Color(0xFF0054A5))),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0054A5)),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(String label, String value, bool boldValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: boldValue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:  [
        Icon(Icons.info_outline, color: Color(0xFF0054A5), size: 24),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            "Si vous avez confirmé la réservation, vous ne pourrez plus l'annuler",
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              createReservation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0054A5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Confirmer",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Annuler",
                style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
