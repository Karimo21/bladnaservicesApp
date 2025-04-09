import 'dart:convert';
import 'package:bladnaservices/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bladnaservices/screens/auth/DocumentUploadScreen.dart';

class PrestataireSignupScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataUser;

  const PrestataireSignupScreen({super.key, required this.dataUser});

  @override
  _PrestataireSignupScreenState createState() => _PrestataireSignupScreenState();
}

class _PrestataireSignupScreenState extends State<PrestataireSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedServiceId;
  String? selectedCityId;
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
    final response = await http.get(Uri.parse('${Environment.apiHost}/cities'));
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
    final response = await http.get(Uri.parse('${Environment.apiHost}/services'));
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
          "service": selectedServiceId,
          "ville": selectedCityId,
          "adresse": addressController.text,
          "description": descriptionController.text,
        });
        
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
        appBar: AppBar(title: const Text("Erreur")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Une erreur est survenue", style: TextStyle(color: Colors.red, fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hasError = false;
                  });
                },
                child: const Text("Revenir"),
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            widget.dataUser.clear();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                selectedServiceId,
                services,
                'service_id',
                'title',
                (value) => setState(() => selectedServiceId = value),
              ),

              const SizedBox(height: 20),

              // Dropdown for cities
              _buildDropdown(
                "Sélectionnez votre ville",
                selectedCityId,
                cities,
                'city_id',
                'city_name',
                (value) => setState(() => selectedCityId  = value),
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
                    backgroundColor: const Color(0xFF0054A5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _onSubmit,
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

  // Build dropdown widget
Widget _buildDropdown(String label, String? selectedId, List<Map<String, dynamic>> items, String valueKey, String displayKey, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      value: selectedId,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item[valueKey].toString(), // Use ID as value
          child: Text(item[displayKey]),    // Display name
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Veuillez sélectionner une option" : null,
    ),
  );
}

  // Build text field widget
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        validator: (value) => value!.isEmpty ? "Ce champ ne peut pas être vide" : null,
      ),
    );
  }

  // Build text label widget
  Widget _buildTextLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF565656))),
    );
  }
}
