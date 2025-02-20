import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'dart:io';
import 'dart:typed_data';


const Color primaryColor = Color(0xFF0054A5);
const Color backgroundColor = Color(0xFFF9F9F9);

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  Uint8List? _webImage; // Variable pour stocker l'image sur Web

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String firstname = User.fname;
  String lastname = User.lname;
  String address = '';
  String city = '';
  String description = '';
  bool isSubmitted = false;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode firstnameFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  bool firstnameError = false;
  bool lastnameError = false;
  bool cityError = false;
  bool addressError = false;
  bool descriptionError = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print("Image selected: ${pickedFile.path}"); // Debug
      if (kIsWeb) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _validateAndSave() {
    setState(() {
      isSubmitted = true;
      firstnameError = firstname.isEmpty;
      lastnameError = lastname.isEmpty;
      addressError = address.isEmpty;
      descriptionError = description.isEmpty;
    });

    if (_formKey.currentState!.validate()) {
      // Save logic goes here
    }
  }

  void _onFieldChanged(String value, String fieldName) {
    setState(() {
      if (fieldName == 'firstname') {
        firstname = value;
        firstnameError = value.isEmpty;
      } else if (fieldName == 'lastname') {
        lastname = value;
        lastnameError = value.isEmpty;
      } else if (fieldName == 'address') {
        address = value;
        addressError = value.isEmpty;
      } else if (fieldName == 'description') {
        description = value;
        descriptionError = value.isEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Éditer le profil",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: NetworkImage("http://localhost:3000" + User.profile),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage, // Ouvre la galerie au clic
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  ProfileTextField(
                    label: "Prénom",
                    hintText: "Prénom",
                    controller: firstnameController,
                    focusNode: firstnameFocusNode,
                    onChanged: (value) => _onFieldChanged(value, 'firstname'),
                    errorText: firstnameError ? "Veuillez entrer un prénom valide" : null,
                  ),
                  ProfileTextField(
                    label: "Nom",
                    hintText: "Nom",
                    controller: lastnameController,
                    focusNode: lastnameFocusNode,
                    onChanged: (value) => _onFieldChanged(value, 'lastname'),
                    errorText: lastnameError ? "Veuillez entrer un nom valide" : null,
                  ),
                  ProfileTextField(
                    label: "Adresse",
                    hintText: "Adresse",
                    controller: addressController,
                    focusNode: addressFocusNode,
                    onChanged: (value) => _onFieldChanged(value, 'address'),
                    errorText: addressError ? "Veuillez entrer une adresse" : null,
                  ),
                  ProfileDropdown(
                    label: "Ville",
                    items: ["Agadir", "Casablanca", "Rabat"],
                    onChanged: (value) {
                      setState(() {
                        city = value!;
                        cityError = city.isEmpty;
                      });
                    },
                  ),
                  ProfileDescription(
                    label: "Description",
                    controller: descriptionController,
                    focusNode: descriptionFocusNode,
                    onChanged: (value) => _onFieldChanged(value, 'description'),
                    errorText: descriptionError ? "Veuillez entrer une description" : null,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: _validateAndSave,
                        child: Text(
                          "Enregistrer",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final String? errorText;

  ProfileTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class ProfileDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final Function(String?) onChanged;

  ProfileDropdown(
      {required this.label, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              width: 1, // Bold border width
            ),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            onChanged: onChanged,
            hint: Text("Sélectionner une ville"),
            underline: SizedBox(),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class ProfileDescription extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final String? errorText;

  ProfileDescription({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Entrez une description",
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
