import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital/Reviewsystem.dart';
import 'package:hospital/modal/Report.dart';
import 'package:hospital/modal/Doctor.dart';

class ViewReport extends StatefulWidget {
  final String userid;

  const ViewReport({Key? key, required this.userid}) : super(key: key);

  @override
  State<ViewReport> createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Doctor> _doctors = [];
  Map<String, int> doctorReportsCount = {};
  bool _isLoading = true;
  String _errorMessage = '';
  User? user;
  List<Report> _reports = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchReports();
    _authenticateAndFetchDoctors();
  }

  void totalPatient(String doctorId) async {
    try {
      QuerySnapshot totalPatient = await FirebaseFirestore.instance
          .collection('reports')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      setState(() {
        doctorReportsCount[doctorId] = totalPatient.size;
      });

      print('Fetched reports for doctor $doctorId');
    } catch (e) {
      print('Error fetching reports: $e');
    }
  }

  Future<void> fetchReports() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('userId', isEqualTo: widget.userid)
          .get();

      List<Report> reports = querySnapshot.docs
          .map((doc) =>
              Report.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      setState(() {
        _reports = reports;
        _isLoading = false;
      });

      _calculateDoctorReportsCount(reports);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching reports: $e';
        _isLoading = false;
      });
    }
  }

  void _calculateDoctorReportsCount(List<Report> reports) {
    doctorReportsCount.clear();
    reports.forEach((report) {
      String doctorId = report.doctorId;
      if (!doctorReportsCount.containsKey(doctorId)) {
        doctorReportsCount[doctorId] = 0;
      }
      doctorReportsCount[doctorId] = doctorReportsCount[doctorId]! + 1;
    });

    // After calculating, update the list of doctors
    _updateDoctorsList();
  }

  void _updateDoctorsList() {
    // Filter doctors who have reports
    _doctors = _doctors
        .where((doctor) => doctorReportsCount.containsKey(doctor.id))
        .toList();

    // Set state to trigger rebuild with updated list
    setState(() {});
  }

  Future<void> _authenticateAndFetchDoctors() async {
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      await _fetchDoctors();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error authenticating: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchDoctors() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('doctor_details').get();
      List<Doctor> doctors = snapshot.docs
          .map((doc) =>
              Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Set _doctors to all doctors initially
      _doctors = doctors;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching doctors: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
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
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 10.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      "View Report",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white60,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.3,
                  ),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search, color: Colors.black),
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _doctors.length,
                          itemBuilder: (context, index) {
                            return _buildDoctorCard(_doctors[index]);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    if (!doctorReportsCount.containsKey(doctor.id) ||
        doctorReportsCount[doctor.id] == 0) {
      return SizedBox.shrink();
    }

    List<Report> doctorReports = _reports
        .where((report) => report.doctorId == doctor.id)
        .toList();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    doctor.image,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      doctor.title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      "${doctor.experience} years Experience",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${doctorReportsCount[doctor.id] ?? 0} patient stories',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: doctorReports.length,
              itemBuilder: (context, index) {
                Report report = doctorReports[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewReportDetails(report: report),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(report.description),
                            subtitle: Text(
                                "Additional description here"),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                report.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ViewReportDetails extends StatelessWidget {
  final Report report;

  const ViewReportDetails({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            report.description,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Image.network(
            report.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
          SizedBox(height: 10),
          Text(
            'Additional details here',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
