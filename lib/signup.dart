import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Images/login1.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
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
                                            : Image.network(_uploadedFileURL!),
                                        buildTextFormField(
                                          controller: _fullname,
                                          hintText: "Full name",
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your Name';
                                            }
                                            return null;
                                          },
                                        ),
                                        buildTextFormField(
                                          controller: _email,
                                          hintText: "Email",
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            return null;
                                          },
                                        ),
                                        buildTextFormField(
                                          controller: _phoneController,
                                          hintText:
                                              "Phone No e.g., +923002233442",
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your phone';
                                            }
                                            return null;
                                          },
                                        ),
                                        buildTextFormField(
                                          controller: _dobController,
                                          hintText: "Date of birth",
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your Date of Birth';
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1940),
                                              lastDate: DateTime(2101),
                                            );

                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              _dobController.text =
                                                  formattedDate;
                                            }
                                          },
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
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInUp(
                      duration: Duration(milliseconds: 1700),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(color: Color(0xFF0EBE7E)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: MaterialButton(
                        onPressed: () async {
                              _register();
                        },
                        color: Color(0xFF0EBE7E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Container(
                        width: 600,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0EBE7E),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SignInButton(
                          Buttons.google,
                          text: 'Sign up with Google',
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Account Created"),
          content: const Text("Your account has been successfully signed up"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
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
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (userCredential.user != null) {
        await _uploadImageAndSaveUserData(userCredential.user!.uid);
        _showSuccessDialog();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up Successful!')),
        );
      }
    } catch (e) {
      _handleAuthError(e);
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
        'user': uid,
        'image': _uploadedFileURL,
        'name': _fullname.text.trim(),
        'email': _email.text.trim(),
        'phoneno': _phoneController.text.trim(),
        'dob': _dobController.text.trim(),
        'password': _password.text.trim(),
      };

      await FirebaseFirestore.instance
          .collection('users_accounts')
          .doc(uid)
          .set({
        'user_details': signupData,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error uploading image and saving user data: $e");
      throw e;
    }
  }

  void _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email is already in use. Please log in.')),
        );
      } else if (error.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
    print('Registration failed: $error');
  }
}
