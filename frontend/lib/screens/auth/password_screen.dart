import 'package:bladnaservices/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataUser;

  const PasswordScreen({super.key, required this.dataUser});

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Créez votre mot de passe ",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF565656)),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Nom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Le nom est obligatoire" : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _prenomController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: "Prénom",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Le prénom est obligatoire" : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.cake),
                    hintText: "Âge",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "L'âge est obligatoire";
                    if (int.tryParse(value) == null ||
                        int.parse(value) <= 0 ||
                        int.parse(value) >= 110) {
                      return "Âge invalide";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Mot de passe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Le mot de passe est obligatoire";
                    if (value.length < 6)
                      return "Le mot de passe doit contenir au moins 6 caractères";
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "Confirmez votre mot de passe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      icon: Icon(_confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() =>
                          _confirmPasswordVisible = !_confirmPasswordVisible),
                    ),
                  ),
                  validator: (value) => value != _passwordController.text
                      ? "Les mots de passe ne correspondent pas"
                      : null,
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0054A5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        List<Map<String, dynamic>> updatedDataUser =
                            List.from(widget.dataUser);
                        updatedDataUser.add({
                          "nom": _nomController.text,
                          "prenom": _prenomController.text,
                          "age": int.parse(_ageController.text),
                          "mot_de_passe": _passwordController.text,
                        });
                        print(updatedDataUser);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Mot de passe enregistré !")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      }
                    },
                    child: Text("Enregistrer",
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
                SizedBox(
                    height: 20), // Ajout d'un espace pour éviter le débordement
              ],
            ),
          ),
        ),
      ),
    );
  }
}