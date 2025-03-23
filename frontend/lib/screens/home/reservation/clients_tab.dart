import 'package:bladnaservices/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'reservation_screen.dart';

class ClientsTab extends StatefulWidget  {
    @override
  _ClientsTabState createState() => _ClientsTabState();
}
  class _ClientsTabState extends State<ClientsTab> {
  List<Map<String, String>> reservations = [];
  bool isLoading = true;
  int userId=User.userId;
    @override
  void initState() {
    super.initState();

  // Join the socket room for live updates
  SocketService().joinRoom(userId);
  
  // Listen for new reservations
  SocketService().setOnNewReservation((newReservation) {
    setState(() {
      reservations.add(newReservation); // Update list dynamically
    });
  });

    fetchReservations();
  
  }
    Future<void> fetchReservations() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/reservations/reserved/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
     
      setState(() {
        reservations = List<Map<String, String>>.from(data['reservations'].map((item) {
          // Ensure that the values you're mapping are all strings
          return {
            'id': item['reservations_id'].toString(),
            'client_id': item['client_id'].toString(),
            'name': item['client_name'].toString(),
            'start_date': '${item['start_date']}',
            'end_date': '${item['end_date']}',
            'status': item['status'].toString(),
            'phone': item['phone'].toString(),
            'profile_picture': item['profile_picture'].toString(),
          };
        }).toList()); 
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

    void removeReservation(int index) {
    setState(() {
      reservations.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        print(reservations[index]);
        return ReservationCard(
          key: ValueKey(reservations[index]['id']), 
          data: reservations[index],
          onRemove: () => removeReservation(index));
      },
    );
  }
}
