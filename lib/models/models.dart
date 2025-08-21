import 'dart:convert';

class Doctor {
  final String id;
  String name;
  String specialty;
  List<String> timeSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.timeSlots,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'timeSlots': timeSlots,
  };

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      timeSlots: List<String>.from(json['timeSlots']),
    );
  }
}







class Appointment {
  final String doctorName;
  final String specialty;
  final String time;
  final String patientName;
  final String patientEmail;

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.time,
    required this.patientName,
    required this.patientEmail,
  });

  Map<String, dynamic> toJson() => {
    'doctorName': doctorName,
    'specialty': specialty,
    'time': time,
    'patientName': patientName,
    'patientEmail': patientEmail,
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    doctorName: json['doctorName'],
    specialty: json['specialty'],
    time: json['time'],
    patientName: json['patientName'],
    patientEmail: json['patientEmail'],
  );

  static String encodeList(List<Appointment> appts) =>
      jsonEncode(appts.map((a) => a.toJson()).toList());

  static List<Appointment> decodeList(String data) {
    return (jsonDecode(data) as List)
        .map((e) => Appointment.fromJson(e))
        .toList();
  }
}
