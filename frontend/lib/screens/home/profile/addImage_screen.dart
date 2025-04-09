import 'dart:convert';
import 'package:bladnaservices/env.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Detect if the app is running on Web

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final List<dynamic> _images = []; // List for images to upload (File or Uint8List)
  List<Map<String, dynamic>> _fetchedImages = []; // List for fetched image URLs
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchImages(); // Load the images on init
    print(_fetchedImages);
  }

  String getMediaType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream'; // Default for unknown types
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      print("Image sélectionnée : ${pickedFile.path}");
      if (kIsWeb) {
        try {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _images
                .add(Uint8List.fromList(bytes)); // Add Web images as Uint8List
          });
        } catch (e) {
          print("Erreur lors de la lecture du fichier : $e");
        }
      } else {
        setState(() {
          _images.add(File(pickedFile.path)); // Add mobile images as File
        });
      }
      _uploadImages();
    }
  }

  Future<void> _fetchImages() async {
    try {
      final response = await http.get(Uri.parse(
          '${Environment.apiHost}/providers-work-images/${User.userId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List images = data['images'];
        print(images);

        if (mounted) {
          setState(() {
            _fetchedImages = images
                .map((image) => {
                      'id': image['id'],
                      'image_url': '${Environment.apiHost}${image['image_url']}'
                    })
                .toList();
          });
        }
      } else {
        throw Exception('Échec du chargement des images');
      }
    } catch (e) {
      print('Erreur lors du chargement des images: $e');
    }
  }

  Future<void> _uploadImages() async {
    if (_images.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    var uri = Uri.parse(
        "${Environment.apiHost}/upload-provider-images/${User.userId}");
    var request = http.MultipartRequest('POST', uri);
    // Upload only the new images (not the fetched URLs)
    for (var image in _images) {
      if (image is File) {
        final mediaType = getMediaType(image.path);
        print("Adding image file: ${image.path} with media type: $mediaType");
        request.files.add(
          await http.MultipartFile.fromPath(
            'work_images', // Ensure this matches the backend expected parameter
            image.path,
            contentType: MediaType.parse(mediaType),
          ),
        );
      } else if (image is Uint8List) {
        const mediaType = 'image/jpeg'; // Default for web images
        print("Adding image from Uint8List with media type: $mediaType");

        request.files.add(
          http.MultipartFile.fromBytes(
            'work_images',
            image,
            filename: 'upload.jpg',
            contentType: MediaType.parse(mediaType),
          ),
        );
      }
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print("Images uploaded successfully!");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed")),
        );
      }
    } catch (e) {
      print("Error during upload: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error uploading images")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _deleteImage(int imageId) async {
    // Extract the image ID from the URL (assuming it's at the end of the URL)
    
    final url = '${Environment.apiHost}/delete-provider-image/$imageId';
    print(url);
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        // Successfully deleted, now remove from the list
 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete image')),
        );
      }
    } catch (e) {
      print('Error during delete: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting image')),
      );
    }
  }

void _removeFetchedImage(int id) {
  setState(() {
    _fetchedImages.removeWhere((image) => image['id'] == id);
    _deleteImage(id);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ajouter les images',
          style: TextStyle(
              color: Color(0xFF0054A5),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0054A5), size: 22),
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
                  // Display fetched images with delete button
                  ..._fetchedImages.map((image) {
                    return Stack(
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Image.network(image['image_url'],
                              fit: BoxFit.cover, width: double.infinity),
                        ),
                        Positioned(
                          top: 5,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => _removeFetchedImage(image['id'],),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(0),
                              child: const Icon(Icons.delete,
                                  color: Colors.red, size: 26),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  // Display uploaded images with delete button
                  ..._images.asMap().entries.map((entry) {
                    int index = entry.key;
                    var image = entry.value;
                    return Stack(
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: kIsWeb
                              ? (image is Uint8List
                                  ? Image.memory(image,
                                      fit: BoxFit.cover, width: double.infinity)
                                  : Image.network(image,
                                      fit: BoxFit.cover,
                                      width: double.infinity))
                              : (image is Uint8List
                                  ? Image.memory(image,
                                      fit: BoxFit.cover, width: double.infinity)
                                  : Image.file(image,
                                      fit: BoxFit.cover,
                                      width: double.infinity)),
                        ),
                        Positioned(
                          top: 5,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(0),
                              child: const Icon(Icons.delete,
                                  color: Colors.red, size: 26),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  // Add new image button
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                        height: 204,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: const Color.fromARGB(255, 4, 73, 130),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.add,
                                color: Color.fromARGB(255, 4, 73, 130),
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

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 6, 71, 124)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 10, dashSpace = 5, startX = 0;
    final double height = size.height;
    final double width = size.width;

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

