import 'package:get/get.dart';
import 'package:kyahaal/utils/routes.dart';
import 'package:kyahaal/views/home.dart';
import 'package:kyahaal/views/login.dart';
import 'package:kyahaal/views/plaeholder.dart';

List<GetPage> get pages => [
      GetPage(
        name: Routes.placeHolder,
        page: () => const PlaceHolderScreen(showloader: true),
        transition: Transition.cupertino,
      ),
      GetPage(
        name: Routes.home,
        page: () => HomeScreen(),
        transition: Transition.cupertino,
      ),
      GetPage(
        name: Routes.login,
        page: () => LoginScreen(),
        transition: Transition.cupertino,
      ),
    ];
