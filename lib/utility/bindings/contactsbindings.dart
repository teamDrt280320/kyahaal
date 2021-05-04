import 'package:get/get.dart';
import 'package:kyahaal/controllers/contactscontroller.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ContactsController());
  }
}
