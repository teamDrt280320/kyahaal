import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kyahaal/Authentication/Screens/common.dart';
import 'package:kyahaal/Home/screens/HomeScreen.dart';
import 'package:kyahaal/global/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

StreamingSharedPreferences preferences;

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  UserBloc bloc = UserBloc();
  bool setupDone = true;
  setupStreamPreferences() async {
    preferences = await StreamingSharedPreferences.instance;
  }

  @override
  void initState() {
    super.initState();
    setupStreamPreferences();
    bloc.setupController.stream.listen((event) {
      setState(() {
        setupDone = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return user == null || !setupDone
        ? CommonAuthScreen(
            bloc: bloc,
          )
        : HomeScreen();
  }
}
