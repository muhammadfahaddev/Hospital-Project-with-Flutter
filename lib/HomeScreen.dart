import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'doctorBook.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Your existing methods for signInWithGoogle, signInWithEmailPassword, etc.
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // await _authMethods.signOut();
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.setBool('isLoggedIn', false);
                // Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: Home_Screen(),
      ),
    );
  }
}

class Home_ScreenContent extends StatefulWidget {
  Home_ScreenContent({Key? key}) : super(key: key);

  @override
  State<Home_ScreenContent> createState() => _Home_ScreenContentState();
}

class _Home_ScreenContentState extends State<Home_ScreenContent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0EBE7E),
                  Color(0xFF007D9AD),
                ],
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/Image/logo.png',
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
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
                      height: size.height * 0.15,
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
                                      backgroundImage:
                                          AssetImage("assets/Images/1.png"),
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
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          left: size.width * 0.03,
                          right: size.width * 0.03),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(right: size.width * 0.15),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BookAppointment()),
                                        );
                                      },
                                      child: Card(
                                        elevation: 1,
                                        child: SizedBox(
                                          width: size.width * 0.25,
                                          height: size.width * 0.25,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/Icon/appointment (1).png',
                                                width: size.width * 0.1,
                                                height: size.width * 0.1,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text(
                                                "Appointment",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Add your onTap logic here
                                },
                                child: Card(
                                  child: SizedBox(
                                    width: size.width * 0.25,
                                    height: size.width * 0.25,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/Icon/medical-book.png',
                                          width: size.width * 0.1,
                                          height: size.width * 0.1,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Bookings",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(right: size.width * 0.15),
                                child: GestureDetector(
                                  onTap: () {
                                    // Add your onTap logic here
                                  },
                                  child: Card(
                                    elevation: 1,
                                    child: SizedBox(
                                      width: size.width * 0.25,
                                      height: size.width * 0.25,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/Icon/medical-report.png',
                                            width: size.width * 0.1,
                                            height: size.width * 0.1,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Medical Record",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Card(
                                  child: SizedBox(
                                    width: size.width * 0.25,
                                    height: size.width * 0.25,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/Icon/doctor.png',
                                          width: size.width * 0.1,
                                          height: size.width * 0.1,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "My Doctor",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.02,
                          left: size.width * 0.03,
                          right: size.width * 0.03),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Popular Doctor",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "See all >",
                                  style: TextStyle(
                                    color: Color(0xFF677294),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.06),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width * 0.5,
                                    height: size.height * 0.33,
                                    child: Card(
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Image.asset(
                                              'assets/Images/3.jpeg',
                                              height: size.height * 0.22,
                                              width: size.width * 0.5,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "DR. M Fahad",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text(
                                            "Medicine Specialist",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF677294),
                                            ),
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFE2E5EA),
                                                size: 19,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // card 2
                                  Container(
                                    width: size.width * 0.5,
                                    height: size.height * 0.33,
                                    child: Card(
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Image.asset(
                                              'assets/Images/3.jpeg',
                                              height: size.height * 0.22,
                                              width: size.width * 0.5,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "DR. Mehboob",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text(
                                            "Medicine Specialist",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF677294),
                                            ),
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFE2E5EA),
                                                size: 19,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // card 3
                                  Container(
                                    width: size.width * 0.5,
                                    height: size.height * 0.33,
                                    child: Card(
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Image.asset(
                                              'assets/Images/3.jpeg',
                                              height: size.height * 0.22,
                                              width: size.width * 0.5,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "DR. M Fahad",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text(
                                            "Medicine Specialist",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF677294),
                                            ),
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFF6D060),
                                                size: 19,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color(0xFFE2E5EA),
                                                size: 19,
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home_Screen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: <Widget>[
                    Home_ScreenContent(),
                    // Doctor(),
                    Center(child: Text("Profile")),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
                      offset: Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                      _animationController.forward(from: 0.0);
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                      backgroundColor: Colors.red,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: "Doctor",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_rounded),
                      label: "Chat",
                    ),
                  ],
                  selectedItemColor: Color(0xFF0EBE7E),
                  unselectedItemColor: Color(0xFF0858EA9),
                  backgroundColor: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
