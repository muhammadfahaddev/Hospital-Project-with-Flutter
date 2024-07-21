import 'package:hospital/Onboarding%20screen-02.dart';
import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: -104,
            top: -20,
            child: Container(
              width: 342,
              height: 342,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(14, 190, 126, 1),
                    spreadRadius: 40,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 34,
            top: 145,
            child: Container(
              width: 336,
              height: 336,
              child: Image.asset('assets/Images/1.png'),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(14, 190, 126, 1),
                    Color.fromRGBO(11, 176, 116, 1)
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 450),
                  child: SizedBox(
                    child: Text(
                      "Find Trusted Doctors",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: 274,
                  child: const Text(
                    "Discover reliable medical professionals near you for comprehensive care and trusted guidance in healthcare.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(103, 114, 148, 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 295,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => OnboardingScreen2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0EBE7F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              //   Container(
              //     width: 295,
              //     height: 54,
              //     child: TextButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, '/login');
              //       },
              //       style: TextButton.styleFrom(
              //         backgroundColor: Color(0xFF677294),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //       child: const Text(
              //         "Skip",
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Color(0xFF677294),
              //         ),
              //       ),
              //     ),
              //   ),
               ],
            ),
          ),
          Positioned(
            right: -104,
            bottom: -20,
            child: Container(
              width: 216,
              height: 216,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(14, 190, 126, .1),
                    spreadRadius: 40,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
