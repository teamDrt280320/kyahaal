import 'package:get/get.dart';
import 'package:kyahaal/utils/routes.dart';
import 'package:kyahaal/views/home.dart';

List<GetPage> get pages => [
      GetPage(name: Routes.placeHolder, page: () => PlaceHolderScreen()),
    ];
