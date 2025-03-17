import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

import 'package:flutter/material.dart';
import 'package:soccer/addgame.dart';
import 'package:soccer/stats.dart';
import 'package:soccer/scroll.dart';
import 'package:soccer/addteam.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

String user_name = "";
String searchValue = '';

double search_lat = 32.903021;
double search_lng = 35.287875;

FirebaseFirestore _firestore = FirebaseFirestore.instance;

TextEditingController search_controller = new TextEditingController();
final List<String> _suggestions = [
  'Afeganistan',
  'Albania',
  'Algeria',
  'Australia',
  'Brazil',
  'German',
  'Madagascar',
  'Mozambique',
  'Portugal',
  'Zambia'
];

class table extends StatefulWidget {
  const table({super.key});

  @override
  State<table> createState() => _table();
}

class _table extends State<table> with SingleTickerProviderStateMixin {
  var _currentIndex = 1;
  @override
  void initState() {
    firestart();
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //firestart();
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor: const Color.fromARGB(255, 255, 145, 112),
                body: SingleChildScrollView(
                  child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: Text(
                                          "בית",
                                          style: GoogleFonts.alata(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const homepage()));
                                        },
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "טבלה",
                                          style: GoogleFonts.alata(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const table()));
                                        },
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "הוספת משחק",
                                          style: GoogleFonts.alata(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const addgame()));
                                        },
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "רישום קבוצה",
                                          style: GoogleFonts.alata(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const addteam()));
                                        },
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "סטטיסטיקות",
                                          style: GoogleFonts.alata(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const stats()));
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "טבלת הטורניר",
                                        style: GoogleFonts.alata(
                                            fontSize: 25,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 80,
                                        width: 80,
                                        child: Image.asset(
                                          'assets/goal.gif',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            //color: const Color.fromARGB(255, 255, 255, 255),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 43, 43, 43),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 27, 27, 27),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 60,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.6,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          'הפסדים',
                                          style: GoogleFonts.alata(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          'תיקו',
                                          style: GoogleFonts.alata(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          'ניצחונות',
                                          style: GoogleFonts.alata(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          'נקודות',
                                          style: GoogleFonts.alata(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          'שם קבוצה',
                                          style: GoogleFonts.alata(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        )
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('teams')
                                        .orderBy("team_score", descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else
                                        return ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          children:
                                              snapshot.data!.docs.map((doc) {
                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  height: 60,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.6,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        doc["team_wins"]
                                                            .toString(),
                                                        style: GoogleFonts.alata(
                                                            fontSize: 16,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Text(
                                                        doc["team_draws"]
                                                            .toString(),
                                                        style: GoogleFonts.alata(
                                                            fontSize: 16,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Text(
                                                        doc["team_losses"]
                                                            .toString(),
                                                        style: GoogleFonts.alata(
                                                            fontSize: 16,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Text(
                                                        doc["team_score"]
                                                            .toString(),
                                                        style: GoogleFonts.alata(
                                                            fontSize: 16,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      Text(
                                                        doc["team_name"],
                                                        style: GoogleFonts.alata(
                                                            fontSize: 16,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                )),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }

  Future<void> firestart() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey:
            "AIzaSyAGm4tBklkJtvx-OyAB4NmmlXcrp6PC_jo", // paste your api key here
        appId:
            "1:530041174764:android:7aac2b6afb68759ede43c9", //paste your app id here
        messagingSenderId: "530041174764", //paste your messagingSenderId here
        projectId: "soccer-567af", //paste your project id here
      ),
    );
  }

  Container bottombar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 2),
              //set border radius to 50% of square height and width
              image: DecorationImage(
                image: Image.asset("assets/logo1.jpeg").image,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 2),
              //set border radius to 50% of square height and width
              image: DecorationImage(
                image: Image.asset("assets/logo2.jpeg").image,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 2),
              //set border radius to 50% of square height and width
              image: DecorationImage(
                image: Image.asset("assets/logo3.jpeg").image,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 2),
              //set border radius to 50% of square height and width
              image: DecorationImage(
                image: Image.asset("assets/logo4.jpeg").image,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 2),
              //set border radius to 50% of square height and width
              image: DecorationImage(
                image: Image.asset("assets/logo5.jpeg").image,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row headerBottomBarWidget() {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ],
    );
  }
}
