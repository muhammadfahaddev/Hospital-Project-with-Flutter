import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hospital/Admin/addDoctorscreen.dart';
import 'package:hospital/Admin/adminDashboard.dart';
import 'package:hospital/signup.dart';

class ButtonscreenAdmin extends StatefulWidget {
  @override
  State<ButtonscreenAdmin> createState() => _ButtonscreenAdminState();
}

class _ButtonscreenAdminState extends State<ButtonscreenAdmin> {
  List pages = [
    AddDoctorScreen(),
  ];
  int currentindex = 0;

  void onTap(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Color(0xFF0EBE7E),
        bottomNavigationBar: CurvedNavigationBar(
          index: currentindex,
          backgroundColor: Color(0xFF0EBE7E),
          color: Color(0xFF007D9AD),
          height: 55.0,
          animationDuration: Duration(milliseconds: 300),
          items: [
            Icon(Icons.add, color: Colors.white),
          ],
          onTap: onTap,
        ),
        body: Container(
          child: pages[currentindex],
        ),
      ),
    );
  }
}
