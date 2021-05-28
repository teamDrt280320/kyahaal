import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kyahaal/modals/contact.dart';
import 'package:kyahaal/modals/message.dart';
import 'package:kyahaal/utility/bindings/initialbindings.dart';
import 'package:kyahaal/utility/pages.dart';
import './utility/utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as encrypter;
import 'package:pointycastle/asymmetric/api.dart';

var localStorage;
encrypter.RsaKeyHelper helper;
RSAPrivateKey privateKey;
Box<MessageModal> messageBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize();
  Hive.registerAdapter(ContactsModalAdapter());
  Hive.registerAdapter(MessageModalAdapter());
  await Hive.initFlutter();
  await Hive.openBox<ContactsModal>('friends');
  // messageBox = await Hive.openBox<MessageModal>('messages');
  localStorage = GetStorage('preferences');
  helper = encrypter.RsaKeyHelper();
  var key = localStorage.read('privateKey');
  print(key);
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

// ca-app-pub-6236661812187085/7896354398
