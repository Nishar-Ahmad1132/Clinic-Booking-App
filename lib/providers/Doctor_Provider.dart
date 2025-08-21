import 'package:flutter/material.dart';
import '../models/models.dart';

class DoctorProvider with ChangeNotifier {

  final List<Doctor> _doctors = [
    Doctor(
      id: '1',
      name: 'Dr. Istekhar',
      specialty: 'Cardiologist',
      timeSlots: ['10:00 AM', '11:00 AM', '2:00 PM'],
    ),
    Doctor(
      id: '2',
      name: 'Dr. Jane Smith',
      specialty: 'Dermatologist',
      timeSlots: ['9:00 AM', '1:00 PM', '4:00 PM'],
    ),
  ];

  Doctor? _currentDoctor; // Logged-in doctor (if any)

  List<Doctor> get doctors => _doctors;

  Doctor? get currentDoctor => _currentDoctor;

  Doctor? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return null;
    }
  }

  void setCurrentDoctor(String id) {
    _currentDoctor = getDoctorById(id);
    notifyListeners();
  }

  // void setCurrentDoctor(Doctor doctor) {
  //   _currentDoctor = doctor;
  //   notifyListeners();
  // }

  void createDoctorProfile(
    String name,
    String specialty,
    List<String> timeSlots,
  ) {
    final newDoctor = Doctor(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      specialty: specialty,
      timeSlots: timeSlots,
    );
    _doctors.add(newDoctor);
    _currentDoctor = newDoctor; // Set as logged-in doctor
    notifyListeners();
  }

  void updateName(String id, String newName) {
    final doctor = getDoctorById(id);
    if (doctor != null) {
      doctor.name = newName;
      notifyListeners();
    }
  }

  void updateSpecialty(String id, String newSpecialty) {
    final doctor = getDoctorById(id);
    if (doctor != null) {
      doctor.specialty = newSpecialty;
      notifyListeners();
    }
  }

  void addTimeSlot(String id, String slot) {
    final doctor = getDoctorById(id);
    if (doctor != null && !doctor.timeSlots.contains(slot)) {
      doctor.timeSlots.add(slot);
      notifyListeners();
    }
  }

  void removeTimeSlot(String id, String slot) {
    final doctor = getDoctorById(id);
    if (doctor != null) {
      doctor.timeSlots.remove(slot);
      notifyListeners();
    }
  }

  void setCurrentDoctorById(String id) {
    _currentDoctor = getDoctorById(id);
    notifyListeners();
  }

}
