import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/bottom.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hospital/modal/doctor.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  final Doctor doctor;
  final String patientName;
  final String relationshipToPatient;
  final String id;
  final String userId;

  const AppointmentScreen({
    Key? key,
    required this.doctor,
    required this.patientName,
    required this.relationshipToPatient,
    required this.id,
    required this.userId,
  }) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}
enum FilterStatus { Upcoming, Complete, Cancel }

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '02:00 PM';
  String selectedReminder = '25 Min';
  List<String> availableTimes = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableTimes();
  }

  List<String> getInitialAvailableTimes() {
    return ['10:00 AM', '12:00 PM', '02:00 PM', '03:00 PM', '04:00 PM'];
  }

  Future<void> _fetchAvailableTimes() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: widget.doctor!.id)
          .where('appointmentDate', isEqualTo: selectedDate)
          .get();

      List<String> bookedTimes = snapshot.docs.map((doc) {
        return doc['appointmentTime'] as String;
      }).toList();

      List<String> initialTimes = getInitialAvailableTimes();
      List<String> filteredTimes =
          initialTimes.where((time) => !bookedTimes.contains(time)).toList();

      setState(() {
        availableTimes = filteredTimes;
      });
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  bool isValidAppointment() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat.jm();

    String normalizedTime = selectedTime.trim();

    DateTime selectedTimeParsed;
    try {
      selectedTimeParsed = format.parse(normalizedTime);
    } catch (e) {
      print('Error parsing selected time: $e');
      return false;
    }

    DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTimeParsed.hour,
      selectedTimeParsed.minute,
    );

    return selectedDateTime.isAfter(now);
  }

  void handleConfirm(BuildContext context) async {
    CollectionReference appointments =
        FirebaseFirestore.instance.collection('appointments');

    await appointments.add({
      'appointmentId':appointments.id,
      'doctorId': widget.doctor.id,
      'userId': widget.userId,
      'doctorName': widget.doctor.name,
      'patientName': widget.patientName,
      'relationshipToPatient': widget.relationshipToPatient,
      'appointmentDate': selectedDate,
      'appointmentTime': selectedTime,
      'reminder': selectedReminder,
      'status':'upcoming'
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment Confirmed'),
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ButtonScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0EBE7F).withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalendar(),
                SizedBox(height: 16),
                _buildAvailableTimes(),
                SizedBox(height: 16),
                _buildReminderOptions(),
                SizedBox(height: 16),
                _buildConfirmButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(), // Ensure the first selectable day is today
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: selectedDate,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (selectedDay.isAfter(DateTime.now())) {
            // Allow selection only if the date is in the future
            setState(() {
              selectedDate = selectedDay;
              _fetchAvailableTimes(); // Fetch available times for the new date
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a future date.')),
            );
          }
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableTimes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available Time',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        if (availableTimes.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                availableTimes.map((time) => _buildTimeOption(time)).toList(),
          ),
        if (availableTimes.isEmpty)
          Text(
            'No available times for selected date.',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildTimeOption(String time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = time;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedTime == time ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(
              color: selectedTime == time ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildReminderOptions() {
    List<String> reminders = ['30 Min', '40 Min', '25 Min', '10 Min', '35 Min'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reminder Me Before',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: reminders.map((reminder) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedReminder = reminder;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: selectedReminder == reminder
                      ? Colors.green
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  reminder,
                  style: TextStyle(
                    color: selectedReminder == reminder
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => handleConfirm(context),
        child: Text('Confirm Appointment'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
