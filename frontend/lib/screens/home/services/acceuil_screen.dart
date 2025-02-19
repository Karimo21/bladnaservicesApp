import 'package:flutter/material.dart';

class AcceuilScreen extends StatelessWidget {
  const AcceuilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceuil'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Acceuil'),
            SizedBox(height: 20),
            // Display image from the server
            Image.network("http://localhost:3000/uploads/profile_pictures/test1.png"),
          ],
        ),
    );
  }
}
