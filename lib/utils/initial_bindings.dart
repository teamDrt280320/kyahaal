import 'package:get/instance_manager.dart';
import 'package:kyahaal/controllers/auth.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
