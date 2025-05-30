import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCalling extends StatefulWidget {
  final String username;
  final String id;

  const VideoCalling({Key? key, required this.id, required this.username})
      : super(key: key);

  @override
  State<VideoCalling> createState() => _VideoCallingState();
}

final String localUserID = math.Random().nextInt(10000).toString();

class _VideoCallingState extends State<VideoCalling> {
  final callIDTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: callIDTextCtrl,
                decoration: const InputDecoration(
                  labelText: 'call id',
                  hintText: 'call id',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CallPage(
                        callID: callIDTextCtrl.text,
                        userId: widget.id,
                        userName: widget.username,
                      );
                    }),
                  );
                },
                child: const Text("join",style: TextStyle(fontSize: 20,color: Colors.white),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CallPage extends StatelessWidget {
  final String callID;
  final String userId;
  final String userName;

  const CallPage({
    Key? key,
    required this.callID,
    required this.userId,
    required this.userName,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 2138922223,
        appSign:
            '9edc0dca6a6c94a243837194dc1244ed0bc2d8d712403fd767cb02f407fa6e62',
        userID: userId,
        userName: userName,
        callID: callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          
      ),
    );
  }
}
