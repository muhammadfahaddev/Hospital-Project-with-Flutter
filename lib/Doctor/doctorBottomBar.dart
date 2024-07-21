import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital/Doctor/chat_screen.dart';
import 'package:hospital/Doctor/chatdoctor.dart';
import 'package:hospital/Doctor/checkupPage.dart';
import 'package:hospital/Doctor/dashboardDoctor.dart';
import 'package:hospital/Doctor/loginDoctor.dart';
import 'package:hospital/chat_screen.dart';
import 'package:hospital/chatdoctor.dart';
import 'package:hospital/screen.dart';
import 'package:hospital/signup.dart';
import 'package:hospital/Login.dart'; // Import your login screen

class ButtonscreenDoctor extends StatefulWidget {
  @override
  State<ButtonscreenDoctor> createState() => _ButtonscreenDoctorState();
}

class _ButtonscreenDoctorState extends State<ButtonscreenDoctor> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Screen()), // Navigate to the login screen after logout
    );
  }

  int currentindex = 0;
  void onTap(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      DashboardScreenDoctor(),
      CheckupAppointmentDoctor(),
      ChatListScreen(),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0EBE7E),
            Color(0xFF007D9A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Doctor Dashboard"),
          backgroundColor:             Color(0xFF0EBE7E),

          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: currentindex,
          backgroundColor: Color.fromARGB(255, 170, 171, 172),
          color: Color(0xFF0EBE7E),
          height: 55.0,
          animationDuration: Duration(milliseconds: 300),
          items: [
            Icon(Icons.dashboard, color: Colors.white),
            Icon(Icons.add, color: Colors.white),
            Icon(Icons.message, color: Colors.white),
          ],
          onTap: onTap,
        ),
        body: Container(
          child: currentUser != null ? pages[currentindex] : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
