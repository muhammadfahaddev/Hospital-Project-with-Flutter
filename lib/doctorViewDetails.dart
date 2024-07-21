import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hospital/Doctor_Select%20_details.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:hospital/modal/doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SliverDoctorDetail extends StatelessWidget {
  final String id;
  final String userId;
  const SliverDoctorDetail({Key? key, required this.id, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('doctor_details')
            .doc(id)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
              snapshot.data!.data() as Map<String, dynamic>, snapshot.data!.id);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text('Detail Doctor'),
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "assets/Images/3.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DetailDoctorCard(doctor: doctor),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          NumberCard(
                              label: 'Patients',
                              value: '${doctor.experience}+'),
                          SizedBox(width: 15),
                          NumberCard(
                              label: 'Experiences',
                              value: '${doctor.experience} years'),
                          SizedBox(width: 15),
                          NumberCard(label: 'Rating', value: '4.0'),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'About Doctor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        doctor.description, // Replace with actual description
                        style: TextStyle(
                          color: Color(0xff918fa5),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        'Location',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25),
                      DoctorLocation(),
                      SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF007D9AD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Select_Details(id: id,userId: userId,)),
                          );
                        },
                        child: const Text('Book Appointment'),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DoctorLocation extends StatelessWidget {
  const DoctorLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(51.5, -0.09),
            zoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
      ),
    );
  }
}

// class DoctorInfo extends StatelessWidget {
//   const DoctorInfo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         NumberCard(label: 'Patients', value: '${doctor.}+'),
//         SizedBox(width: 15),
//         NumberCard(label: 'Experiences', value: '10 years'),
//         SizedBox(width: 15),
//         NumberCard(label: 'Rating', value: '4.0'),
//       ],
//     );
//   }
// }

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xffe8eafe),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(0xff9796af),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: Color(0xff151a56),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailDoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DetailDoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      color: Color(0xff151a56),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    doctor.title,
                    style: TextStyle(
                      color: Color(0xff9796af),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                doctor.image, 
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
