import 'dart:convert';

import 'package:bladnaservices/screens/home/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:bladnaservices/screens/home/profile/User.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

const Color primaryColor = Color(0xFF0054A5);
const Color backgroundColor = Color(0xFFF9F9F9);

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  Uint8List? _webImage; // Variable pour stocker l'image sur Web
  List<Map<String, dynamic>> cities = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String firstname = User.fname;
  String lastname = User.lname;
  String address = User.adresse;
  String city = User.city.toString(); 
  String description = User.description;
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
      print("first");
      _uploadProfilePicture(); // Call the upload function
      print("third");
    }
  }

  Future<void> _uploadProfilePicture() async {
    print("second");

    // Check for selected image (mobile) or web image
    if (_selectedImage == null && _webImage == null) {
      print("No image selected.");
      return;
    }

    var uri = Uri.parse("http://localhost:3000/profile/picture"); // API URL
    var request = http.MultipartRequest('POST', uri);

    // For mobile: Add the image from file system
    if (_selectedImage != null) {
      final mediaType = getMediaType(_selectedImage!.path);
      request.files.add(
        await http.MultipartFile.fromPath('profile_image', _selectedImage!.path,
            contentType: MediaType.parse(mediaType)),
      );
    }

    // For web: Add the image as bytes (base64 or raw bytes)
    if (_webImage != null) {
      const mediaType = 'image/jpeg'; // Default MIME type for web images
      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_image',
          _webImage!,
          filename: 'profile_image.jpg', // Adjust the filename if needed
          contentType: MediaType.parse(mediaType),
        ),
      );
    }

    // Add user data (e.g., userId, role)
    request.fields['userId'] = User.userId.toString();
    request.fields['role'] = User.role;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print("Upload successful!");
        final responseString = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseString);
        setState(() {
          User.profile = jsonResponse['profileImageUrl'];
        });

        // Update UI or handle success
      } else {
        print("Upload failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error uploading image: $e");
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
      _submitProfileEdit();
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

  Future<void> _submitProfileEdit() async {
    // Construct the API URL using the User's ID
    var url = Uri.parse("http://localhost:3000/profile-edit/${User.userId}");
    print(url);
    // Prepare the data to be sent to the API
    Map<String, dynamic> requestData = {
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'city': city,
      'description': description,
      'role': User.role,
    };
    try {
      // Send the POST request with the JSON-encoded body
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestData),
      );
      // Check if the request was successful
      if (response.statusCode == 200) {
        User.fname = firstname;
        User.lname = lastname;
        User.adresse = address;
        User.description = description;
        User.city=int.parse(city);
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 4)),
      (route) => false, // This removes all previous routes from the stack
     );
        // Optionally, parse the response body
      
      } else {
  
      }
    } catch (e) {
      print("Error while updating profile: $e");
    }
  }

   // Fetch cities from the API
  Future<void> fetchCities() async {
    final response = await http.get(Uri.parse('http://localhost:3000/cities'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        cities = List<Map<String, dynamic>>.from(data['cities']);
      });
    } else {
    }
  }
  @override
  void initState() {
    super.initState();
    fetchCities();
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
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: primaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Éditer le profil",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: NetworkImage(
                              "http://localhost:3000${User.profile}"),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage, // Ouvre la galerie au clic
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
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
                  const SizedBox(height: 24),
                  ProfileTextField(
                    label: "Prénom",
                    hintText: firstname,
                    controller: firstnameController,
                    focusNode: firstnameFocusNode,
                    onChanged: (value) => _onFieldChanged(value, 'firstname'),
                    errorText: firstnameError
                        ? "Veuillez entrer un prénom valide"
                        : null,
                  ),
                  ProfileTextField(
                    label: "Nom",
                    hintText: lastname,
                    controller: lastnameController,
                    focusNode: lastnameFocusNode,
                    onChanged: (value) => _onFieldChanged(value, 'lastname'),
                    errorText:
                        lastnameError ? "Veuillez entrer un nom valide" : null,
                  ),
                  ProfileTextField(
                    label: "Adresse",
                    hintText: address,
                    controller: addressController,
                    focusNode: addressFocusNode,
                    onChanged: (value) => _onFieldChanged(value, 'address'),
                    errorText:
                        addressError ? "Veuillez entrer une adresse" : null,
                  ),
            
  DropdownButtonFormField<String>(
  value: city, // Valeur sélectionnée par défaut
  decoration: const InputDecoration(
    labelText: "Ville",
    border: OutlineInputBorder(),
  ),
  items: cities.map<DropdownMenuItem<String>>((cityData) {
    print(cityData);
    return DropdownMenuItem<String>(
      value: cityData["city_id"].toString(),
      child: Text(cityData['city_name']),
    );
  }).toList(),
  onChanged: (newValue) {
    setState(() {
      city = newValue!;
    });
  },
),

                  if (User.role == "provider")
                    ProfileDescription(
                      label: "description",
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                      onChanged: (value) =>
                          _onFieldChanged(value, 'description'),
                      errorText: descriptionError
                          ? "Veuillez entrer une description"
                          : null,
                    ),
                  const SizedBox(height: 20),
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
                        child: const Text(
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

  const ProfileTextField({
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
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
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
        const SizedBox(height: 16),
      ],
    );
  }
}

class ProfileDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final Function(String?) onChanged;

  const ProfileDropdown(
      {required this.label, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
            hint: const Text("Sélectionner une ville"),
            underline: const SizedBox(),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
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

  const ProfileDescription({
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
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: User.description,
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
