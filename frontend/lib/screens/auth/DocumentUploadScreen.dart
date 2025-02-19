import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'password_screen.dart';
class DocumentUploadScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataUser;

  const DocumentUploadScreen({super.key, required this.dataUser});

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  Uint8List? _frontImage;
  Uint8List? _backImage;
  Uint8List? _diplomaImage;

  String? _frontError;
  String? _backError;
  String? _diplomaError;

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        Uint8List imageBytes = await pickedFile.readAsBytes(); // Read as Uint8List

        setState(() {
          if (type == "front") {
            _frontImage = imageBytes;
            widget.dataUser[0]["front_image"] = imageBytes;
            _frontError = null;
          } else if (type == "back") {
            _backImage = imageBytes;
            widget.dataUser[0]["back_image"] = imageBytes;
            _backError = null;
          } else if (type == "diploma") {
            _diplomaImage = imageBytes;
            widget.dataUser[0]["diploma_image"] = imageBytes;
            _diplomaError = null;
          }
        });
      } else {
        setState(() {
          if (type == "front") _frontError = "Veuillez sélectionner une image.";
          if (type == "back") _backError = "Veuillez sélectionner une image.";
          if (type == "diploma") _diplomaError = "Veuillez sélectionner une image.";
        });
      }
    } catch (e) {
      setState(() {
        if (type == "front") _frontError = "Erreur lors du chargement de l'image.";
        if (type == "back") _backError = "Erreur lors du chargement de l'image.";
        if (type == "diploma") _diplomaError = "Erreur lors du chargement de l'image.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>{
             widget.dataUser.clear(),
             Navigator.pop(context),}
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Documents",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF565656)),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("Importer votre carte nationale"),
              _buildSubtitle("Photo de l’avant"),
              _buildUploadButton(_frontImage, "front", _frontError),

              const SizedBox(height: 20),
              _buildSubtitle("Photo de l’arrière"),
              _buildUploadButton(_backImage, "back", _backError),

              const SizedBox(height: 24),
              _buildSectionTitle("Importer votre diplôme"),
              _buildUploadButton(_diplomaImage, "diploma", _diplomaError),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0054A5),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_frontImage == null) setState(() => _frontError = "Veuillez sélectionner une image.");
                    if (_backImage == null) setState(() => _backError = "Veuillez sélectionner une image.");
                    if (_diplomaImage == null) setState(() => _diplomaError = "Veuillez sélectionner une image.");

                    if (_frontImage != null && _backImage != null && _diplomaImage != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordScreen(dataUser: widget.dataUser)),
                      );
                    }
                  },
                  child: const Text(
                    "Suivant",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF565656)),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Text(
        subtitle,
        style: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }

  Widget _buildUploadButton(Uint8List? imageBytes, String type, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickImage(ImageSource.gallery, type),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                imageBytes != null
                    ? Image.memory(imageBytes, height: 100, fit: BoxFit.cover)
                    : const Icon(Icons.upload_file, color: Colors.blue, size: 30),
                const SizedBox(height: 8),
                const Text(
                  "Importer",
                  style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
