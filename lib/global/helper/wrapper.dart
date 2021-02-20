import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kyahaal/Authentication/Screens/common.dart';
import 'package:kyahaal/Home/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return user == null ? CommonAuthScreen() : HomeScreen();
  }
}
