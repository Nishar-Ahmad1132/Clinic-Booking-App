import 'package:clinic_booking_app/pages/Doctor_List_page.dart';
import 'package:clinic_booking_app/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool showOtpField = false;
  String generatedOtp = '1234';
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: showOtpField
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.teal),
                onPressed: () {
                  setState(() {
                    showOtpField = false;
                    showError = false;
                  });
                },
              )
            : null,
        
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_to_back, color: Colors.teal),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.teal.shade700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: !showOtpField
                ? _buildEmailForm(context)
                : _buildOtpForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.lock_open, size: 60, color: Colors.teal.shade400),
              const SizedBox(height: 16),
              Text(
                "Welcome Back!",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Login to continue booking",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  errorText:
                      showError &&
                          (email.isEmpty ||
                              !RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(email))
                      ? 'Enter a valid email address'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => setState(() => email = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() => showError = true);
                  if (email.isNotEmpty &&
                      RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(email)) {
                    setState(() => showOtpField = true);
                  }
                },
                child: Text(
                  "Send OTP",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpForm(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.verified_user, size: 60, color: Colors.teal.shade400),
            const SizedBox(height: 16),
            Text(
              "Verify OTP",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter the OTP sent to your email",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OtpTextField(
              numberOfFields: 4,
              borderColor: Colors.teal,
              focusedBorderColor: Colors.teal,
              showFieldAsBox: true,
              fieldWidth: 50,
              textStyle: const TextStyle(fontSize: 18),
              onSubmit: (code) {
                if (code == generatedOtp) {
                  context.read<AuthProvider>().login(email);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DoctorListPage()),
                  );
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
                }
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  showOtpField = false;
                  showError = false;
                });
              },
              child: Text(
                "Change Email",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
