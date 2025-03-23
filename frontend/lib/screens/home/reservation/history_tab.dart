import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bladnaservices/screens/home/profile/User.dart';

class HistoryTab extends StatefulWidget {


  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<Map<String, String>> reservations = [];
  bool isLoading = true;
   String role=User.role;
   int userId=User.userId;

  @override
  void initState() {
    super.initState();
    fetchReservationsHistory();
  }

  Future<void> fetchReservationsHistory() async {
    final String apiUrl =
        "http://localhost:3000/api/reservations/history/$role/$userId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          reservations = List<Map<String, String>>.from(
            data['reservations'].map((item) {
              return {
                'id': item['reservations_id']?.toString() ?? '',
                'name': role == "client"
                    ? item["provider_name"].toString()
                    : item["reserver_name"].toString(),
                'start_date': '${item['start_date']}',
                'end_date': '${item['end_date']}',
                'status': item['status'].toString(),
                'phone': item['phone']?.toString() ?? 'N/A',
                'profile_picture': item['profile_picture'].toString(),
              };
            }).toList(),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reservation history');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (reservations.isEmpty) {
      return Center(child: Text("No history available"));
    }

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return HistoryCard(data: reservations[index]);
      },
    );
  }
}

class HistoryCard extends StatelessWidget {
  final Map<String, String> data;

  HistoryCard({required this.data});

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
              backgroundImage: NetworkImage("http://localhost:3000${data['profile_picture']}"),
            ),
            title: Text(
              data["name"]!,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF565656),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade400),
          buildInfoRow("Date de début", data["start_date"]!),
          buildInfoRow("Date de fin", data["end_date"]!),
          buildInfoRow("Téléphone", data["phone"]!),
          buildInfoRow(
            "Statut",
            data["status"]!,
            isLink: true,
            color: Color(0xFF0054A5),
            underline: data["status"] == "Terminé",
            underlineColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value,
      {bool isLink = false, Color? color, bool underline = false, Color? underlineColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF565656)),
          ),
          GestureDetector(
            onTap: isLink ? () {} : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color ?? Color(0xFF565656),
                decoration: underline ? TextDecoration.underline : TextDecoration.none,
                decorationColor: underlineColor ?? Color(0xFF0054A5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
