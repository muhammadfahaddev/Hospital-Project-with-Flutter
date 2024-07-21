import 'package:hospital/Admin/addDoctorScreen.dart';
import 'package:hospital/Admin/adminButtomNavigationbar.dart';
import 'package:hospital/Admin/adminDashboard.dart';
import 'package:hospital/Admin/loginAdmin.dart';
import 'package:hospital/Dashboard.dart';
import 'package:hospital/Doctor/dashboardDoctor.dart';
import 'package:hospital/Doctor/doctorBottomBar.dart';
import 'package:hospital/Doctor/loginDoctor.dart';
import 'package:hospital/Doctor/report.dart';
import 'package:hospital/Doctor_Select%20_details.dart';
import 'package:hospital/Doctor_Selecttime.dart';
import 'package:hospital/HomeScreen.dart';
import 'package:hospital/Login.dart';
import 'package:hospital/Reviewsystem.dart';
import 'package:hospital/ScheduleTab.dart';
import 'package:hospital/ViewRecord.dart';
import 'package:hospital/bottom.dart';
import 'package:hospital/chat_screen.dart';
import 'package:hospital/doctorSelectTime.dart';
import 'package:hospital/doctorViewDetails.dart';
import 'package:hospital/doctorBook.dart';
import 'package:hospital/Doctor_Select _details.dart';
import 'package:hospital/image.dart';
import 'package:hospital/loginPage.dart';
import 'package:hospital/scree/login_screen.dart';
import 'package:hospital/screen.dart';
import 'package:hospital/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/splashScreen.dart';

// import 'package:sign_in_button/sign_in_button.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String id = "YABtj0Hb4jWZxa5AzPaCnzt62Bg2";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/profilepage': (context) => ProfilePage(),
        '/home': (context) => DashBoardScreen(),
        // '/calender': (context) => SliverDoctorDetail(),
        '/ButtonscreenAdmin': (context) => ButtonscreenAdmin(),
        '/ButtonscreenDoctor': (context) => ButtonscreenDoctor(),

        '/Buttonscreen': (context) => ButtonScreen(),
        '/selecttime': (context) => Select_time(),
        '/screendoctor': (context) => DashboardScreenDoctor(),
        '/screen': (context) => Screen(),
      },
      home: SplashScreen(),
    );
  }
}
