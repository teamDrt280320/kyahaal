import 'package:get/get.dart';
import 'package:kyahaal/views/authentication/authentication.dart';
import 'package:kyahaal/views/home/home.dart';
import 'package:kyahaal/views/splashscreen/splashscreen.dart';

class RoutesName {
  static const String SPLASHPAGE = '/splash';
  static const String AUTHPAGE = '/auth';
  static const String HOMEPAGE = '/home';
}

final List<GetPage> appPages = [
  GetPage(
    name: RoutesName.HOMEPAGE,
    page: () => HomePage(),
  ),
  GetPage(
    name: RoutesName.SPLASHPAGE,
    page: () => SplashPage(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: RoutesName.AUTHPAGE,
    page: () => AuthorizationPage(),
  ),
];
