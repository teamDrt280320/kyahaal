import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyahaal/utility/bindings/initialbindings.dart';
import 'package:kyahaal/utility/pages.dart';
import './utility/utility.dart';

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
      theme: theme(),
      onGenerateTitle: (context) => 'KyaHaal',
      initialRoute: RoutesName.SPLASHPAGE,
      initialBinding: InitialBindins(),
      getPages: appPages,
    );
  }
}
