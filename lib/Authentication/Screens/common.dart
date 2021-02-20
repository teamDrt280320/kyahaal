import 'package:flutter/material.dart';
import 'package:kyahaal/Authentication/Screens/register.dart';
import 'package:kyahaal/global/helper/palette.dart';

class CommonAuthScreen extends StatefulWidget {
  @override
  _CommonAuthScreenState createState() => _CommonAuthScreenState();
}

class _CommonAuthScreenState extends State<CommonAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: KHColor.brandColorPrimary,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RegisterUser(),
          );
        },
      ),
    );
  }
}
