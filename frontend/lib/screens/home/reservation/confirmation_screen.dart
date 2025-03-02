import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic>? reservationUtilisateur;

  ConfirmationScreen({Key? key, required this.reservationUtilisateur}) : super(key: key);

  final List<Map<String, dynamic>> prestataires = [
    {
      "nom": "Hassan Rochdi",
      "service": "Médecin",
      "ville": "Agadir",
      "image": "assets/images/logo.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> prestataire = prestataires[0];

    if (reservationUtilisateur == null) {
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
                              prestataire["nom"],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(prestataire["image"]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  _buildDetailRow("Service", prestataire["service"], true),
                  _buildDetailRow("Ville", prestataire["ville"], true),
                  _buildDetailRow("Date de début", reservationUtilisateur?["date_debut"]?.toString() ?? "Non spécifiée", true),
                  _buildDetailRow("Date de fin", reservationUtilisateur?["date_fin"]?.toString() ?? "Non spécifiée", true),
                  _buildDetailRow("Heure", reservationUtilisateur?["hour"]?.toString() ?? "Non spécifiée", true),
                  _buildDetailRow("Lieu de réservation", reservationUtilisateur?["address"]?.toString() ?? "Non spécifié", true),
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
      title: const Text("Confirmation", style: TextStyle(color: Color(0xFF0054A5))),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline, color: Color(0xFF0054A5), size: 24),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "Si le prestataire accepte votre demande, vous serez notifié(e).",
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
              debugPrint("Réservation confirmée !");
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
            child: const Text("Annuler", style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
