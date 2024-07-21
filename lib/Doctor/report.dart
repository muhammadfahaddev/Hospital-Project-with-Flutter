import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital/Doctor/checkupPage.dart';
import 'package:hospital/doctorSelectTime.dart';
import 'package:hospital/modal/doctor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hospital/modal/user.dart';

class ReportDoctor extends StatefulWidget {
  final UserModel user;
  final String appointmentid;
  final String doctorid;

  ReportDoctor({
    required this.user,
    required this.appointmentid,
    required this.doctorid,
  });

  @override
  State<ReportDoctor> createState() => _ReportDoctorState();
}

class _ReportDoctorState extends State<ReportDoctor> {
  bool passVisible = true;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  File? image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> fetchedAppointments = [];
  String selectedItem = 'My Self';
  String selectedOption = 'Yes';
  UserModel? userModel;
  Doctor? doctor1;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    fetchAppointments(widget.doctorid);
    _fetchDoctorData();
    print(widget.user);
    print(doctor1);
    print(fetchedAppointments);
  }

  Future<void> _fetchDoctorData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('doctor_details')
          .doc(widget.doctorid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          doctor1 = Doctor.fromMap(
              documentSnapshot.data()! as Map<String, dynamic>,
              widget.doctorid);
        });
      } else {
        print('Doctor document does not exist');
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users_accounts')
          .doc(widget.user.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          userModel = UserModel.fromMap(
              userSnapshot.data()! as Map<String, dynamic>, userSnapshot.id);
          print(userModel);
        });
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchAppointments(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: userId)
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

      print('Query snapshot length: ${querySnapshot.docs.length}');
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  bool isImageSelected() {
    return image != null;
  }

  Future<String> uploadImage(File image, String userId) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('user_images/$userId.jpg');
    await storageRef.putFile(image);
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  Future<void> uploadReport() async {
    if (!_formKey.currentState!.validate()) {}

    if (!isImageSelected()) {
      showImageRequiredDialog(
          context, 'Image Required', 'Please upload an image.');
    }

    setState(() {
      loading = true;
    });

    try {
      String imageUrl = await uploadImage(image!, widget.user.uid);
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentid)
          .update({
        'status': 'complete',
      });

      await FirebaseFirestore.instance.collection('reports').add({
        'userId': widget.user.uid,
        'doctorId': widget.doctorid,
        'appointmentId': widget.appointmentid,
        'description': _descriptionController.text,
        'image': imageUrl,
        'checkupTime': DateTime.now(),
      });

      setState(() {
        loading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentScreen(
            doctor: doctor1!,
            patientName: widget.user.name,
            relationshipToPatient: selectedItem,
            id: widget.doctorid,
            userId: widget.user.uid,
          ),
        ),
      );
    } catch (e) {
      print('Error uploading report: $e');
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> uploadReportNo() async {
    if (!_formKey.currentState!.validate()) {}

    if (!isImageSelected()) {
      showImageRequiredDialog(
          context, 'Image Required', 'Please upload an image.');
    }

    setState(() {
      loading = true;
    });

    try {
      String imageUrl = await uploadImage(image!, widget.user.uid);
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentid)
          .update({
        'status': 'complete',
      });

      await FirebaseFirestore.instance.collection('reports').add({
        'userId': widget.user.uid,
        'doctorId': widget.doctorid,
        'appointmentId': widget.appointmentid,
        'description': _descriptionController.text,
        'image': imageUrl,
        'checkupTime': DateTime.now(),
      });

      setState(() {
        loading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckupAppointmentDoctor(),
        ),
      );
    } catch (e) {
      print('Error uploading report: $e');
      setState(() {
        loading = false;
      });
    }
  }

  void showImageRequiredDialog(
      BuildContext context, String title, String message) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
        backgroundColor: Color.fromARGB(255, 159, 238, 151),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      widget.user.dob,
                      style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 36, 34, 31),
                      ),
                    ),
                    SizedBox(height: 40),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    backgroundColor:
                                        Color.fromARGB(255, 46, 158, 91),
                                    appBar: AppBar(
                                      backgroundColor:
                                          const Color.fromARGB(255, 55, 38, 12),
                                      title: const Text(
                                        'Profile Picture',
                                        style: TextStyle(
                                          color: Color(0xFF0E234F),
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    body: Center(
                                      child: Hero(
                                        tag: 'picture',
                                        child: image == null
                                            ? GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  color: Colors.grey[300],
                                                  height: 200,
                                                  width: 200,
                                                  child: Center(
                                                    child: Text(
                                                      'Tap to upload image',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Image.file(
                                                image!,
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                                width: double.infinity,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 400,
                            height: 400,
                            child: Hero(
                              tag: 'picture',
                              child: Container(
                                child: image != null
                                    ? Image.file(image!, fit: BoxFit.cover)
                                    : GestureDetector(
                                        onTap: () {
                                          showCustomImageModalBottomSheet(
                                              context);
                                        },
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            border: Border.all(
                                              width: 2,
                                              color: const Color.fromARGB(
                                                  255, 51, 53, 54),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Tap to upload image',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Enter description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Do you want another appointment?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildOptionCard('Yes'),
                        SizedBox(width: 20),
                        _buildOptionCard('No'),
                      ],
                    ),
                    if (selectedOption == 'No') ...[
                      SizedBox(height: 20),
                      const Text(
                        "Appointment For",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: uploadReportNo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0EBE7F),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        child: Text(
                          loading ? 'Uploading...' : 'Okay',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    if (selectedOption == 'Yes') ...[
                      ElevatedButton(
                        onPressed: uploadReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0EBE7F),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        child: Text(
                          loading ? 'Uploading...' : 'Next',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                    if (userModel != null) ...[
                      SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
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
            borderRadius: BorderRadius.circular(12),
            color: selectedOption == option
                ? Color(0xFF007D9A).withOpacity(0.3)
                : Colors.white,
          ),
          padding: EdgeInsets.all(16),
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

  void showCustomImageModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF007D9A).withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 5),
              Text(
                'Select Image From',
                style: TextStyle(
                  color: Color(0xFF007D9A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 15,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/Images/1.jpg',
                                width: 80,
                                height: 70,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                color: Color(0xFF0EBE7E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 15,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/9/99/LEI0440_Leica_IIIf_chrom_-_Sn._580566_1951-52-M39_Blitzsynchron_front_view-6531_hf-.jpg',
                                width: 80,
                                height: 70,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Camera',
                              style: TextStyle(
                                color: Color(0xFF0EBE7E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0EBE7E),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
