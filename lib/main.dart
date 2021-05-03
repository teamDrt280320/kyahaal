import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kyahaal/views/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(KyaHaal());
}

class KyaHaal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KyaHaal',
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
      home: HomePage(),
    );
  }
}
