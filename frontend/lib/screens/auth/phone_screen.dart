import 'package:bladnaservices/screens/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneScreen extends StatefulWidget {
  final String role; // Rôle sélectionné (Client ou Prestataire)
  final List<Map<String, dynamic>> dataUser;

  const PhoneScreen({super.key, required this.role, required this.dataUser});

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage; // Variable pour stocker le message d'erreur


  
  void _sendCode() async  {
    String phoneNumber = _phoneController.text.trim();

    setState(() {
      _errorMessage = null; // Réinitialisation de l'erreur
    });

    // Vérification si le champ est vide
    if (phoneNumber.isEmpty) {
      _showError("Le numéro de téléphone est requis.");
      return;
    }

    // Vérification de la longueur et du format du numéro
    if (phoneNumber.length != 9 || (!phoneNumber.startsWith("6") && !phoneNumber.startsWith("7"))) {
      _showError("Entrez un numéro valide commençant par 6 ou 7 et ayant 9 chiffres.");
      return;
    }

    // Vérification si le numéro est déjà enregistré
    bool exists = widget.dataUser.any((user) => user["phone"] == "+212$phoneNumber");
    if (exists) {
      _showError("Ce numéro est déjà enregistré.");
      return;
    }

    // Ajouter le numéro à la liste dataUser
    List<Map<String, dynamic>> updatedDataUser = List.from(widget.dataUser);
    updatedDataUser.add({"phone": "+212$phoneNumber"});
        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerification(
          role: widget.role,
          dataUser: updatedDataUser,
        ),
      ),
    );

    // Make the API request to send OTP
  // final response = await http.post(
  //   Uri.parse('http://localhost:3000/send'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //   },
  //   body: jsonEncode({
  //     'phoneNumber': "+212$phoneNumber",  // Pass the phone number in the request body
  //   }),
  // );

  // // Check if the OTP was sent successfully
  // if (response.statusCode == 200) {
  //   // OTP sent successfully, navigate to OTP verification page
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => OTPVerification(
  //         role: widget.role,
  //         dataUser: updatedDataUser,
  //       ),
  //     ),
  //   );
  // } else {
  //   // If the OTP request failed, show the error
  //   _showError("Erreur lors de l'envoi du code OTP.");
  // }
  }

  // Fonction pour afficher un message d'erreur sous le TextField
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 40),
                child: Text(
                  "Entrez votre numéro de téléphone ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF565656),
                  ),
                ),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "+212",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  hintText: "6XXXXXXXX",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: _errorMessage != null ? Colors.red : Colors.grey),
                  ),
                  errorText: _errorMessage, // Affichage du message d'erreur sous le TextField
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0054A5),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: _sendCode,
                  child: const Text(
                    "Envoyer le code",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
