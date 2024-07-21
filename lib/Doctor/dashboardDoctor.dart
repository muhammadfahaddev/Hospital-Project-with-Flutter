import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/modal/doctor.dart'; // Adjust path as per your project structure

class DashboardScreenDoctor extends StatefulWidget {
  @override
  _DashboardScreenDoctorState createState() => _DashboardScreenDoctorState();
}

class _DashboardScreenDoctorState extends State<DashboardScreenDoctor> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Doctor? userDetails;
  User? user;
  int totalAppointments = 0;
  int todayAppointments = 0;
  int totalpatient = 0;
  int todaypatient = 0;
  @override
  void initState() {
    super.initState();
    getUserDetails();
    fetchAppointmentCount();
  }

  Future<void> getUserDetails() async {
    user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('doctor_details')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userDetails = Doctor.fromMap(userDoc.data()!, user!.uid);
          });
        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print("Failed to fetch user details: $e");
      }
    }
  }

  Future<void> fetchAppointmentCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: user!.uid)
          .where('status', isEqualTo: 'upcoming')
          .get();
      String formattedDate = DateTime.now().toString().substring(0, 10);

      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'upcoming')
          .where('doctorId', isEqualTo: user!.uid)
          .where('appointmentDate', isEqualTo: formattedDate)
          .get();
      QuerySnapshot totalpatient1 = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: user!.uid)
          .get();
      QuerySnapshot todaypatient1 = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: user!.uid)
          .where('appointmentDate', isEqualTo: formattedDate)
          .get();

      setState(() {
        todayAppointments = querySnapshot1.size;
        totalpatient = totalpatient1.size;
        todaypatient = todaypatient1.size;
        totalAppointments = querySnapshot.size;
        print(totalAppointments);
      });
    } catch (e) {
      print("Error fetching appointment count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0EBE7E),
            Color(0xFF007D9AD),
          ],
        ),
      ),
      child: Scaffold(
       
        drawer: Drawer(
          child: userDetails != null
              ? ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: userDetails!.image.isNotEmpty
                                ? NetworkImage(userDetails!.image)
                                : AssetImage('assets/placeholder_image.png')
                                    as ImageProvider,
                          ),
                          SizedBox(height: 10),
                          Text(userDetails!.name,
                              style: TextStyle(color: Colors.white)),
                          Text(userDetails!.title,
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0EBE7E).withOpacity(0.1),
                Color(0xFF007D9AD),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                OverviewCards(
                  no: totalAppointments,
                  todayAppointments: todayAppointments,
                  totalpatient: totalpatient,
                  todaypatient: todaypatient,
                ),
                SizedBox(height: 20),
                AppointmentHistory(),
                SizedBox(height: 20),
                Inbox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OverviewCards extends StatelessWidget {
  final int no;
  final int todayAppointments;
  final int totalpatient;
  final int todaypatient;
  OverviewCards({
    required this.no,
    required this.todayAppointments,
    required this.totalpatient,
    required this.todaypatient,
  });
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        OverviewCard(
            title: 'New Appointments',
            count: '${no.toInt()}',
            increase: todayAppointments),
        OverviewCard(
            title: 'Total Patients',
            count: '${totalpatient.toInt()}+',
            increase: todaypatient),
        OverviewCard(title: 'Successful Surgery', count: '505+', increase: 0),
        OverviewCard(title: 'Today Appointment', count: '${no.toInt()}+', increase: no.toInt()),
      ],
    );
  }
}

class OverviewCard extends StatelessWidget {
  final String title;
  final String count;
  final int increase;

  OverviewCard(
      {required this.title, required this.count, required this.increase});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(count, style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('${increase >= 0 ? '+' : ''}$increase',
                style: TextStyle(
                    color: increase >= 0 ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}

class AppointmentHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      //   Text('Appointment History',
      //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //   ListView(
      //     shrinkWrap: true,
      //     physics: NeverScrollableScrollPhysics(),
      //     children: [
      //       AppointmentTile(
      //           patientName: 'Jolie Basart',
      //           appointmentDate: '21st Jan, 2021',
      //           appointmentTime: '10:30 AM'),
      //       AppointmentTile(
      //           patientName: 'Maria',
      //           appointmentDate: '21st Jan, 2021',
      //           appointmentTime: '10:30 AM'),
      //       AppointmentTile(
      //           patientName: 'Jenissa',
      //           appointmentDate: '21st Jan, 2021',
      //           appointmentTime: '10:30 AM'),
      //     ],
      //   ),
      ],
    );
  }
}

class AppointmentTile extends StatelessWidget {
  final String patientName;
  final String appointmentDate;
  final String appointmentTime;

  AppointmentTile(
      {required this.patientName,
      required this.appointmentDate,
      required this.appointmentTime});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(patientName),
      subtitle: Text('$appointmentDate, $appointmentTime'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to appointment details screen
      },
    );
  }
}

class Inbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Inbox',
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        // ListView(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   children: [
        //     InboxTile(
        //         senderName: 'Rafael Nadal',
        //         message: 'Hello, Doctor! How are you today?'),
        //     InboxTile(
        //         senderName: 'Roger Federer',
        //         message: 'Hello, Doctor! How are you today?'),
        //   ],
        // ),
      ],
    );
  }
}

class InboxTile extends StatelessWidget {
  final String senderName;
  final String message;

  InboxTile({required this.senderName, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(senderName),
      subtitle: Text(message),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to message details screen
      },
    );
  }
}
