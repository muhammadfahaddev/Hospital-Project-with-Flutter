import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/modal/doctor.dart';
import 'package:hospital/scree/screens/home_screen.dart'; // Adjust path as per your project structure
import 'package:hospital/scree/models/data_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// File imports
import 'package:hospital/scree/screens/meeting_screen.dart';
import 'package:hospital/scree/services/join_service.dart';
import 'package:hospital/scree/services/sdk_initializer.dart';

class ScheduleTab1 extends StatefulWidget {
  final String uid;

  ScheduleTab1({Key? key, required this.uid}) : super(key: key);

  @override
  _ScheduleTab1State createState() => _ScheduleTab1State();
}

enum FilterStatus { Upcoming, Complete, Cancel }

class _ScheduleTab1State extends State<ScheduleTab1> {
  late UserDataStore _dataStore;
  bool isLoading = false;
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<Map<String, dynamic>> fetchedAppointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments(widget.uid, status);
    getPermissions();
  }

  void getPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
  }

  Future<void> fetchAppointments(
      String userId, FilterStatus filterStatus) async {
    String statusString;

    switch (filterStatus) {
      case FilterStatus.Upcoming:
        statusString = 'upcoming';
        break;
      case FilterStatus.Complete:
        statusString = 'complete';
        break;
      case FilterStatus.Cancel:
        statusString = 'cancel';
        break;
      default:
        statusString = 'upcoming'; // Default to 'Upcoming'
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: statusString)
          .get();

      List<Map<String, dynamic>> appointments = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? appointmentData =
            doc.data() as Map<String, dynamic>?;
        if (appointmentData != null) {
          // Log the document ID
          print('Fetched appointment with ID: ${doc.id}');
          appointmentData['appointmentId'] = doc.id; // Add document ID to data
          appointments.add(appointmentData);
        }
      }

      setState(() {
        fetchedAppointments = appointments;
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      // Handle error as needed
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      // Log the appointment ID being cancelled
      print('Attempting to cancel appointment with ID: $appointmentId');

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({
        'status': 'cancel',
      });

      print('Appointment cancelled successfully');
      await fetchAppointments(widget.uid, status);
    } catch (e) {
      // Log error message
      print('Error cancelling appointment: $e');
    }
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
              'Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(MyColors.bg02),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                status = filterStatus;
                                switch (filterStatus) {
                                  case FilterStatus.Upcoming:
                                    _alignment = Alignment.centerLeft;
                                    break;
                                  case FilterStatus.Complete:
                                    _alignment = Alignment.center;
                                    break;
                                  case FilterStatus.Cancel:
                                    _alignment = Alignment.centerRight;
                                    break;
                                  default:
                                    _alignment = Alignment.centerLeft;
                                }
                              });
                              fetchAppointments(widget.uid, filterStatus);
                            },
                            child: Center(
                              child: Text(
                                filterStatus.toString().split('.').last,
                                style: TextStyle(
                                  color: Color(MyColors.bg02),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: _alignment,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(MyColors.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.toString().split('.').last,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: fetchedAppointments.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> _schedule = fetchedAppointments[index];
                  String appointmentStatus = _schedule['status'];
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('doctor_details')
                        .doc(_schedule['doctorId'])
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(child: Text('Doctor not found'));
                      }

                      var doctor = Doctor.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>,
                        snapshot.data!.id,
                      );

                      return AppointmentCard(
                        appointmentData: _schedule,
                        doctor: doctor,
                        onCancel: () {
                          cancelAppointment(_schedule['appointmentId']);
                        },
                        appointmentStatus:
                            appointmentStatus, // Pass the status here
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
}

class AppointmentCard extends StatefulWidget {
  final Map<String, dynamic> appointmentData;
  final Doctor doctor;
  final VoidCallback? onCancel;
  final String appointmentStatus; // Add this line

  const AppointmentCard({
    Key? key,
    required this.appointmentData,
    required this.doctor,
    this.onCancel,
    required this.appointmentStatus, // Add this line
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  late UserDataStore _dataStore;
  bool isLoading = false;

  Future<bool> joinRoom() async {
    setState(() {
      isLoading = true;
    });
    await SdkInitializer.hmssdk.build();
    _dataStore = UserDataStore();

    //Here we are attaching a listener to our DataStoreClass
    _dataStore.startListen();
    bool isJoinSuccessful = await JoinService.join(SdkInitializer.hmssdk);
    if (!isJoinSuccessful) {
      setState(() {
        isLoading = false;
      });
      return false;
    }
    setState(() {
      isLoading = false;
    });
    return true;
  }

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
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/hospital-7aa99.appspot.com/o/profile_images%2F2024-06-16%2009%3A44%3A51.746563?alt=media&token=523a3dfd-4338-40a4-b273-cbb9e32a4a86"),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.name ?? 'Doctor Name Not Available',
                      style: TextStyle(
                        color: Color(MyColors.header01),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.doctor.title ?? 'Doctor Title Not Available',
                      style: TextStyle(
                        color: Color(MyColors.grey02),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            DateTimeCard(
              date: _formatDate(widget.appointmentData['appointmentDate']?.toDate()),
              time: widget.appointmentData['appointmentTime'] ??
                  'Appointment Time Not Available',
            ),
            SizedBox(height: 15),
            if (widget.appointmentStatus != 'complete') // Check appointment status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.appointmentStatus != 'cancel')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onCancel,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF0EBE7E)),
                        ),
                      ),
                    ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 200,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: <Widget>[
                                  ListTile(
                                    title: const Row(
                                      children: [
                                        Icon(Icons.video_call),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Start an instant meeting'),
                                      ],
                                    ),
                                    onTap: () async {
                                      bool isJoined = await joinRoom();
                                      if (isJoined) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ListenableProvider.value(
                                                        value: _dataStore,
                                                        child:
                                                            const MeetingScreen())));
                                      } else {
                                        const SnackBar(content: Text("Error"));
                                      }
                                    },
                                  ),
                                  ListTile(
                                    title: const Row(
                                      children: [
                                        Icon(Icons.close),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Close'),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text('Online Appointment',
                          style: TextStyle(color: Color(0xFF0EBE7E))),
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
