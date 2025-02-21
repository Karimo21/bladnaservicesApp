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
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? selectedHour;
  TextEditingController addressController = TextEditingController();
  String? dateError;
  String? hourError;
  String? addressError;

  List<DateTime> reservationsPrestataire = [
    DateTime(2025, 4, 10),
    DateTime(2025, 4, 15),
    DateTime(2025, 1, 16),
    DateTime(2025, 1, 24),
    DateTime(2025, 1, 5),
    DateTime(2025, 1, 3),
    DateTime(2025, 2, 1),
    DateTime(2025, 2, 3),
    DateTime(2025, 2, 21),
  ];

  List<String> availableHours = [
    "08:00", "09:00", "10:00", "11:00", "12:00",
    "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"
  ];

  bool isDateReservedByPrestataire(DateTime day) {
    return reservationsPrestataire.any((res) => isSameDay(res, day));
  }

  void validateAndProceed() {
    setState(() {
      dateError = isDateReservedByPrestataire(_selectedDay)
          ? "Cette date est déjà réservée."
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
              "date": _selectedDay.toString().substring(0, 10),
              "hour": selectedHour!,
              "address": addressController.text,
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text("Réservation", style: TextStyle(color: Color(0xFF0054A5))),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0054A5)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sélectionner la date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2, offset: Offset(0, 5))],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2025, 1, 1),
                    lastDay: DateTime(2025, 12, 31),
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        dateError = isDateReservedByPrestataire(selectedDay) ? "Cette date est déjà réservée." : null;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(color: Color(0xFF0054A5), shape: BoxShape.circle),
                      defaultTextStyle: TextStyle(color: Colors.black),
                      outsideDaysVisible: false,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: TextStyle(fontWeight: FontWeight.bold)),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF0054A5)),
                      rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF0054A5)),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        bool isReserved = isDateReservedByPrestataire(day);
                        return Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isReserved ? Border.all(color: Colors.redAccent, width: 2) : null,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: isReserved ? Colors.redAccent : Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                    enabledDayPredicate: (day) => !isDateReservedByPrestataire(day),
                  ),
                ),
              ),
              if (dateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(dateError!, style: TextStyle(color: Colors.red)),
                ),

              SizedBox(height: 8),
              Text("Sélectionner l’heure", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
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
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF0054A5) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF0054A5)),
                      ),
                      child: Text(hour, style: TextStyle(color: isSelected ? Colors.white : Color(0xFF0054A5), fontWeight: FontWeight.bold)),
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
              Text("Saisir votre adresse", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  ),
                  child: Text("Suivant", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
