import 'package:get/get.dart';
import 'package:kyahaal/utility/bindings/contactsbindings.dart';
import 'package:kyahaal/utility/bindings/initialbindings.dart';
import 'package:kyahaal/views/authentication/authentication.dart';
import 'package:kyahaal/views/completesetup/completesetup.dart';
import 'package:kyahaal/views/contacts/contacts.dart';
import 'package:kyahaal/views/home/home.dart';
import 'package:kyahaal/views/splashscreen/splashscreen.dart';

class RoutesName {
  static const String SPLASHPAGE = '/splash';
  static const String AUTHPAGE = '/auth';
  static const String HOMEPAGE = '/home';
  static const String COMPLETESETUPPAGE = '/complete-setup';
  static const String CONTACTS = '/friends';
}

final List<GetPage> appPages = [
  GetPage(
    name: RoutesName.HOMEPAGE,
    page: () => HomePage(),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: RoutesName.SPLASHPAGE,
    page: () => SplashPage(),
    transition: Transition.cupertino,
    fullscreenDialog: true,
  ),
  GetPage(
    name: RoutesName.AUTHPAGE,
    transition: Transition.cupertino,
    page: () => AuthorizationPage(),
  ),
  GetPage(
    name: RoutesName.COMPLETESETUPPAGE,
    transition: Transition.cupertino,
    page: () => CompleteSetup(),
  ),
  GetPage(
    name: RoutesName.CONTACTS,
    page: () => ContactsPage(),
    transition: Transition.cupertino,
    bindings: [
      InitialBindins(),
      ContactsBinding(),
    ],
  ),
];
