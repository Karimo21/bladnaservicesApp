import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReservationsPage(),
    );
  }
}

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ClientsTab(),
    ReservationsTab(),
    HistoryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          "Réservations",
          style: TextStyle(
            color: Color(0xFF0054A5),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        backgroundColor: Color(0xFFF9F9F9),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF0054A5)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab("Demandes des clients", 0),
                  _buildTab("Mes réservations", 1),
                  _buildTab("Historique", 2),
                ],
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index ? Color(0xFF0054A5) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedIndex == index ||
                    _selectedIndex == 0 ||
                    _selectedIndex == 1 ||
                    _selectedIndex == 2
                ? const Color.fromARGB(255, 61, 61, 61)
                : const Color.fromARGB(255, 61, 61, 61),
            width: 0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : Color(0xFF565656),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class Reservation {
  final String? client_Name; // Nom du client (peut être null)
  final String startDate;
  final String endDate;
  final String phone;
  final String statut;

  Reservation({
    required this.client_Name,
    required this.startDate,
    required this.endDate,
    required this.phone,
    required this.statut,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      client_Name: json['client_name'] as String?, // Gérer les valeurs null
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      phone: json['phone'] as String,
      statut: json['statut'] as String,
    );
  }
}

class ReservationController {
  static const String apiUrl = 'http://localhost:3000/api/reservations';

  static Future<List<Reservation>> fetchReservations() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Décoder la réponse JSON
      final dynamic jsonResponse = json.decode(response.body);

      // Vérifier si la réponse est un objet ou une liste
      List<dynamic> reservationsJson;
      if (jsonResponse is List) {
        reservationsJson = jsonResponse;
      } else if (jsonResponse is Map && jsonResponse.containsKey('reservations')) {
        reservationsJson = jsonResponse['reservations'];
      } else {
        throw Exception('Format de réponse JSON non supporté');
      }

      // Convertir les données JSON en une liste d'objets Reservation
      return reservationsJson
          .map((data) => Reservation.fromJson(data))
          .toList();
    } else {
      throw Exception('Échec du chargement des réservations');
    }
  }
}

class ClientsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      future: ReservationController.fetchReservations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucune réservation trouvée'));
        } else {
          final reservations = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ReservationCard(data: {
                "client_name":
                    "${reservation.client_Name} demande", // Passer le nom du client
                "start_date": reservation.startDate,
                "end_date": reservation.endDate,
                "phone": reservation.phone,
                "statut": reservation.statut,
              });
            },
          );
        }
      },
    );
  }
}

class ReservationCard extends StatelessWidget {
  final Map<String, String?> data; // Permettre des valeurs null
  ReservationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            title: Text(
              data["client_name"] ?? "Nom non disponible", // Valeur par défaut si null
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF565656),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade400),
          buildInfoRow("Date de Réservation", data["start_date"] ?? "N/A"),
          buildInfoRow("Date de Fin", data["end_date"] ?? "N/A"),
          buildInfoRow(
            "Téléphone",
            data["phone"] ?? "N/A",
            isLink: true,
            color: Color(0xFF0054A5),
            underline: true,
          ),
          buildInfoRow(
            "Statut",
            data["statut"] ?? "N/A",
            isLink: true,
            color: Color(0xFF0054A5),
            underline: true,
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF0054A5), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                ),
                onPressed: () {},
                child: Text(
                  "Refuser",
                  style: TextStyle(color: Color(0xFF0054A5), fontSize: 20),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF0054A5), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                ),
                onPressed: () {},
                child: Text(
                  "Accepter",
                  style: TextStyle(color: Color(0xFF0054A5), fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value,
      {bool isLink = false, Color? color, bool underline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF565656)),
          ),
          GestureDetector(
            onTap: isLink ? () {} : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color ?? Color(0xFF565656),
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      future: ReservationController.fetchReservations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucune réservation trouvée'));
        } else {
          final reservations = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ReservationCard(data: {
                "client_name":
                    reservation.client_Name, // Passer le nom du client
                "start_date": reservation.startDate,
                "end_date": reservation.endDate,
                "phone": reservation.phone,
                "statut": reservation.statut,
              });
            },
          );
        }
      },
    );
  }
}

class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      future: ReservationController.fetchReservations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucune réservation trouvée'));
        } else {
          final reservations = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ReservationCard(data: {
                "client_name":
                    reservation.client_Name, // Passer le nom du client
                "start_date": reservation.startDate,
                "end_date": reservation.endDate,
                "phone": reservation.phone,
                "statut": reservation.statut,
              });
            },
          );
        }
      },
    );
  }
}