//import 'package:bladnaservices/screens/home/profile/editProfil_screen.dart';
//import 'package:bladnaservices/screens/home/profile/profil_screen.dart';

import 'package:bladnaservices/screens/home/map/map_screen.dart';
import 'package:bladnaservices/screens/home/notification/notification_screen.dart';
import 'package:bladnaservices/screens/home/profile/addImage_screen.dart';
import 'package:bladnaservices/screens/home/profile/editProfil_screen.dart';
import 'package:bladnaservices/screens/home/profile/profil_screen.dart';
import 'package:bladnaservices/screens/home/reservation/reservation_screen.dart';
import 'package:bladnaservices/screens/home/review/review_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReviewsScreen(),
    );
  }
}
