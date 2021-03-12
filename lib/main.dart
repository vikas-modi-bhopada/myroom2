import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'HouseFiles/ListofHouses.dart';
import 'welcomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Roomi",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.purple,
        accentColor: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    // Checking Wheather user is already loged in or not
    // If loged in then navigate to list of Rooms
    // if not then navigate to welcome page
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
         /* FirebaseUser user = snapshot.data;*/
          return ListOfHouse();
        } else {
          return WelcomePage();
        }
      },
    );
  }
}
