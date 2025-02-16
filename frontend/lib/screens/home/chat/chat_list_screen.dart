import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:bladnaservices/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bladnaservices/screens/home/chat/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  int loggeduserId = User.userId;
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<dynamic> contacts = []; // Store contacts data
  bool isLoading = true; // Loading state
  // Initialize SocketService
  SocketService socketService = SocketService();

  // Function to fetch contacts
  Future<void> fetchContacts() async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });

      String url = '';
      
      if (User.role == "client") {
        url = 'http://localhost:3000/api/client-contacts/${User.userId}';
      } else if (User.role == "provider") {
        url = 'http://localhost:3000/api/provider-contacts/${User.userId}';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

      if (mounted) {
        setState(() {
          contacts = data;
         
        });
      }
      } else {
        throw Exception('Failed to load contacts');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchContacts(); // Fetch contacts when the screen is initialized
    // Listen to live updates on contacts
    socketService.joinRoom(widget.loggeduserId); 

    socketService.setOnContactsUpdated((updatedContacts) {

     if (mounted) { 
      setState(() {
        contacts = updatedContacts; // Update the contacts list when there's a new event
        print(updatedContacts);
      });
     }
        


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Messages",
            style: TextStyle(
              color: Color(0xFF565656),
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow from AppBar
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search TextField with Shadow
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 2), // x=0, y=2
                    blurRadius: 8,
                    spreadRadius: 0, // Shadow spread
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Recherche...",
                  hintStyle: const TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none, // Removes the border line
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          // Chat list or Loading Indicator
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue, // Customize color
                    ),
                  )
                : ListView.builder(
                    itemCount: contacts.length, // Use the length of contacts
                    itemBuilder: (context, index) {
                      final contact = contacts[index]; // Get the current contact
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300], // Placeholder color
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ), // Placeholder icon
                        ),
                        title: Text(
                          contact['contact_name'], // Display the business name
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      
                        subtitle: Text(
                          contact['last_message'] ?? "Aucun message", // Add a dynamic subtitle
                          
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                trailing: contact['unread_message_count'] > 0
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor:const Color(0xFF0054A5), // Blue circle for unread count
                            child: Text(
                              contact['unread_message_count'].toString(),
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
                        onTap: () {

                          socketService.markMessagesAsRead(widget.loggeduserId, contact['contact_user_id']);
                          fetchContacts();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    userId: widget.loggeduserId,
                                    contactId: contact['contact_user_id'],
                                    contactRole: contact['role'])),
                                    
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
