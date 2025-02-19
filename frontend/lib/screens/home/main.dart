import 'package:bladnaservices/screens/auth/login_screen.dart';
//import 'package:bladnaservices/screens/home/chat/chat_list_screen.dart';
//import 'package:bladnaservices/screens/home/chat/chat_screen.dart';
//import 'package:bladnaservices/screens/home/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:bladnaservices/services/socket_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SocketService(); // Initialiser le service de socket globalement
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
