import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kyahaal/Authentication/Screens/common.dart';
import 'package:kyahaal/Home/Bloc/messageBloc.dart' as messageBloc;
import 'package:kyahaal/Home/screens/Contacts.dart';
import 'package:kyahaal/Home/screens/HomeScreen.dart';
import 'package:kyahaal/Home/screens/settings.dart';
import 'package:kyahaal/global/helper/strings.dart';
import 'package:kyahaal/global/helper/wrapper.dart';
import 'package:kyahaal/global/services/auth.dart';
import 'package:provider/provider.dart';

import 'Home/Bloc/contactsBloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  messageBloc.setupDatabase();
  setupDatabase();
  setupDatabase();
  await Firebase.initializeApp();
  runApp(KyaHaal());
}

class KyaHaal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: user,
      child: MaterialApp(
        title: KHStrings.app_name,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              textTheme: TextTheme()),
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/home': (context) => HomeScreen(title: KHStrings.app_name),
          '/contacts': (context) => Contacts(),
          '/settings': (context) => Settings(),
          '/common': (context) => CommonAuthScreen(),
        },
      ),
    );
  }
}
