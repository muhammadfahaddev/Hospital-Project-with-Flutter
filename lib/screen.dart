import 'package:flutter/material.dart';
import 'package:hospital/Admin/loginAdmin.dart';
import 'package:hospital/Doctor/loginDoctor.dart';
import 'package:hospital/Login.dart';

class Screen extends StatelessWidget {
  void _onTabTapped(BuildContext context, String role) {
    print('$role tab tapped');
    // Example navigation based on role (replace with your navigation logic)
    if (role == 'Admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginAdminScreen()),
      );
    } else if (role == 'User') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else if (role == 'Doctor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginDoctor()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size information
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0EBE7E),
            Color(0xFF007D9AD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // or Color(0xFF0EBE7E)
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => _onTabTapped(context, 'Admin'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.admin_panel_settings, size: screenWidth * 0.1),
                    SizedBox(width: screenWidth * 0.02),
                    Text('Admin', style: TextStyle(fontSize: screenWidth * 0.04)),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              InkWell(
                onTap: () => _onTabTapped(context, 'User'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: screenWidth * 0.1),
                    SizedBox(width: screenWidth * 0.02),
                    Text('User', style: TextStyle(fontSize: screenWidth * 0.04)),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              InkWell(
                onTap: () => _onTabTapped(context, 'Doctor'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_hospital, size: screenWidth * 0.1),
                    SizedBox(width: screenWidth * 0.02),
                    Text('Doctor', style: TextStyle(fontSize: screenWidth * 0.04)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: Center(
        child: Text('Admin Screen'),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Center(
        child: Text('User Screen'),
      ),
    );
  }
}

class DoctorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Screen'),
      ),
      body: Center(
        child: Text('Doctor Screen'),
      ),
    );
  }
}
