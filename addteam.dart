import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:soccer/addgame.dart';
import "homepage.dart";
import 'package:flutter/widgets.dart';
import 'table.dart';
import 'stats.dart';
import 'scroll.dart';
import 'addteam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

String user_name = "";
String searchValue = '';

double search_lat = 32.903021;
double search_lng = 35.287875;

TextEditingController teams_name = new TextEditingController();
TextEditingController teams_players = new TextEditingController();
TextEditingController teams_stadium = new TextEditingController();

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
List<String> genderOptions = [
  'Airforce',
  'Military',
  'Navy',
];
String type = "Airforce";

class addteam extends StatefulWidget {
  const addteam({super.key});

  @override
  State<addteam> createState() => _addteam();
}

class _addteam extends State<addteam> with SingleTickerProviderStateMixin {
  var _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firestart();
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 88, 92),
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
                              height: 70,
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
                                            builder: (_) => const table()));
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
                                        fontSize: 16,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold),
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
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "רישום קבוצה",
                                  style: GoogleFonts.alata(
                                      fontSize: 25,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(
                                    'assets/customer.gif',
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
                      height: 20,
                    ),
                    Container(
                      //color: const Color.fromARGB(255, 255, 255, 255),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "שם הקבוצה",
                              style: GoogleFonts.alata(
                                  fontSize: 25,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: teams_name,
                              style: TextStyle(color: Colors.white),
                              decoration: new InputDecoration(
                                hintText: "לדוגמה: מכבי חיפה",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "מספר שחקנים",
                              style: GoogleFonts.alata(
                                  fontSize: 25,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: teams_players,
                              style: TextStyle(color: Colors.white),
                              decoration: new InputDecoration(
                                hintText: "לדוגמה: 12 ",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "שם איצטדיון בית",
                              style: GoogleFonts.alata(
                                  fontSize: 25,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: teams_stadium,
                              style: TextStyle(color: Colors.white),
                              decoration: new InputDecoration(
                                hintText: "לדוגמה: סמי עופר",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal)),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("teams")
                                      .doc(teams_name.text)
                                      .set({
                                    'team_name': teams_name.text,
                                    'team_players': teams_players.text,
                                    'team_stadium': teams_stadium.text,
                                    "team_score": 0,
                                    "team_wins": 0,
                                    "team_losses": 0,
                                    "team_draws": 0,
                                  }, SetOptions(merge: true)).then((value) {
                                    //Do your stuff.
                                  });
                                  ok_dialog(context);
                                },
                                child: const Text('הוסף קבוצה'),
                              ),
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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Application completed"),
      content: Container(
        height: 100,
        child: Column(
          children: [
            Text(
                "Thank you for registering for the 2024 Project UpStart Hackathon. "),
            SizedBox(
              height: 10,
            ),
            Text("A confirmation and invitation has been sent to your email. "),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ok_dialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "אישור",
        style: GoogleFonts.alata(
            fontSize: 16,
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.normal),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const homepage()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "הפעולה בוצעה",
        style: GoogleFonts.alata(
            fontSize: 16,
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.normal),
      ),
      content: Text(
        "הינך חוזר לעמוד הבית",
        style: GoogleFonts.alata(
            fontSize: 16,
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.normal),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
