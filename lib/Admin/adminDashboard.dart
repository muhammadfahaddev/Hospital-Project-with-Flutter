import 'package:flutter/material.dart';

class AdminDashBoardScreen extends StatefulWidget {
  const AdminDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashBoardScreen> createState() => _AdminDashBoardScreenState();
}

class _AdminDashBoardScreenState extends State<AdminDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF007D9AD).withOpacity(0.1),
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.21,
                        width: size.width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0EBE7E),
                              Color(0xFF007D9AD),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Hi Fahad",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Find Your Doctor",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage("assets/Images/1.png"),
                                        radius: 40,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                // Using Slider
                // const Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(right: 20),
                //       child: Text(
                //         "Quick Actions",
                //         textAlign: TextAlign.start,
                //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                //       ),
                //     ),
                //   ],
                // ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                //   child: GridView.count(
                //     crossAxisCount: 1,
                //     crossAxisSpacing: 5,
                //     mainAxisSpacing: 5,
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     children: const [
                //       SizedBox(
                //         height: 50, // Set the height of the SizedBox
                //         child: BuildGridItem(
                //           icon: Icons.fullscreen,
                //           title: 'Total Doctors',
                //           totalno: '7',
                //         ),
                //       ),
                //       SizedBox(
                //         height: 50, // Set the height of the SizedBox
                //         child: BuildGridItem(
                //           icon: Icons.calendar_month,
                //           title: 'Today Appointment',
                //           totalno: '7',
                //         ),
                //       ),
                //       SizedBox(
                //         height: 50, // Set the height of the SizedBox
                //         child: BuildGridItem(
                //           icon: Icons.medical_services,
                //           title: 'Total Patients',
                //           totalno: '7',
                //         ),
                //       ),
                //       SizedBox(
                //         height: 50, // Set the height of the SizedBox
                //         child: BuildGridItem(
                //           icon: Icons.health_and_safety,
                //           title: 'Today Appointment',
                //           totalno: '7',
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Top List Doctor",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "See all",
                          style: TextStyle(color: Color(0xFF007D9AD)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DetailDoctorCard(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Top Doctors",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "See all",
                          style: TextStyle(color: Color(0xFF007D9AD)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TopListDoctor(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailDoctorCard extends StatelessWidget {
  const DetailDoctorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Muhammad Fahad',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Heart Specialist',
                          style: TextStyle(
                            color: Color(0xff9796af),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image(
                    image: AssetImage('assets/Images/3.jpg'),
                    width: 100,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, color: Color(0xFF007D9AD)),
                  SizedBox(width: 5),
                  Text(
                    "2024-06-10",
                    style: TextStyle(
                      color: Color(0xFF007D9AD),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.timer, color: Color(0xFF007D9AD)),
                  SizedBox(width: 5),
                  Text(
                    "09am - 9:30Am",
                    style: TextStyle(
                      color: Color(0xFF007D9AD),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopListDoctor extends StatelessWidget {
  const TopListDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('assets/Images/3.jpg'),
                    width: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. Muhammad Fahad',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Heart Specialist',
                            style: TextStyle(
                              color: Color(0xff9796af),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rate,
                                    color: Color.fromARGB(255, 255, 230, 8),
                                  ),
                                  Text(
                                    '4.6',
                                    style: TextStyle(
                                      color: Color(0xff9796af),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  '50 Reviews',
                                  style: TextStyle(
                                    color: Color(0xff9796af),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildGridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String totalno;

  const BuildGridItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.totalno,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25,
            color: Color(0xFF007D9AD),
          ),
          SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            totalno,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
