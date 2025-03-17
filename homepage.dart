import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'addgame.dart';
import 'table.dart';
import 'stats.dart';
import 'scroll.dart';
import 'addteam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepage();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _homepage extends State<homepage> with SingleTickerProviderStateMixin {
  Future<Map<String, dynamic>>? _london;
  Future<Map<String, dynamic>>? _paris;
  Future<Map<String, dynamic>>? _telaviv;

  var _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _london = fetchWeather('London'); // ברירת מחדל
    _paris = fetchWeather('Paris');
    _telaviv = fetchWeather('Amsterdam');

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
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 117, 163, 255),
          body: DecoratedBox(
            // BoxDecoration takes the image
            decoration: BoxDecoration(
                // Image set to background of the body
                /*image: DecorationImage(
                  opacity: 0.3,
                  image: AssetImage("assets/back3.jpg"),
                  fit: BoxFit.cover),*/
                ),
            child: SingleChildScrollView(
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
                                height: 70,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      "בית",
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
                                                  const homepage()));
                                    },
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      "טבלה",
                                      style: GoogleFonts.alata(
                                          fontSize: 12,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) => const table()));
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
                                              builder: (_) => const addgame()));
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
                                              builder: (_) => const addteam()));
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
                                              builder: (_) => const stats()));
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
                                    "תוצאות משחקי הטורניר",
                                    style: GoogleFonts.alata(
                                        fontSize: 25,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'assets/field.gif',
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
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream:
                                    _firestore.collection('games').snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else
                                    return ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: snapshot.data!.docs.map((doc) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              height: 60,
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    doc["win_team"],
                                                    style: GoogleFonts.alata(
                                                        fontSize: 16,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 33, 129, 67),
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        doc["score"],
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
                                                        doc["date"],
                                                        style: GoogleFonts.alata(
                                                            fontSize: 16,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    doc["lose_team"],
                                                    style: GoogleFonts.alata(
                                                        fontSize: 16,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 66, 66),
                                                        fontWeight:
                                                            FontWeight.normal),
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
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FutureBuilder<Map<String, dynamic>>(
                              future: _london,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text("non"),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Center(child: Text('No data'));
                                } else {
                                  final data = snapshot.data!;
                                  final weather =
                                      data['weather'][0]['description'];
                                  final temp = data['main']['temp'];
                                  final city = data['name'];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        city,
                                        style: GoogleFonts.alata(
                                            fontSize: 30,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        '${temp}°C',
                                        style: GoogleFonts.alata(
                                            fontSize: 30,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        weather,
                                        style: GoogleFonts.alata(
                                            fontSize: 20,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: _paris,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text("non"),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Center(child: Text('No data'));
                                } else {
                                  final data = snapshot.data!;
                                  final weather =
                                      data['weather'][0]['description'];
                                  final temp = data['main']['temp'];
                                  final city = data['name'];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        city,
                                        style: GoogleFonts.alata(
                                            fontSize: 30,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        '${temp}°C',
                                        style: GoogleFonts.alata(
                                            fontSize: 30,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        weather,
                                        style: GoogleFonts.alata(
                                            fontSize: 20,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                              future: _telaviv,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text("non"),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Center(child: Text('No data'));
                                } else {
                                  final data = snapshot.data!;
                                  final weather =
                                      data['weather'][0]['description'];
                                  final temp = data['main']['temp'];
                                  final city = data['name'];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        city,
                                        style: GoogleFonts.alata(
                                            fontSize: 30,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        '${temp}°C',
                                        style: GoogleFonts.alata(
                                            fontSize: 30,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        weather,
                                        style: GoogleFonts.alata(
                                            fontSize: 20,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    );
  }

  Future<void> firestart() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey:
            "AIzaSyBL8Btp6WGvX4gg7cc9Y7xlhdgpQte0hPo", // paste your api key here
        appId:
            "1:437948257567:android:e6006ec1aa52ad7050cc2a", //paste your app id here
        messagingSenderId: "437948257567", //paste your messagingSenderId here
        projectId: "shipapi-e8516", //paste your project id here
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

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    const apiKey =
        'c098de3594d6a3fd61174cb281160cdf'; // קבל מפתח API מ-OpenWeatherMap
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
