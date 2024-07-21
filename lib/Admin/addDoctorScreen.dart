import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  // Various controllers for form inputs
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _experiencedoctor = TextEditingController();
  final TextEditingController _doctorTitle = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _uploadedFileURL;


  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Add Doctor'),
            expandedHeight: 170,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: AssetImage('assets/Images/3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      FadeInUp(
                        duration: Duration(milliseconds: 1700),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: getImage,
                                child: _image == null
                                    ? const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            "https://cdn-icons-png.flaticon.com/512/9187/9187604.png"),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(_image!),
                                      ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color(0xFF0EBE7E),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xFF0EBE7E),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          _uploadedFileURL == null
                                              ? Container()
                                              : Image.network(
                                                  _uploadedFileURL!),
                                          buildTextFormField(
                                            controller: _fullname,
                                            hintText: "Full name",
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter Name';
                                              }
                                              return null;
                                            },
                                          ),
                                          buildTextFormField(
                                            controller: _username,
                                            hintText:
                                                "Email (example@famhospital.fam)",
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your email';
                                              }
                                              String pattern =
                                                  r'^[a-zA-Z0-9._]+@famhospital\.fam$';
                                              RegExp regex = RegExp(pattern);
                                              if (!regex.hasMatch(value)) {
                                                return 'Please enter a valid email address';
                                              }
                                              return null;
                                            },
                                          ),
                                          buildTextFormField(
                                            controller: _experiencedoctor,
                                            hintText: "Enter experience",
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter experience';
                                              }
                                              return null;
                                            },
                                          ),
                                          buildTextFormField(
                                            controller: _doctorTitle,
                                            hintText: "Specialty ",
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter Specialty ';
                                              }
                                              return null;
                                            },
                                            onTap: () {},
                                          ),
                                          buildTextFormField(
                                            controller: _password,
                                            hintText: "Password",
                                            obscureText: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your password';
                                              }
                                              return null;
                                            },
                                          ),
                                          buildTextAreaFormField(
                                            controller: _description,
                                            keyboardType: TextInputType
                                                .multiline, // Use comma instead of semicolon
                                            hintText: "Description",
                                            obscureText: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your Description';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: MaterialButton(
                          onPressed: () async {
                            await _register();
                          },
                          color: Color(0xFF0EBE7E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          height: 50,
                          child: const Center(
                            child: Text(
                              "Add Doctor",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    void Function()? onTap,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF0EBE7E),
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
        validator: validator,
        onTap: onTap,
        obscureText: obscureText,
      ),
    );
  }

  Widget buildTextAreaFormField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
    void Function()? onTap,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF0EBE7E),
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
        validator: validator,
        onTap: onTap,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Doctor"),
          content: const Text("Your account has been successfully add doctor"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pushNamed(context, '/Buttonscreen');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _username.text.trim(),
        password: _password.text.trim(),
      );

      if (userCredential.user != null) {
        await _uploadImageAndSaveUserData(userCredential.user!.uid);
        _showSuccessDialog();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added Successful!')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImageAndSaveUserData(String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final profileImagesRef =
          storageRef.child('profile_images/${DateTime.now().toString()}');

      await profileImagesRef.putFile(_image!);
      _uploadedFileURL = await profileImagesRef.getDownloadURL();

      Map<String, dynamic> signupData = {
        'id': uid,
        'image': _uploadedFileURL,
        'name': _fullname.text.trim(),
        'username': _username.text.trim(),
        'experiencedoctor': _experiencedoctor.text.trim(),
        'doctorTitle': _doctorTitle.text.trim(),
        'description': _description.text.trim(),
        'password': _password.text.trim(),
      };

      await FirebaseFirestore.instance
          .collection('doctor_details')
          .doc(uid)
          .set({
        'doctor_details': signupData,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error uploading image and saving user data: $e");
      throw e;
    }
  }
}
