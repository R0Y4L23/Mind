// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, no_leading_underscores_for_local_identifiers

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "./home.dart";
import "./authScreen.dart";

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _checkIfLoggedIn() {
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.getBool("loggedIn") ?? false) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Auth()));
        }
      });
    }

    _checkIfLoggedIn();

    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
