import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bladnaservices/screens/home/reservation/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationPrestataireScreen extends StatefulWidget {
  final Map<String, dynamic> provider;
  ReservationPrestataireScreen({Key? key, required this.provider})
      : super(key: key);
  @override
  _ReservationPrestataireScreenState createState() =>
      _ReservationPrestataireScreenState();
}

class _ReservationPrestataireScreenState
    extends State<ReservationPrestataireScreen> {
  DateTime? _startDay;
  DateTime? _endDay;
  DateTime _focusedDay = DateTime.now();
  bool isLoading = false;
  String? selectedHour;
  late TextEditingController addressController;
  String? dateError;
  String? hourError;
  String? addressError;

  List<String> availableHours = [
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00"
  ];

  List<DateTime> reservedDays = [];

  @override
  void initState() {
    super.initState();
    fetchReservedDates();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  // Fetch reserved dates from API
  Future<void> fetchReservedDates() async {
    setState(() {
      isLoading = true;
    });

    try {
      int providerId = widget.provider['provider_id'];
      String url = "http://localhost:3000/reservations-date/$providerId";
      print(url);
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<dynamic> reservations = jsonResponse['reservations'];

        List<DateTime> tempReservedDays = [];

        for (var reservation in reservations) {
          DateTime startDate =
              DateTime.parse(reservation['start_date']).toLocal();
          DateTime endDate = DateTime.parse(reservation['end_date']).toLocal();

          for (DateTime date = startDate;
              date.isBefore(endDate.add(Duration(days: 1)));
              date = date.add(Duration(days: 1))) {
            tempReservedDays.add(date);
          }
        }

        setState(() {
          reservedDays = tempReservedDays;
        });
      } else {
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (error) {
      print("API Error: $error");
    }

    setState(() {
      isLoading = false;
    });
  }

  void validateAndProceed() {
    setState(() {
      dateError = (_startDay == null || _endDay == null)
          ? "Veuillez sélectionner une période."
          : null;
      hourError =
          selectedHour == null ? "Veuillez sélectionner une heure." : null;
      addressError = addressController.text.isEmpty
          ? "Veuillez entrer une adresse."
          : null;
    });

    if (dateError == null && hourError == null && addressError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            reservationUtilisateur: {
              "provider_id": widget.provider['provider_id'],
              "name": widget.provider['name'],
              "profile": widget.provider['image'],
              "profession": widget.provider['profession'],
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
        iconTheme: IconThemeData(
            color: Color(0xFF0054A5)), // Appliquer la couleur aux icônes
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
            Text("Sélectionner la période",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    day.isAfter(_startDay!.subtract(Duration(days: 1))) &&
                    day.isBefore(_endDay!.add(Duration(days: 1))),
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    dateError = null;

                    if (start != null && end == null) {
                      if (isReserved(start)) {
                        dateError = "Ce jour est déjà réservé.";
                        _startDay = null;
                        _endDay = null;
                      } else {
                        _startDay = start;
                        _endDay = start;
                      }
                      _focusedDay = focusedDay ?? _focusedDay;
                    } else if (start != null && end != null) {
                      bool containsReserved = reservedDays.any((reserved) =>
                          reserved.isAfter(start.subtract(Duration(days: 1))) &&
                          reserved.isBefore(end.add(Duration(days: 1))));

                      if (containsReserved) {
                        dateError =
                            "Un ou plusieurs jours sélectionnés sont déjà réservés.";
                        _startDay = null;
                        _endDay = null;
                      } else {
                        _startDay = start;
                        _endDay = end;
                        _focusedDay = focusedDay ?? _focusedDay;
                      }
                    }
                  });
                },
                rangeStartDay: _startDay,
                rangeEndDay: _endDay,
                calendarStyle: const CalendarStyle(
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
                  defaultTextStyle: TextStyle(color: Colors.black),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.black),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.black),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    bool isReserved = reservedDays.any((reserved) =>
                        reserved.year == day.year &&
                        reserved.month == day.month &&
                        reserved.day == day.day);

                    if (isReserved) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[400], // Gray background for reserved days
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.all(4),
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }
                    return null; // Use default styling for other days
                  },
                ),
              ),
            ),
            if (dateError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(dateError!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 16),
            Text("Sélectionner l’heure",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11.5, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF0054A5) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF0054A5)!),
                    ),
                    child: Text(hour,
                        style: TextStyle(
                            color:
                                isSelected ? Colors.white : Color(0xFF0054A5)!,
                            fontWeight: FontWeight.bold)),
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
            const Text("Saisir votre adresse",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    borderRadius: BorderRadius.circular(
                        10), // Ajuste la valeur pour plus ou moins d'arrondi
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
