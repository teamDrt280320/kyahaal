import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kyahaal/utils/initial_bindings.dart';
import 'package:kyahaal/utils/pages.dart';
import 'package:kyahaal/utils/routes.dart';

class KyaHaal extends StatelessWidget {
  InitialBindings get initialBindings => InitialBindings();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Material App',
      getPages: pages,
      initialBinding: initialBindings,
      initialRoute: Routes.placeHolder,
    );
  }
}
