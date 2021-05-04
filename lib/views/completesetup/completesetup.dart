import 'package:flutter/material.dart';
import 'package:kyahaal/views/completesetup/components/mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CompleteSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CompleteSetupPageMobile(),
    );
  }
}
