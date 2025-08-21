import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinic_booking_app/providers/Doctor_Provider.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController specialtyController;
  final TextEditingController timeSlotController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final doctor = Provider.of<DoctorProvider>(
      context,
      listen: false,
    ).currentDoctor;
    if (doctor != null) {
      nameController = TextEditingController(text: doctor.name);
      specialtyController = TextEditingController(text: doctor.specialty);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctor = doctorProvider.currentDoctor;

    if (doctor == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No doctor profile found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Profile"),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                // Save updates
                doctorProvider.updateName(doctor.id, nameController.text);
                doctorProvider.updateSpecialty(
                  doctor.id,
                  specialtyController.text,
                );
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/cs0022.png"),
                    ),
                    const SizedBox(height: 12),
                    isEditing
                        ? TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 12),
                    isEditing
                        ? TextField(
                            controller: specialtyController,
                            decoration: const InputDecoration(
                              labelText: "Specialty",
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(
                            doctor.specialty,
                            style: const TextStyle(fontSize: 16),
                          ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Time Slots Section
            const Text(
              "Available Time Slots",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Time slots list
            ...doctor.timeSlots.map(
              (slot) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(slot),
                  trailing: isEditing
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              doctorProvider.removeTimeSlot(doctor.id, slot),
                        )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Add new time slot (only in edit mode)
            if (isEditing)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: timeSlotController,
                      decoration: const InputDecoration(
                        hintText: "Add new time slot",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (timeSlotController.text.isNotEmpty) {
                        doctorProvider.addTimeSlot(
                          doctor.id,
                          timeSlotController.text,
                        );
                        timeSlotController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}