import 'package:clinic_booking_app/providers/auth_providers.dart';
import 'package:clinic_booking_app/providers/Doctor_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleSelectionPage extends StatelessWidget {
  final String userId;

  const RoleSelectionPage({super.key, required this.userId});

  void _handleRoleSelection(BuildContext context, String role) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    if (role == 'patient') {
      if (auth.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else if (role == 'doctor') {

      doctorProvider.setCurrentDoctorById(
        "1",
      ); 

      Navigator.pushNamed(context, '/doctorProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              "Who are you?",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Please select your role to continue",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Row(
                children: [
                  _buildRoleCard(
                    context,
                    title: "Patient",
                    icon: Icons.person,
                    color: Colors.blueAccent,
                    onTap: () => _handleRoleSelection(context, 'patient'),
                  ),
                  const SizedBox(width: 20),
                  _buildRoleCard(
                    context,
                    title: "Doctor",
                    icon: Icons.medical_services,
                    color: Colors.green,
                    onTap: () => _handleRoleSelection(context, 'doctor'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
