import 'package:flutter/material.dart';
import 'package:kyahaal/views/authentication/components/desktop.dart';
import 'package:kyahaal/views/authentication/components/mobile.dart';
import 'package:kyahaal/views/authentication/components/tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AuthorizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: AuthPageMobile(),
      desktop: AuthPageDesktop(),
      tablet: AuthPageTablet(),
    );
  }
}
