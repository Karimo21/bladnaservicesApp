import 'package:flutter/material.dart';
//import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bladnaservices/services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final int userId;
  final int contactId;
  final String contactRole;

  const ChatScreen({required this.userId, required this.contactId, required this.contactRole});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final SocketService socketService = SocketService();
  final ScrollController _scrollController = ScrollController(); // Scroll controller
  
  @override
  void initState() {
    super.initState();
    _fetchMessages(); // Fetch messages when the screen loads


    socketService.joinRoom(widget.userId); 
    socketService.setOnMessageReceived((data) {
      if ((data['sender_id'] == widget.userId && data['receiver_id'] == widget.contactId) ||
          (data['sender_id'] == widget.contactId && data['receiver_id'] == widget.userId)) {
            
    if (mounted) { // Check if widget is still mounted
      setState(() {
        messages.add({
          'text': data['message'],
          'time': data['time'],
          'isSent': data['sender_id'] == widget.userId,
        });
      });
   
    }
      }
    });
  
  }
    @override
  void dispose() {
    //socketService.dispose();
    _messageController.dispose();
     _scrollController.dispose();
    super.dispose();
  }

  // Fetch messages from the API
  Future<void> _fetchMessages() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/messages/${widget.userId}/${widget.contactId}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> fetchedMessages = json.decode(response.body);

    if (mounted) { // Check if widget is still mounted
      setState(() {
        messages = fetchedMessages.map((msg) {
          return {
            'text': msg['message'],
            'time': msg['message_time'] ?? 'No time',
            'isSent': msg['sender_id'] == widget.userId, // Determine if the message is sent by the current user
            
          };
        }).toList();
      });
    }
    } else {
      throw Exception('Failed to load messages');
    }
  }

    // Send a message to the API
  Future<void> _sendMessage() async {
  final String messageText = _messageController.text.trim();
  final DateTime now = DateTime.now();
  final String formattedTime = now.toIso8601String(); // ISO 8601 format: "yyyy-MM-ddTHH:mm:ss.sssZ"

  if (messageText.isEmpty) {
    return; // Don't send empty messages
  }

 if (mounted) { // Check if widget is still mounted
  setState(() {
    // Optionally add the message to the UI right away if you want it to appear immediately.
    messages.add({
      'text': messageText,
      'time': DateFormat('HH:mm').format(now),
      'isSent': true,
    });
  });
 
 }

  _messageController.clear(); // Clear the input field after sending

  // Emit the message to the server via Socket.IO
  socketService.sendMessage(widget.userId, widget.contactId, messageText, formattedTime);

  // Emit the 'updateContacts' event to notify the server that contacts should be updated
  socketService.socket.emit('updateContacts', {
  'contactId': widget.contactId,
  'role': widget.contactRole,
});
  
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0054A5)),
              onPressed: () {
              
              Navigator.pop(context);},
              iconSize: 35,
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Name",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 8.0, left: 10.0, bottom: 8.0),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.blue,
                  backgroundColor: Color(0xFF0054A5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Réserver",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: "Poppins",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          bool isSent = message['isSent'];
          return Align(
            alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSent ? const Color(0xFF0054A5) : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: isSent ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message['time'],
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      if (isSent) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller:_messageController,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: const TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: () async {
                   await _sendMessage(); // Send the message
              },
            ),
          ],
        ),
      ),
    );
  }
}
