import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
   int userId=User.userId;

  

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/notifications/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          notifications = List<Map<String, dynamic>>.from(data['notifications']);
        });
      } else {
        throw Exception("Erreur de chargement des notifications.");
      }
    } catch (e) {
      print("Erreur: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      
      await http.put(
        Uri.parse('http://localhost:3000/api/notifications/:userId'),
      );
      setState(() {
        notifications = notifications.map((notif) {
          if (notif['notifications_id'] == notificationId) {
            notif['is_read'] = 1;
          }
          return notif;
        }).toList();
      });
    } catch (e) {
      print("Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0054A5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text("Aucune notification disponible."))
              : ListView.builder(
                  padding: const EdgeInsets.all(.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return _buildNotificationItem(
                    
                      message: notif['message'],
                      date: notif['date'],
                      isRead: notif['is_read'] == 1,
                      onTap: () => markNotificationAsRead(notif['notifications_id']),
                    );
                  },
                ),
    );
  }

  Widget _buildNotificationItem({
    required String message,
    required String date,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: isRead ? Colors.grey[200] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
Row(
  children: [
  
    const SizedBox(width: 12), // Espacement entre l'image et le texte
    Expanded(
      child: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
    ),
  ],
),
const SizedBox(height: 4), // Espacement entre le message et la date
Align(
  alignment: Alignment.bottomRight,
  child: Text(
    date,
    style: const TextStyle(fontSize: 12, color: Colors.grey),
  ),
)
            ],
          ),
        ),
      ),
    );
  }
}
