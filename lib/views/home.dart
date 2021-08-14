import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyahaal/controllers/auth.dart';
import 'package:kyahaal/utils/constants.dart';
import 'package:kyahaal/widgets/parent_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return ParentWidget.custom(
      systemColor: brandBlack,
      appBar: AppBar(
        backgroundColor: brandBlack,
        brightness: Brightness.dark,
        actions: [
          GestureDetector(
            onTap: () {
              _authController.signOut();
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      child: Container(),
    );
  }
}
