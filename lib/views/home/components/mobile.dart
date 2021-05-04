import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyahaal/controllers/authcontroller.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePageMobile extends StatefulWidget {
  @override
  _HomePageMobileState createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              MdiIcons.logout,
              color: kDarkPurple,
            ),
            onPressed: () {
              _authController.signOut();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: kPrimaryLightColor,
                radius: 96,
                child: Obx(
                  () => ClipOval(
                    child: _authController.firestoreUser.value == null ||
                            _authController.firestoreUser.value.imgUrl == null
                        ? Icon(
                            LineIcons.user,
                            size: 96,
                            color: kDarkPurple,
                          )
                        : Image.network(
                            _authController.firestoreUser.value.imgUrl,
                          ),
                  ),
                ),
              ),
            ),
            Obx(
              () => Text(
                _authController.firestoreUser.value == null
                    ? ''
                    : _authController.firestoreUser.value.uName ?? '',
              ),
            ),
            Obx(
              () => Text(
                _authController.firestoreUser.value == null
                    ? ''
                    : _authController.firestoreUser.value.status ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
