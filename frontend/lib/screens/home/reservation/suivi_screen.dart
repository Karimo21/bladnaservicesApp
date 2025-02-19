import 'package:flutter/material.dart';

class SuiviScreen extends StatelessWidget {
  const SuiviScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi'),
      ),
      body: const Center(
        child: Text('Acceuil Screen'),
      ),
    );
  }
}
