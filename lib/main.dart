import 'package:clinic_booking_app/providers/Doctor_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_providers.dart';
import 'providers/booking_provider.dart';
import 'pages/about.dart';
import 'pages/role.dart';
import 'pages/landing_page.dart';
import 'pages/login_page.dart';
import 'pages/doctor_list_page.dart';
import 'pages/doctor_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.checkLoginStatus();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const DoctorListPage(),
        '/about': (context) => const AboutPage(),
        '/roleSelection': (context) {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          return RoleSelectionPage(userId: auth.userId ?? '');
        },
        '/availableDoctors': (context) => const DoctorListPage(),
        '/doctorProfile': (context) => const DoctorProfilePage(),
      },
    );
  }
}
