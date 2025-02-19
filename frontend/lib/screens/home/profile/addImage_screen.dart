import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Détecter si l'application tourne sur Web
import 'dart:ui' as ui;

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  List<dynamic> _images = []; // Peut contenir File (mobile) ou Uint8List (Web)

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        // Web : Utiliser Uint8List
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _images.add(bytes);
        });
      } else {
        // Mobile (Android/iOS) : Utiliser File
        setState(() {
          _images.add(File(pickedFile.path));
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Définit le fond en blanc
      appBar: AppBar(
        title: Text(
          'Ajouter les images',
          style: TextStyle(
             color: Color(0xFF0054A5),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
                color: Color(0xFF0054A5), size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ..._images.asMap().entries.map((entry) {
                    int index = entry.key;
                    var image = entry.value;

                    return Stack(
                      children: [
                        Container(
                          height: 200,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: kIsWeb
                                ? Image.memory(image,
                                    fit: BoxFit.cover, width: double.infinity)
                                : Image.file(image,
                                    fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(0),
                              child: Icon(Icons.delete,
                                  color: Colors.red, size: 26),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),

                  // Zone de sélection d'image avec bordure en pointillés
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: CustomPaint(
                      painter:
                          DashedBorderPainter(), // Bordure pointillée du rectangle
                      child: Container(
                        height: 204,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Container(
                          width: 40, // Taille du cercle
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Fond du cercle
                            border: Border.all(
                              color: const Color.fromARGB(255, 4, 73, 130),
                              width: 2, // Bordure normale du cercle
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.add,
                                color: const Color.fromARGB(255, 4, 73, 130),
                                size: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe pour dessiner une bordure en pointillés
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 6, 71, 124) // Couleur de la bordure
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 10, dashSpace = 5, startX = 0;
    final double height = size.height;
    final double width = size.width;

    // Dessiner la bordure en pointillés sur chaque côté du rectangle
    while (startX < width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < height) {
      canvas.drawLine(
        Offset(width, startY),
        Offset(width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startX = width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, height),
        Offset(startX - dashWidth, height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    startY = height;
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
