import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  Future<void> uploadFile() async {
    if (_image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final profileImagesRef = storageRef.child('profile_images/${DateTime.now().toString()}');

    try {
      await profileImagesRef.putFile(_image!);
      final fileURL = await profileImagesRef.getDownloadURL();

      setState(() {
        _uploadedFileURL = fileURL;
      });

      await FirebaseFirestore.instance.collection('users').doc('your_user_id').set({
        'profileImageURL': _uploadedFileURL,
      }, SetOptions(merge: true));

      print("File Uploaded Successfully");
    } catch (e) {
      print("File Upload Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ?const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/9187/9187604.png"),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(_image!),
                  ),
            SizedBox(height: 20),
            _uploadedFileURL == null ? Container() : Image.network(_uploadedFileURL!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
