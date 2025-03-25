import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bladnaservices/screens/auth/DocumentUploadScreen.dart';

class PrestataireSignupScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataUser;

  PrestataireSignupScreen({Key? key, required this.dataUser}) : super(key: key);

  @override
  _PrestataireSignupScreenState createState() => _PrestataireSignupScreenState();
}

class _PrestataireSignupScreenState extends State<PrestataireSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedService;
  String? selectedCity;
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool hasError = false;

  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> services = [];

  // Fetch data from the APIs
  @override
  void initState() {
    super.initState();
    fetchCities();
    fetchServices();
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
      setState(() {
        hasError = true;
      });
    }
  }

  // Fetch services from the API
  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse('http://localhost:3000/services'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        services = List<Map<String, dynamic>>.from(data['services']);
      });
    } else {
      setState(() {
        hasError = true;
      });
    }
  }

  // Submit form data
  void _onSubmit() {
    try {
      if (_formKey.currentState!.validate()) {
        widget.dataUser.add({
          "service": selectedService,
          "ville": selectedCity,
          "adresse": addressController.text,
          "description": descriptionController.text,
        });

        print(widget.dataUser);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentUploadScreen(dataUser: widget.dataUser),
          ),
        );
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: Text("Erreur")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Une erreur est survenue", style: TextStyle(color: Colors.red, fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hasError = false;
                  });
                },
                child: Text("Revenir"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            widget.dataUser.clear();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Offre de service",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF565656)),
              ),
              const SizedBox(height: 24),

              // Dropdown for services
              _buildDropdown(
                "Sélectionnez votre service",
                selectedService,
                services.map((service) => service['title'] as String).toList(),
                (value) => setState(() => selectedService = value),
              ),

              const SizedBox(height: 20),

              // Dropdown for cities
              _buildDropdown(
                "Sélectionnez votre ville",
                selectedCity,
                cities.map((city) => city['city_name'] as String).toList(),
                (value) => setState(() => selectedCity = value),
              ),

              const SizedBox(height: 20),
              _buildTextLabel("Saisir votre adresse"),
              _buildTextField(addressController, "Adresse"),

              const SizedBox(height: 20),
              _buildTextLabel("Saisissez une petite description de vous"),
              _buildTextField(descriptionController, "Décrivez-vous brièvement...", maxLines: 5),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0054A5),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _onSubmit,
                  child: Text(
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

  // Build dropdown widget
  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        value: value,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? "Veuillez sélectionner une option" : null,
      ),
    );
  }

  // Build text field widget
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        validator: (value) => value!.isEmpty ? "Ce champ ne peut pas être vide" : null,
      ),
    );
  }

  // Build text label widget
  Widget _buildTextLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF565656))),
    );
  }
}
