import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<home> {
  User? currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchAndDisplayUserData();
  }

  Future<void> fetchAndDisplayUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Fetch user data from Firestore using currentUser.uid
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
          // Handle case where no data is found for the UID
        }
      } catch (e) {
        print("Error fetching and displaying user data: $e");
        // Handle any errors that occur during the fetch process
      }
    } else {
      print('No user currently signed in.');
      // Handle case where no user is signed in
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: userData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (userData!['image'] != null)
                    Image.network(
                      userData!['image'],
                      height: 100,
                      width: 100,
                    ),
                  Text('Name: ${userData!['name']}'),
                  Text('Email: ${userData!['email']}'),
                  Text('Phone Number: ${userData!['phoneno']}'),
                  Text('DOB: ${userData!['dob']}'),
                  Text('Password: ${userData!['password']}'),
                  // Add more fields as needed
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
