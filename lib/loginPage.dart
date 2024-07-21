// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Zoom Clone',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: VideoConferenceApp(),
//     );
//   }
// }

// class VideoConferenceApp extends StatefulWidget {
//   @override
//   _VideoConferenceAppState createState() => _VideoConferenceAppState();
// }

// class _VideoConferenceAppState extends State<VideoConferenceApp> {
//   List<String> users = [];
//   int maxParticipants = 5;

//   void addUser(String userId) {
//     setState(() {
//       if (!users.contains(userId)) {
//         users.add(userId);
//       }
//     });
//   }

//   void removeUser(String userId) {
//     setState(() {
//       users.remove(userId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Zoom Clone'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text('User ${index + 1}: ${users[index]}'),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (users.length < maxParticipants) {
//                 // Generate a random user ID (you should have a better user ID generation logic)
//                 String newUserId = 'user_${users.length + 1}';
//                 addUser(newUserId);
//               } else {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: Text('Maximum participants reached'),
//                       content: Text('This conference supports a maximum of $maxParticipants participants.'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text('OK'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               }
//             },
//             child: Text('Add Participant'),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: ZegoUIKitPrebuiltVideoConference(
//               appID: appid,
//               appSign: appsign,
//               userID: 'user_1', // Replace with a proper user ID
//               userName: 'User 1', // Replace with a proper user name
//               isAudience: false, // Set to true if this user is an audience member
//               config: ZegoUIKitPrebuiltVideoConferenceConfig(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// const appid = 2138922223; // Replace with your actual ZEGOCLOUD app ID
// const appsign =
//     "9edc0dca6a6c94a243837194dc1244ed0bc2d8d712403fd767cb02f407fa6e62"; // Replace with your actual ZEGOCLOUD app sign
