import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReservationsPage(),
    );
  }
}

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ClientsTab(),
    ReservationsTab(),
    HistoryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          "Réservations",
          style: TextStyle(
            color: Color(0xFF0054A5),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        backgroundColor: Color(0xFFF9F9F9),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF0054A5)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab("Demandes des clients", 0),
                  _buildTab("Mes réservations", 1),
                  _buildTab("Historique", 2),
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
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index ? Color(0xFF0054A5) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedIndex == index ||
                    _selectedIndex == 0 ||
                    _selectedIndex == 1 ||
                    _selectedIndex == 2
                ? const Color.fromARGB(255, 61, 61, 61)
                : const Color.fromARGB(255, 61, 61, 61),
            width: 0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : Color(0xFF565656),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class ClientsTab extends StatelessWidget {
  final List<Map<String, String>> reservations = [
    {
      "name": "Mohsin Korama",
      "date": "18/04/2025",
      "time": "09:00",
      "city": "Agadir",
      "phone": "0650431156",
      "status": "En cours"
    },
    {
      "name": "Khalid Ayaou",
      "date": "20/04/2025",
      "time": "14:30",
      "city": "Marrakech",
      "phone": "0623456789",
      "status": "En cours"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return ReservationCard(data: reservations[index]);
      },
    );
  }
}

class ReservationCard extends StatelessWidget {
  final Map<String, String> data;
  ReservationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            title: Text(
              data["name"]!,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF565656),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade400),
          buildInfoRow("Date de Réservation", data["date"]!),
          buildInfoRow("Heure", data["time"]!),
          buildInfoRow("Ville", data["city"]!),
          buildInfoRow(
            "Téléphone",
            data["phone"]!,
            isLink: true,
            color: Color(0xFF0054A5),
            underline: true, // Souligner le numéro de téléphone
            underlineColor: Colors.green, // Custom underline color
          ),
          buildInfoRow(
            "Statut",
            data["status"]!,
            isLink: true,
            color: Color(0xFF0054A5),
            underline: data["status"] == "En cours",

            underlineColor: Colors.blue, // Custom underline color
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF0054A5), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                ),
                onPressed: () {},
                child: Text(
                  "Annuler",
                  style: TextStyle(color: Color(0xFF0054A5), fontSize: 20),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF0054A5), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                ),
                onPressed: () {},
                child: Text(
                  "Terminer",
                  style: TextStyle(color: Color(0xFF0054A5), fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
            style: TextStyle(
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
                color: color ?? Color(0xFF565656),
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
                decorationColor: underlineColor ??
                    const Color.fromARGB(
                        160, 5, 67, 118), // Set the underline color here
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//HistoryCard
class HistoryCard extends StatelessWidget {
  final Map<String, String> data;
  final bool isSelected;
  HistoryCard({required this.data, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Color(0xFF0054A5) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  title: Text(
                    data["name"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF565656),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 28,
              ),
            ],
          ),
          Divider(color: Colors.grey.shade400),
          buildInfoRow("Date", data["date"]!),
          buildInfoRow("Heure", data["time"]!),
          buildInfoRow("Ville", data["city"]!),
          buildInfoRow(
            "Statut",
            data["status"]!,
            isLink: true,
            color: Colors.blue,
            underline: true,
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value,
      {bool isLink = false, Color? color, bool underline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
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
                color: color ?? Color(0xFF565656),
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
//myReservationCard
class myReservationCard extends StatelessWidget {
  final Map<String, String> data;
  myReservationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 14),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            title: Text(
              data["name"]!,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF565656),
              ),
            ),
          ),
          Divider(color: Colors.grey.shade400),
          buildInfoRow("Date de Réservation", data["date"]!),
          buildInfoRow("Heure", data["time"]!),
          buildInfoRow("Ville", data["city"]!),
          buildInfoRow(
            "Téléphone",
            data["phone"]!,
            isLink: true,
            color: Color(0xFF0054A5),
            underline: true, // Souligner le numéro de téléphone
            underlineColor: const Color.fromARGB(
                255, 44, 64, 144), // Custom underline color
          ),
          buildInfoRow(
            "Statut",
            data["status"]!,
            isLink: true,
            color: Color(0xFF0054A5),
            underline: data["status"] == "En attente",

            underlineColor: Colors.blue, // Custom underline color HH
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF0054A5), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                ),
                onPressed: () {},
                child: Text(
                  "Annuler",
                  style: TextStyle(color: Color(0xFF0054A5), fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
            style: TextStyle(
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
                color: color ?? Color(0xFF565656),
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
                decorationColor: underlineColor ??
                    const Color.fromARGB(
                        160, 5, 67, 118), // Set the underline color here
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//

class ReservationsTab extends StatelessWidget {
  final List<Map<String, String>> reservations = [
    {
      "name": "Mohsin Korama",
      "date": "18/04/2025",
      "time": "09:00",
      "city": "Agadir",
      "phone": "0650431156",
      "status": "En attente"
    },
    {
      "name": "Khalid Ayaou",
      "date": "20/04/2025",
      "time": "14:30",
      "city": "Marrakech",
      "phone": "0623456789",
      "status": "En attente"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return myReservationCard(data: reservations[index]);
      },
    );
  }
}

class HistoryTab extends StatelessWidget {
  final List<Map<String, String>> reservations = [
    {
      "name": "Mohsin Korama",
      "date": "18/04/2025",
      "time": "09:00",
      "city": "Agadir",
      "phone": "0650431156",
      "status": "Terminer"
    },
    {
      "name": "Khalid Ayaou",
      "date": "20/04/2025",
      "time": "14:30",
      "city": "Marrakech",
      "phone": "0623456789",
      "status": "Terminer"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return HistoryCard(data: reservations[index]);
      },
    );
  }
}
