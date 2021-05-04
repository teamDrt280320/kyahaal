import 'package:flutter/material.dart';
import 'package:kyahaal/utility/sized_config.dart';
import 'package:kyahaal/utility/utility.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
