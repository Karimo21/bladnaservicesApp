import 'package:bladnaservices/screens/home/reservation/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationPrestataireScreen extends StatefulWidget {
  @override
  _ReservationPrestataireScreenState createState() =>
      _ReservationPrestataireScreenState();
}

class _ReservationPrestataireScreenState
    extends State<ReservationPrestataireScreen> {
  DateTime? _startDay;
  DateTime? _endDay;
  DateTime _focusedDay = DateTime.now();
  String? selectedHour;
  late TextEditingController addressController;
  String? dateError;
  String? hourError;
  String? addressError;

  List<String> availableHours = [
    "08:00", "09:00", "10:00", "11:00", "12:00",
    "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"
  ];

  List<DateTime> reservedDays = [
    DateTime(2025, 3, 5),
    DateTime(2025, 3, 10),
    DateTime(2025, 3, 15),
  ];

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  void validateAndProceed() {
    setState(() {
      dateError = (_startDay == null || _endDay == null)
          ? "Veuillez sélectionner une période."
          : null;
      hourError = selectedHour == null ? "Veuillez sélectionner une heure." : null;
      addressError = addressController.text.isEmpty ? "Veuillez entrer une adresse." : null;
    });

    if (dateError == null && hourError == null && addressError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            reservationUtilisateur: {
              "date_debut": _startDay!.toString().substring(0, 10),
              "date_fin": _endDay!.toString().substring(0, 10),
              "hour": selectedHour!,
              "address": addressController.text,
            },
          ),
        ),
      );
    }
  }

  bool isReserved(DateTime day) {
    return reservedDays.any((reserved) =>
        reserved.year == day.year &&
        reserved.month == day.month &&
        reserved.day == day.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
    backgroundColor: Colors.white,
    title: Text("Réservation", style: TextStyle(color: Color(0xFF0054A5))),
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF0054A5)), // Appliquer la couleur aux icônes
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
  ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            SizedBox(height: 4),
            Text("Sélectionner la période", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 18),

        Container(
  decoration: BoxDecoration(
    color: Colors.white, // Fond blanc
    borderRadius: BorderRadius.circular(12), // Coins arrondis
    boxShadow: [
      BoxShadow(
        color: Colors.black26, // Couleur de l'ombre
        blurRadius: 8, // Intensité du flou
        spreadRadius: 2, // Expansion de l'ombre
        offset: Offset(0, 4), // Décalage de l'ombre
      ),
    ],
  ),
  child: TableCalendar(
    focusedDay: _focusedDay,
    firstDay: DateTime(2023, 1, 1),
    lastDay: DateTime(2025, 12, 31),
    calendarFormat: CalendarFormat.month,
    rangeSelectionMode: RangeSelectionMode.toggledOn,
    selectedDayPredicate: (day) =>
        _startDay != null &&
        _endDay != null &&
        day.isAfter(_startDay!.subtract(Duration(days:1))) &&
        day.isBefore(_endDay!.add(Duration(days: 1))),
    onRangeSelected: (start, end, focusedDay) {
      if (start != null && (start.isBefore(DateTime.now()) || isReserved(start))) {
        setState(() {
          dateError = "Date invalide. Sélectionnez une autre période.";
          _startDay = null;
          _endDay = null;
        });
      } else {
        setState(() {
          _startDay = start;
          _endDay = end;
          _focusedDay = focusedDay ?? _focusedDay;
          dateError = null;
        });
      }
    },
    rangeStartDay: _startDay,
    rangeEndDay: _endDay,
    calendarStyle: CalendarStyle(
      rangeHighlightColor: Color(0xFF0054A5),
      rangeStartDecoration: BoxDecoration(
        color: Color(0xFF0054A5),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      selectedDecoration: BoxDecoration(
        color: Color(0xFF0054A5),
        shape: BoxShape.circle,
      
      ),
      disabledTextStyle: TextStyle(color: Color.fromARGB(255, 141, 140, 140)),
      defaultTextStyle: TextStyle(color: Colors.black),
    ),
    headerStyle: HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
      rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
    ),
  ),
),

            if (dateError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(dateError!, style: TextStyle(color: Colors.red)),
              ),

            SizedBox(height: 16),
            Text("Sélectionner l’heure", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableHours.map((hour) {
                bool isSelected = selectedHour == hour;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedHour = hour;
                      hourError = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11.5, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const  Color(0xFF0054A5) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF0054A5)!),
                    ),
                    child: Text(hour, style: TextStyle(color: isSelected ? Colors.white : Color(0xFF0054A5)!, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
            if (hourError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(hourError!, style: TextStyle(color: Colors.red)),
              ),

            SizedBox(height: 16),
          const   Text("Saisir votre adresse", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Entrez votre adresse",
                errorText: addressError,
              ),
            ),
            SizedBox(height: 20),

          SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: validateAndProceed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF0054A5),
      padding: EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Ajuste la valeur pour plus ou moins d'arrondi
      ),
    ),
    child: const Text(
      "Suivant",
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  ),
),

          ],
        ),
      ),
    );
    
  }

}
