// import 'package:clinic_booking_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _userId;
  String? get userId => _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;

  Future<void> login(String email) async {
    _isLoggedIn = true;
    _email = email;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('loggedInEmail', email);

    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loggedInEmail');

    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('loggedInEmail');
    notifyListeners();
  }
}

// class BookingProvider with ChangeNotifier {

//       List<Appointment> appointments = [];

//       Future<void> loadAppointments() async {
//         final prefs = await SharedPreferences.getInstance();
//         final data = prefs.getString('appointments');
//         if (data != null) {
//           appointments = Appointment.decodeList(data);
//         }
//         notifyListeners();
//       }

//       Future<void> addAppointment(Appointment appt) async {
//         appointments.add(appt);
//         final prefs = await SharedPreferences.getInstance();
//         prefs.setString('appointments', Appointment.encodeList(appointments));
//         notifyListeners();
//       }
// }
