import 'package:bladnaservices/screens/auth/DocumentUploadScreen.dart';
import 'package:flutter/material.dart';

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

  void _onSubmit() {
    try {
      if (_formKey.currentState!.validate()) {
        widget.dataUser.add({
          "service": selectedService,
          "ville": selectedCity,
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
          onPressed: () => Navigator.pop(context),
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

              _buildDropdown(
                "Sélectionnez votre service",
                selectedService,
                ["Plomberie", "Électricité", "Ménage", "Jardinage"],
                (value) => setState(() => selectedService = value),
              ),

              const SizedBox(height: 20),

              _buildDropdown(
                "Sélectionnez votre ville",
                selectedCity,
                ["Agadir", "Casablanca", "Marrakech", "Rabat"],
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

  Widget _buildTextLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF565656))),
    );
  }
}
