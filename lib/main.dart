import 'package:camera/camera.dart';
import 'package:chordefine/models/onboarding_view.dart';
import 'package:chordefine/screens/base_screen.dart';
import 'package:chordefine/screens/major2.dart';
import 'package:chordefine/screens/minor2.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

void main() async {
  Get.lazyPut(() => PracticeScreenMajorController());
  Get.lazyPut(() => PracticeScreenMinorController());
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  cameras = await availableCameras();

  if (!onboarding) {
    await requestPermissions();
  }
  runApp(MyApp(onboarding: onboarding));
}

late List<CameraDescription> cameras;

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
  ].request();
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chordefine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      home: onboarding ? const BaseScreen() : const OnboardingView(),
    );
  }
}
