import 'package:get/get.dart';
import 'package:kyahaal/controllers/authcontroller.dart';
import 'package:kyahaal/controllers/contactscontroller.dart';

class InitialBindins extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(ContactsController());
  }
}
