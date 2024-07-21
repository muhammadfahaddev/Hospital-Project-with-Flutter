import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hospital/Reviewdoctor.dart';
import 'package:hospital/ViewRecord.dart';
import 'package:hospital/Widget/GridviewCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/chatdoctor.dart';
import 'package:hospital/doctorBook.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  User? currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
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
                .doc(currentUser!.uid)
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

  final List<String> imgList = [
    'assets/Sliders/slider2.png',
    'assets/Sliders/slider1.png',
    'assets/Sliders/slider3.png',
    'assets/Sliders/slider4.png',
  ];

  final List<String> descriptionList = [
    'State-of-the-Art Healthcare Facility',
    'Compassionate Patient Care',
    'Experienced and Dedicated Team',
    '24/7 Emergency Support',
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<Widget> generateImageTiles() {
    return imgList.asMap().entries.map((entry) {
      int index = entry.key;
      String element = entry.value;

      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(element, fit: BoxFit.cover),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  descriptionList[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
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
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Appointments'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.folder),
                    title: Text('Records'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.medical_services),
                    title: Text('Consultations'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt),
                    title: Text('Billing'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Resources'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('Messages'),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      // Handle tap
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
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout tap
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF007D9AD).withOpacity(0.1),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF007D9AD).withOpacity(0.1),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.21,
                          width: size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0EBE7E),
                                Color(0xFF007D9AD),
                              ],
                            ),
                          ),
                          child: Center(
                            child: userData != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Hi ${userData!['name']}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const Text(
                                                "Find Your Doctor",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    userData!['image']),
                                                radius: 40,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  // Using Slider
                  Column(
                    children: [
                      CarouselSlider(
                        items: generateImageTiles(),
                        carouselController: _controller,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.map((url) {
                          int index = imgList.indexOf(url);
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(index),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Color(0xFF007D9AD)
                                    : Color(0xFF007D9AD).withOpacity(0.1),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          "Quick Actions",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        BuildGridItem(
                          icon: Icons.calendar_today,
                          title: 'Appointment',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookAppointment(),
                              ),
                            );
                          },
                        ),
                        BuildGridItem(
                          icon: Icons.folder,
                          title: 'View Records',
                          onTap: () {
                            print("object");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewReport(userid: currentUser!.uid),
                              ),
                            );
                          },
                        ),
                        BuildGridItem(
                          icon: Icons.medical_services,
                          title: 'Medical Services',
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        BuildGridItem(
                          icon: Icons.reviews,
                          title: 'Review',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewDoctor(),
                              ),
                            );
                          },
                        ),
                        BuildGridItem(
                          icon: Icons.alarm,
                          title: 'Checkup Reminder',
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        BuildGridItem(
                          icon: Icons.message,
                          title: 'Messages',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => chatDoctor(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Upcoming Appointments",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              "See all",
                              style: TextStyle(color: Color(0xFF007D9AD)),
                            ))
                      ],
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: DetailDoctorCard(),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Text(
                        //   "Top Doctors",
                        //   style: TextStyle(
                        //       fontSize: 18, fontWeight: FontWeight.w500),
                        // ),
                        // TextButton(
                        //     onPressed: () {},
                        //     child: const Text(
                        //       "See all",
                        //       style: TextStyle(color: Color(0xFF007D9AD)),
                        //     ))
                      ],
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: TopListDoctor(),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class DetailDoctorCard extends StatefulWidget {
  DetailDoctorCard({Key? key}) : super(key: key);

  @override
  State<DetailDoctorCard> createState() => _DetailDoctorCard();
}

class _DetailDoctorCard extends State<DetailDoctorCard> {
 
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Future<List<Map<String, dynamic>>> fetchAppointments(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'upcoming')
          .limit(3) // Limit to 3 appointments
          .get();

      List<Map<String, dynamic>> appointments = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? appointmentData =
            doc.data() as Map<String, dynamic>?;
        if (appointmentData != null) {
          appointmentData['appointmentId'] = doc.id; // Add document ID to data
          appointments.add(appointmentData);
        }
      }
      return appointments;
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchAppointments(currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No upcoming appointments'));
        } else {
          List<Map<String, dynamic>> appointments = snapshot.data!;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> appointment = appointments[index];
              return DoctorAppointmentCard(appointment: appointment);
            },
          );
        }
      },
    );
  }
}

class DoctorAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const DoctorAppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Muhammad Fahad', // You might want to replace this with actual doctor name from data
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Heart Specialist', // You might want to replace this with actual doctor specialty from data
                          style: TextStyle(
                            color: Color(0xff9796af),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image(
                    image: AssetImage(
                        'assets/Images/3.jpg'), // Update with actual doctor image if available
                    width: 100,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, color: Color(0xFF007D9AD)),
                  SizedBox(width: 5),
                  Text(
                    appointment['appointmentDate']
                        .toString()
                        .split(' ')[0], // Format the date properly
                    style: TextStyle(
                      color: Color(0xFF007D9AD),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.timer, color: Color(0xFF007D9AD)),
                  SizedBox(width: 5),
                  Text(
                    appointment['appointmentTime'] ?? 'Time not available',
                    style: TextStyle(
                      color: Color(0xFF007D9AD),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 
class TopListDoctor extends StatelessWidget {
  const TopListDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctor_details').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final doctors = snapshot.data!.docs;

        return ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctorData = doctors[index].data() as Map<String, dynamic>;
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('doctorId', isEqualTo: doctors[index].id)
                  .get(),
              builder: (context, reviewSnapshot) {
                if (!reviewSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final reviews = reviewSnapshot.data!.docs;
                final reviewCount = reviews.length;
                final averageRating = reviews.isNotEmpty
                    ? reviews
                            .map((doc) => doc['rating'] as int)
                            .reduce((a, b) => a + b) /
                        reviewCount
                    : 0.0;

                return Container(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image(
                                image: NetworkImage(doctorData['image']),
                                width: 100,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctorData['name'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      doctorData['doctorTitle'],
                                      style: TextStyle(
                                        color: Color(0xff9796af),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rate,
                                          color: Color.fromARGB(255, 255, 230, 8),
                                        ),
                                        Text(
                                          averageRating.toStringAsFixed(1),
                                          style: TextStyle(
                                            color: Color(0xff9796af),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            '$reviewCount Reviews',
                                            style: TextStyle(
                                              color: Color(0xff9796af),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 75),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}