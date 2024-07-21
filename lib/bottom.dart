import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hospital/Admin/addDoctorscreen.dart';
import 'package:hospital/Dashboard.dart';
import 'package:hospital/Login.dart';
import 'package:hospital/ScheduleTab.dart';
import 'package:hospital/chatdoctor.dart';
import 'package:hospital/doctorBook.dart';

class ButtonScreen extends StatefulWidget {
  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
   User? currentUser; // Store current user
  int currentIndex = 0;

  // Define your pages list with placeholders for initialization
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    initializeCurrentUser();
    // Initialize pages list
    pages = [
      DashBoardScreen(),
      ScheduleTab1(uid:currentUser!.uid), // Pass current user's UID to ScheduleTab
      chatDoctor(),
      BookAppointment(),
    ];
  }

  // Function to initialize current user and listen for auth state changes
  void initializeCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0EBE7E),
                      Color(0xFF007D9AD),
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/Image/logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        setState(() {
                          currentIndex = 0; // Navigate to Home screen
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Appointments'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        setState(() {
                          currentIndex = 1; // Navigate to Appointments screen
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.folder),
                      title: Text('Records'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        setState(() {
                          currentIndex = 2; // Navigate to Records screen
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.medical_services),
                      title: Text('Consultations'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        setState(() {
                          currentIndex = 3; // Navigate to Consultations screen
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.receipt),
                      title: Text('Billing'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        // Handle Billing navigation if required
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.book),
                      title: Text('Resources'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        // Handle Resources navigation if required
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Messages'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        // Handle Messages navigation if required
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      onTap: () {
                        // Handle tap
                        Navigator.pop(context); // Close the drawer
                        // Handle Profile navigation if required
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Handle settings tap
                  Navigator.pop(context); // Close the drawer
                  // Navigate to Settings screen if required
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  // Handle logout tap
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement( // Navigate to Login screen and replace the current route
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0EBE7E),
                Color(0xFF007D9AD),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CurvedNavigationBar(
            index: currentIndex,
            color: Colors.transparent,
            buttonBackgroundColor:const Color(0xFF0EBE7E),
            backgroundColor: Colors.transparent,
            height: 55.0,
            animationDuration: Duration(milliseconds: 300),
            items:const [
              Icon(Icons.dashboard, color: Colors.white),
              Icon(Icons.search, color: Colors.white),
              Icon(Icons.chat, color: Colors.white),
              Icon(Icons.account_circle_sharp, color: Colors.white),
            ],
            onTap: onTap,
          ),
        ),
        body: pages[currentIndex],
      ),
    );
  }
}
