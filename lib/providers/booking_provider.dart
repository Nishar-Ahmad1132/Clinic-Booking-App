import 'package:clinic_booking_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BookingProvider with ChangeNotifier {
  List<Appointment> appointments = [];

  BookingProvider() {
    loadAppointments();
  }


  Future<void> removeAppointment(BuildContext context, Appointment appt) async {
    appointments.remove(appt);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('appointments', Appointment.encodeList(appointments));
    notifyListeners();

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment cancelled successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('appointments');
    if (data != null) {
      appointments = Appointment.decodeList(data);
    }
    notifyListeners();
  }

  Future<void> addAppointment(Appointment appt) async {
    appointments.add(appt);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('appointments', Appointment.encodeList(appointments));
    notifyListeners();
  }
}
