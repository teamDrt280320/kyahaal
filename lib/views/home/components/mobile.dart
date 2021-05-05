import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/controllers/authcontroller.dart';
import 'package:kyahaal/utility/pages.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:kyahaal/views/widgets.dart/customdrawer.dart';

class HomePageMobile extends StatefulWidget {
  @override
  _HomePageMobileState createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(authController: _authController),
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: false,
        title: Text(
          'KyaHaal',
          style: GoogleFonts.openSans(
            color: kDarkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: kDarkPurple,
            ),
            onPressed: () {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor.withOpacity(0.25),
        child: Icon(
          Icons.message_outlined,
          color: kPrimaryDarkColor,
        ),
        elevation: 0.0,
        onPressed: () {
          Get.toNamed(
            RoutesName.CONTACTS,
          );
        },
      ),
      body: Container(),
    );
  }
}
