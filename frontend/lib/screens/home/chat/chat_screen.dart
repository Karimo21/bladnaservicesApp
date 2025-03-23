import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bladnaservices/services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final int userId;
  final int contactId;
  final String contactRole;
  final String profile_picture;
  final String name;

  const ChatScreen({
    required this.userId,
    required this.contactId,
    required this.contactRole,
    required this.profile_picture,
    required this.name,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final SocketService socketService = SocketService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    socketService.joinRoom(widget.userId);

    socketService.setOnMessageReceived((data) {
      if ((data['sender_id'] == widget.userId && data['receiver_id'] == widget.contactId) ||
          (data['sender_id'] == widget.contactId && data['receiver_id'] == widget.userId)) {
        if (mounted) {
          setState(() {
            messages.add({
              'text': data['message'],
              'time': data['formattedTime'],
              'isSent': data['sender_id'] == widget.userId,
            });
          });
          _scrollToBottom(); // Scroll to the bottom
        }
      }
    });
  }

  @override
  void dispose() {
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

      if (mounted) {
        setState(() {
          messages = fetchedMessages.map((msg) {
            return {
              'text': msg['message'],
              'time': msg['message_time'] ?? 'No time',
              'isSent': msg['sender_id'] == widget.userId,
            };
          }).toList();
        });
        _scrollToBottom(); // Scroll to the bottom after loading messages
      }
    } else {
      throw Exception('Failed to load messages');
    }
  }

  // Scroll to the bottom of the chat
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Send a message
  Future<void> _sendMessage() async {
    final String messageText = _messageController.text.trim();
    final DateTime now = DateTime.now();
    final String formattedTime = now.toIso8601String();

    if (messageText.isEmpty) return;

    if (mounted) {
      setState(() {
        messages.add({
          'text': messageText,
          'time': DateFormat('HH:mm').format(now),
          'isSent': true,
        });
      });
      _scrollToBottom(); // Scroll after adding the message
    }

    _messageController.clear();

    socketService.sendMessage(widget.userId, widget.contactId, messageText, formattedTime);

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
                
                socketService.markMessagesAsRead(widget.userId, widget.contactId);
                Navigator.pop(context);
              },
              iconSize: 35,
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(widget.profile_picture),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
          ),
          Container(
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
                      controller: _messageController,
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
                    await _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
