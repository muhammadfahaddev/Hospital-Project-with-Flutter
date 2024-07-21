import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/bottom.dart';
import 'package:hospital/doctorSelectTime.dart';
import 'HomeScreen.dart';
import 'package:hospital/modal/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Select_Details extends StatefulWidget {
  final String id;
  final String userId;

  const Select_Details({Key? key, required this.id, required this.userId})
      : super(key: key);

  @override
  State<Select_Details> createState() => _Select_DetailsState();
}

class _Select_DetailsState extends State<Select_Details> {
  String selectedItem = 'My child';
  late Future<DocumentSnapshot> _doctorDetailsFuture;
  String selectedOption = 'MySelf';

  // Controllers for text fields
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  User? currentUser;
  Map<String, dynamic>? userData;
  @override
  void initState() {
    super.initState();
    _doctorDetailsFuture = FirebaseFirestore.instance
        .collection('doctor_details')
        .doc(widget.id)
        .get();
    currentUser = FirebaseAuth.instance.currentUser;

    fetchAndDisplayUserData();
  }

  Future<void> fetchAndDisplayUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users_accounts')
                .doc(widget.userId)
                .get();

        if (snapshot.exists) {
          // Data exists for the user
          setState(() {
            userData = snapshot.data()!['user_details'];
          });
        } else {
          print('No user data found for UID: ${currentUser!.uid}');
        }
      } catch (e) {
        print("Error fetching and displaying user data: $e");
      }
    } else {
      print('No user currently signed in.');
    }
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _patientNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0EBE7F),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<DocumentSnapshot>(
          future: _doctorDetailsFuture,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Doctor not found'));
            }

            var doctor = Doctor.fromMap(
                snapshot.data!.data() as Map<String, dynamic>,
                snapshot.data!.id);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ButtonScreen()),
                              );
                            },
                          ),
                          const Text(
                            "Appointment",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  doctor.image,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    doctor.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    doctor.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 93, 111, 93),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFF6D060),
                                        size: 19,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFF6D060),
                                        size: 19,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFF6D060),
                                        size: 19,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFF6D060),
                                        size: 19,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFE2E5EA),
                                        size: 19,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 0, right: 20),
                              child: Icon(
                                Icons.favorite,
                                color: Color(0xFFFF0000),
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Who is this patient?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildOptionCard('MySelf'),
                              _buildOptionCard('Other'),
                            ],
                          ),
                        ),
                        if (selectedOption == 'Other') ...[
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Appointment For",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Form(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _patientNameController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(13)),
                                          ),
                                          labelText: "Patient Name",
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: _contactNumberController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(13)),
                                          ),
                                          labelText: "Contact Number",
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Relationship to Patient",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedItem,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      isExpanded: true,
                                      style: const TextStyle(
                                        color: Color(0xFF677294),
                                        fontSize: 16,
                                      ),
                                      underline: const SizedBox(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedItem = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'My child',
                                        'My father',
                                        'My mother',
                                        'Other'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                        Container(
                          width: 295,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                          child: 
                          ElevatedButton(
                            onPressed: () {
                              if (selectedOption == 'MySelf') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentScreen(
                                      doctor: doctor,
                                      patientName: userData!['name'],
                                      relationshipToPatient: "MySelf",
                                      id: widget.id,
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentScreen(
                                      doctor: doctor,
                                      patientName: _patientNameController.text,
                                      relationshipToPatient: selectedItem,
                                      id: widget.id,
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0EBE7F),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Next",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOptionCard(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Card(
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: selectedOption == option
                ? const Color(0xFF007D9A).withOpacity(0.3)
                : Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Text(
            option,
            style: TextStyle(
              color: selectedOption == option ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
