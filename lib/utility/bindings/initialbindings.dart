import 'package:get/get.dart';
import 'package:kyahaal/controllers/authcontroller.dart';

class InitialBindins extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
