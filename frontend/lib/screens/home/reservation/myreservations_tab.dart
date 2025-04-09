import 'package:bladnaservices/env.dart';
import 'package:bladnaservices/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ReservationsTab
class ReservationsTab extends StatefulWidget {



  @override
  _ReservationsTabState createState() => _ReservationsTabState();
}

class _ReservationsTabState extends State<ReservationsTab> {
  List<Map<String, String>> reservations = [];
  final SocketService socketService = SocketService();
  String role=User.role; 
  int userId=User.userId; 

  @override
  void initState() {
    super.initState();
    SocketService();
    socketService.joinRoom(User.userId);
    socketService.setOnReservationUpdate((newReservation){
       print(User.userId);
       print("New reservation update: $newReservation");
       print(reservations);
       if (mounted) {
       setState(() {
           print("id: ${newReservation['reservationId']}");
           bool found = false;
           int reservationId = int.parse(newReservation['reservationId'].toString()); 
           String statutName = newReservation['statutName']; 
           print("id: $reservationId");
       for (var reservation in reservations) {
         print(int.tryParse(reservation['id'] ?? ''));
         if (int.tryParse(reservation['id'] ?? '') == reservationId) {
           reservation['status'] = statutName;
           found = true;
           break;
         }
       }
       if (!found) print("Aucune réservation trouvée pour $reservationId");
       if (found) print("réservation trouvée pour $reservationId");
       });
      
       }
    });

    _fetchReservations();
  }

  // Fetch reservations from the API
  Future<void> _fetchReservations() async {
    final url =
        '${Environment.apiHost}/api/reservations/reserving/$role/$userId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

      setState(() {
        reservations = List<Map<String, String>>.from(data['reservations'].map((item) {
          // Ensure that the values you're mapping are all strings
          return {
            'id': item['reservations_id'].toString(),
            'name': item['provider_name'].toString(),
            'start_date': '${item['start_date']}',
            'end_date': '${item['end_date']}',
            'phone': item['phone'].toString(),
            'status': item['status'].toString(),
            'hour': item['hour'].toString(),
             'city_name': item['city_name'].toString(),
            'address': item['address'].toString(),
            'profile_picture': item['profile_picture'].toString(),
          };
        }).toList()); 

        print(reservations);
   
      });
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      print('Error fetching reservations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return const Center(child: Text("Vous n'avez aucune réservation"));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return myReservationCard(data: reservations[index]);
      },
    );
  }
}

class myReservationCard extends StatelessWidget {
  final Map<String, String> data;
  const myReservationCard({required this.data});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${Environment.apiHost}${data['profile_picture']}"),
            ),
            title: Text(
              data["name"]!,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF565656),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade400),
          buildInfoRow("Date de début", data["start_date"]!),
          buildInfoRow("Date de fin", data["end_date"]!),
          buildInfoRow("Ville", data["city_name"]!),
          buildInfoRow("Lieu de réservation", data["address"]!),
          buildInfoRow("Heure", data["hour"]!),
          
          buildInfoRow(
            "Téléphone",
            data["phone"]!,
            isLink: true,
            color: const Color(0xFF0054A5),
            underline: true,
            underlineColor: Colors.green,
          ),
          buildInfoRow(
            "Statut",
            data["status"]!,
            isLink: true,
            color: const Color(0xFF0054A5),
            underline: data["status"] == "En attente",
            underlineColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value,
      {bool isLink = false,
      Color? color,
      bool underline = false,
      Color? underlineColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
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
                color: color ?? const Color(0xFF565656),
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
                decorationColor: underlineColor ?? const Color(0xFF0054A5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
