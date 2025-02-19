import 'package:bladnaservices/screens/auth/PrestataireSignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:bladnaservices/screens/auth/password_screen.dart';

class OTPVerification extends StatefulWidget {
  final List<Map<String, dynamic>> dataUser;
  final String role; // "client" ou "prestataire"

  OTPVerification({Key? key, required this.role, required this.dataUser})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerification> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  void _verifyOTP() {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length == 6) {
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code validé : $otp")),
      );

      if (widget.role == "Client") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PasswordScreen(dataUser: widget.dataUser)),
        );
      } else if (widget.role == "Prestataire") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PrestataireSignupScreen(dataUser: widget.dataUser)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rôle inconnu, veuillez réessayer.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entrez un code de 6 chiffres")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const String message = "Entrez le code PIN à 6 chiffres envoyé ";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),

              /// Champs OTP avec `Wrap` pour éviter le dépassement
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _otpControllers[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              /// Bouton Vérifier avec largeur ajustée
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0054A5),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: _verifyOTP,
                  child: const Text(
                    "Vérifier",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Bouton pour renvoyer le code
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nouveau code envoyé !")),
                  );
                },
                child: const Text(
                  "Vous n'avez pas reçu le code? Renvoyer",
                  style: TextStyle(color: Color(0xFF0054A5), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
