import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyahaal/modals/contact.dart';
import 'package:kyahaal/utility/bindings/initialbindings.dart';
import 'package:kyahaal/utility/pages.dart';
import './utility/utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Hive.registerAdapter(ContactsModalAdapter());
  await Hive.initFlutter();
  await Hive.openBox<ContactsModal>('friends');
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
