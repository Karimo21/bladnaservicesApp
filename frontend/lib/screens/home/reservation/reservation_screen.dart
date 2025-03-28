import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'clients_tab.dart';
import 'myreservations_tab.dart';
import 'history_tab.dart';
import 'package:bladnaservices/screens/home/profile/User.dart';


class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Map<String, dynamic>> reservations = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [

    if(User.role=='provider')
    ClientsTab(),
    ReservationsTab(),
    HistoryTab(),
  ];

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "Réservations",
          style: TextStyle(
            color: Color(0xFF0054A5),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0054A5)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                   if(User.role=='provider')...[
                   _buildTab("Demandes des clients", 0),
                   _buildTab("Mes réservations", 1),
                   _buildTab("Historique", 2),
                   ]else...[
                     _buildTab("Mes réservations", 0),
                     _buildTab("Historique", 1),

                   ]
                ],
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index ? const Color(0xFF0054A5) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : const Color(0xFF565656),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}


 

class ReservationCard extends StatefulWidget {
  final Map<String, String> data;
  final Function onRemove;
  

 const ReservationCard({
    super.key,
    required this.data,
    required this.onRemove,
  });

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  bool isAccepted = false;
  String? selectedStatus; // Holds the selected status (Terminer/Annuler)

  Future<void> changeStatut(String reservationId, int statutId, int userId) async {
  
  final url = Uri.parse('http://localhost:3000/api/reservations/update_status');
  final loggedUser = User.userId;
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"reservationId": reservationId, "statutId": statutId, "userId":userId, "providerId":loggedUser}),
  );

  if (response.statusCode == 200) {
    
  } else {
    print("Erreur lors de la mise à jour du statut");
  }
}
  // Function to show the confirmation dialog before changing the status
  void _confirmStatusChange(String status) {
      int statutId;
  if (status == "Terminer") {
    statutId = 4;
  } else if (status == "Annuler") {
    statutId = 3;
  } else {
    // Fallback, though this case shouldn't occur.
    statutId = 0;
  }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmer l'action"),
          content: Text(
              "Êtes-vous sûr de vouloir marquer cette réservation comme '$status'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                
                 await changeStatut(widget.data["id"]!, statutId,int.parse(widget.data["client_id"].toString()));
                setState(() {
                  selectedStatus = status; 
                });
                Navigator.pop(context);
                 widget.onRemove();
              },
              child: const Text("Confirmer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("http://localhost:3000${widget.data['profile_picture']}"),
            ),
            title: Text(
              widget.data["name"]!,
              style: const TextStyle(
                 fontWeight: FontWeight.normal,
                color: Color(0xFF565656),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade400),
          buildInfoRow("Date de début", widget.data["start_date"]!),
          buildInfoRow("Date de fin", widget.data["end_date"]!),
          buildInfoRow("Ville", widget.data["city_name"]!),
          buildInfoRow("Lieu de réservation",widget.data["address"]!),
          buildInfoRow("Heure",widget.data["hour"]!),
          buildInfoRow(
            "Téléphone",
            widget.data["phone"]!,
            isLink: true,
            color: const Color(0xFF0054A5),
            underline: true,
            underlineColor: Colors.green,
          ),
          buildInfoRow(
            "Statut",
            selectedStatus ?? widget.data["status"]!,
            isLink: true,
            color:const  Color(0xFF0054A5),
            underline: selectedStatus == "En cours",
            underlineColor: Colors.blue,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             if (!isAccepted && widget.data["status"] != "En cours") ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                  ),
                  onPressed: () async {
                    widget.onRemove(); // Remove the card from the list

                    await changeStatut(widget.data["id"]!, 5,int.parse(widget.data["client_id"].toString()));
                  },
                  child: const Text(
                    "Refuser",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                  ),
                  onPressed: () async {
  
                 await changeStatut(widget.data["id"]!, 2,int.parse(widget.data["client_id"].toString()));
                  
                  setState(() {
                   isAccepted = true; // Show dropdown to select status
                   widget.data["status"] = "En cours";
                  });
                 
                  },
                  child: const Text(
                    "Accepter",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ] else ...[
                Expanded(

  child: DropdownButtonFormField<String>(
    value: selectedStatus,
    decoration: InputDecoration(
      labelText: "Changer le statut",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)), // Optional for styling
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    isExpanded: true, // Makes the dropdown menu items take full width
    items: ["Terminer", "Annuler"].map((String status) {
      return DropdownMenuItem<String>(
        value: status,
        
        child: Align(
          alignment: Alignment.centerLeft, // Aligns text to the left
          child: Text(status),
        ),
      );
    }).toList(),
    onChanged: (String? newValue) {
      if (newValue != null) {
        _confirmStatusChange(newValue); // Confirm before changing status
      }
    },
  ),
)

              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value,
      {bool isLink = false, Color? color, bool underline = false, Color? underlineColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF565656)),
          ),
          GestureDetector(
            onTap: isLink ? () {} : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color ?? const Color(0xFF565656),
                decoration: underline ? TextDecoration.underline : TextDecoration.none,
                decorationColor: underlineColor ?? const Color(0xFF0054A5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



  Widget buildInfoRow(String label, String value,
      {bool isLink = false,
      Color? color,
      bool underline = false,
      Color? underlineColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF565656)),
          ),
          GestureDetector(
            onTap: isLink ? () {} : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color ?? const Color(0xFF565656),
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
                decorationColor: underlineColor ?? const Color(0xFF0054A5),
              ),
            ),
          ),
        ],
      ),
    );
  }

