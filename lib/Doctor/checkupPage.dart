import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital/Doctor/report.dart';
import 'package:hospital/modal/user.dart';

import 'package:hospital/scree/screens/home_screen.dart'; 
import 'package:hospital/scree/models/data_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:hospital/scree/screens/meeting_screen.dart';
import 'package:hospital/scree/services/join_service.dart';
import 'package:hospital/scree/services/sdk_initializer.dart';

class CheckupAppointmentDoctor extends StatefulWidget {
  @override
  _CheckupAppointmentState createState() => _CheckupAppointmentState();
}

enum FilterStatus { Upcoming }

class _CheckupAppointmentState extends State<CheckupAppointmentDoctor> {
  FilterStatus status = FilterStatus.Upcoming;
  List<Map<String, dynamic>> fetchedAppointments = [];
  User? user = FirebaseAuth.instance.currentUser;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchAppointments(user!.uid, selectedDate, status);
    }
    print(fetchAppointments(user!.uid, selectedDate, status));
  }

  Future<void> fetchAppointments(
      String userId, DateTime selectedDate, FilterStatus filterStatus) async {
    String statusString = 'upcoming';
    try {
      DateTime startDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      DateTime endDate = startDate.add(Duration(days: 1));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: userId)
          .where('status', isEqualTo: statusString)
          .where('appointmentDate', isGreaterThanOrEqualTo: startDate)
          .where('appointmentDate', isLessThanOrEqualTo: endDate)
          .get();

      List<Map<String, dynamic>> appointments = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? appointmentData =
            doc.data() as Map<String, dynamic>?;
        if (appointmentData != null) {
          appointmentData['appointmentId'] = doc.id;
          appointments.add(appointmentData);
        }
      }

      setState(() {
        fetchedAppointments = appointments;
      });

      print(
          'Fetching appointments for userId: $userId, date: $selectedDate, status: $statusString');
      print('Query snapshot length: ${querySnapshot.docs.length}');
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Future<UserModel?> fetchUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users_accounts')
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!['user_details'], uid);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  void selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    fetchAppointments(user!.uid, selectedDate, status);
    print('Selected date: $selectedDate');
  }

  List<DateTime> getNextNDays(int n) {
    List<DateTime> dates = [];
    for (int i = 0; i < n; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      dates.add(date);
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 50, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Check Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(MyColors.bg02),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: getNextNDays(10).map((date) {
                  bool isSelected = date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ActionChip(
                      label: Text('${_getFormattedDate(date)}'),
                      onPressed: () => selectDate(date),
                      backgroundColor:
                          isSelected ? Color(MyColors.bg02) : Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: fetchedAppointments.isEmpty
                  ? Center(child: Text('No appointments'))
                  : ListView.builder(
                      itemCount: fetchedAppointments.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> _schedule =
                            fetchedAppointments[index];
                        String appointmentStatus = _schedule['status'];

                        return FutureBuilder<UserModel?>(
                          future: fetchUserData(_schedule['userId']),
                          builder: (BuildContext context,
                              AsyncSnapshot<UserModel?> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            UserModel user = snapshot.data!;
                            return AppointmentCard(
                              appointmentData: _schedule,
                              user: user,
                              appointmentStatus: appointmentStatus,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${_getMonth(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Invalid Month';
    }
  }
}

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointmentData;
  final UserModel user;
  final String appointmentStatus;

  const AppointmentCard({
    Key? key,
    required this.appointmentData,
    required this.user,
    required this.appointmentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        user.name ?? 'User Name Not Available',
                        style: TextStyle(
                            color: Color(MyColors.header01),
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            DateTimeCard(
              date: _formatDate(appointmentData['appointmentDate']?.toDate()),
              time: appointmentData['appointmentTime'] ??
                  'Appointment Time Not Available',
            ),
            SizedBox(height: 15),
            if (appointmentStatus != 'complete')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        print(user);
                        print(appointmentData);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDoctor(
                              appointmentid: appointmentData['appointmentId'],
                              user: user,
                              doctorid: appointmentData['doctorId'],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Check Up',
                        style: TextStyle(color: Color(0xFF0EBE7E)),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  if (appointmentStatus != 'upcoming')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print(appointmentData['appointmentId']);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDoctor(
                                appointmentid: appointmentData['appointmentId'],
                                user: user,
                                doctorid: appointmentData['doctorId'],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Check Up',
                          style: TextStyle(color: Color(0xFF0EBE7E)),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date Not Available';
    return '${_getMonth(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Invalid Month';
    }
  }
}

class DateTimeCard extends StatelessWidget {
  final String date;
  final String time;

  const DateTimeCard({
    Key? key,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Color(MyColors.primary),
        ),
        SizedBox(width: 5),
        Text(
          date,
          style: TextStyle(
            color: Color(MyColors.header01),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 20),
        Icon(
          Icons.access_time,
          size: 16,
          color: Color(MyColors.primary),
        ),
        SizedBox(width: 5),
        Text(
          time,
          style: TextStyle(
            color: Color(MyColors.header01),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class MyColors {
  static const int bg = 0xFFF5F5F5;
  static const int bg02 = 0xFF0EBE7E;
  static const int primary = 0xFF0EBE7E;
  static const int header01 = 0xFF0EBE7E;
  static const int grey02 = 0xFFBDBDBD;
}

void main() {
  runApp(MaterialApp(
    title: 'Doctor Appointments Demo',
    home: CheckupAppointmentDoctor(),
  ));
}
