import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: -104,
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
              decoration:const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/Images/3.jpeg',
                  fit: BoxFit.cover,
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
                      "Easy Appointments",
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
                    "Simple scheduling made effortless: Easy Appointments streamlines booking tasks with user-friendly features.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(103, 114, 148, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: 295,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/screen');
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
              //   TextButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/login');
              //     },
              //     style: TextButton.styleFrom(
              //       backgroundColor:
              //           Color(0xFF677294), // Set backgroundColor color for TextButton
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     child: const Text(
              //       "Skip",
              //       style: TextStyle(
              //         fontSize: 14,
              //         color: Color(0xFF677294),
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
