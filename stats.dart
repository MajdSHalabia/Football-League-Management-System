import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:soccer/addgame.dart';
import 'package:soccer/scroll.dart';
import 'package:soccer/addteam.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

String user_name = "";
String searchValue = '';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

double search_lat = 32.903021;
double search_lng = 35.287875;
late Future<int> documents;

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

class stats extends StatefulWidget {
  const stats({super.key});

  @override
  State<stats> createState() => _stats();
}

class _stats extends State<stats> with SingleTickerProviderStateMixin {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  var _currentIndex = 1;
  @override
  void initState() {
    countDocuments();
    data = [
      _ChartData('David', 25),
      _ChartData('Steve', 38),
      _ChartData('Jack', 34),
      _ChartData('Others', 52)
    ];
    _tooltip = TooltipBehavior(enable: true);

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
    // documents = num_games();
    //firestart();
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 10, 4, 58),
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
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Text(
                                    "בית",
                                    style: GoogleFonts.alata(
                                        fontSize: 12,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => const homepage()));
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    "טבלה",
                                    style: GoogleFonts.alata(
                                        fontSize: 12,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) => const stats()));
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    "הוספת משחק",
                                    style: GoogleFonts.alata(
                                        fontSize: 12,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
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
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
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
                                        fontSize: 16,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold),
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
                                  "סטטיסטיקות",
                                  style: GoogleFonts.alata(
                                      fontSize: 25,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(
                                    'assets/line-chart.gif',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: FittedBox(
                            child: Column(
                              children: [
                                Text(
                                  "כמות משחקים החודש",
                                  style: GoogleFonts.alata(
                                      fontSize: 20,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  countDocuments().toString(),
                                  style: GoogleFonts.alata(
                                      fontSize: 20,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: FittedBox(
                            child: Column(
                              children: [
                                Text(
                                  "הכי הרבה ניצחונות",
                                  style: GoogleFonts.alata(
                                      fontSize: 20,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.normal),
                                ),
                                SfCircularChart(
                                    tooltipBehavior: _tooltip,
                                    series: <CircularSeries<_ChartData,
                                        String>>[
                                      DoughnutSeries<_ChartData, String>(
                                          dataSource: data,
                                          xValueMapper: (_ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (_ChartData data, _) =>
                                              data.y,
                                          name: 'Gold')
                                    ])
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: FittedBox(
                            child: Column(
                              children: [
                                Text(
                                  "כמות הפסדים",
                                  style: GoogleFonts.alata(
                                      fontSize: 20,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.normal),
                                ),
                                SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    primaryYAxis: NumericAxis(
                                        minimum: 0, maximum: 40, interval: 10),
                                    tooltipBehavior: _tooltip,
                                    series: <CartesianSeries<_ChartData,
                                        String>>[
                                      ColumnSeries<_ChartData, String>(
                                          dataSource: data,
                                          xValueMapper: (_ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (_ChartData data, _) =>
                                              data.y,
                                          name: 'Gold',
                                          color: Color.fromRGBO(8, 142, 255, 1))
                                    ])
                              ],
                            ),
                          )),
                    ),
                  ],
                )),
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

  Future<int> countDocuments() async {
    QuerySnapshot _myDoc = await _firestore.collection('games').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    print("99999999999999");
    print(_myDocCount.length); // Count of Documents in Collection
    return _myDocCount.length;
  }
}
