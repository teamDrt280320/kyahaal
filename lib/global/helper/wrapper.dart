import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kyahaal/Authentication/Screens/common.dart';
import 'package:kyahaal/Home/screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

StreamingSharedPreferences preferences;

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  setupStreamPreferences() async {
    preferences = await StreamingSharedPreferences.instance;
  }

  bool setupDone;
  @override
  void initState() {
    super.initState();
    setupStreamPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return user == null ? CommonAuthScreen() : HomeScreen();
  }
}
