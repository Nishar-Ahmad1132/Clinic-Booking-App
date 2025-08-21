import 'package:clinic_booking_app/models/models.dart';
import 'package:clinic_booking_app/pages/Booking_page.dart';
import 'package:clinic_booking_app/pages/My_Appointment_page.dart';
import 'package:clinic_booking_app/pages/Patient_Profile_page.dart';
import 'package:flutter/material.dart';

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({super.key});

  List<Doctor> getDoctors() {
    return List.generate(
      10,
      (i) => Doctor(
        id: "$i + 1",
        name: "Istekhar Ahmad $i",
        specialty: i % 2 == 0 ? "Cardiologist" : "Dermatologist",
        timeSlots: ["10:00 AM", "11:00 AM", "3:00 PM", "5:00 PM"],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctors = getDoctors();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Available Doctors",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PatientProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyAppointmentsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingScreen(doctor: doc)),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Doctor avatar
                  Container(
                    margin: const EdgeInsets.all(12),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.teal[50],
                      image: const DecorationImage(
                        image: AssetImage("assets/cs0022.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Doctor details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doc.specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.teal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${doc.timeSlots.first} - ${doc.timeSlots.last}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
