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
  final SocketService socketService = SocketService();
  int userId=User.userId;
    @override
  void initState() {
    super.initState();
    SocketService();
    socketService.joinRoom(User.userId);
    // Listen for new reservations
    socketService.setOnNewReservation((newReservation) {
    //if(newReservation['providerId'].toString()==User.userId){}
    if (mounted) {
      setState(() {
        print("✅ New reservation received: $newReservation"); // Debugging
        reservations.add({
          'id': newReservation['reservationId'].toString(),
          'client_id': newReservation['clientId'].toString(),
          'name': newReservation['client_name'].toString(),
          'start_date': newReservation['startDate'].toString(),
          'end_date': newReservation['endDate'].toString(),
          'status': newReservation['statut'].toString(),
          'city_name': newReservation['city_name'].toString(),
          'hour': newReservation['hour'].toString(),
          'address': newReservation['address'].toString(),
          'phone': newReservation['phone'].toString(),
          'profile_picture': newReservation['profile_picture'].toString(),
        });
      });
    }
    });

    fetchReservations();
  
  }
    Future<void> fetchReservations() async {

    if (!mounted) return;  
    final response = await http.get(Uri.parse('http://localhost:3000/api/reservations/reserved/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      
     if (!mounted) return;  
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
            'hour': item['hour'].toString(),
            'address': item['address'].toString(),
            'city_name': item['city_name'].toString(),
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
    
     if (reservations.isEmpty) {
      return const Center(child: Text("Aucune demande disponible"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(10),
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
