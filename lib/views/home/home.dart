import 'package:flutter/material.dart';
import 'package:kyahaal/views/home/components/desktop.dart';
import 'package:kyahaal/views/home/components/mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: HomePageMobile(),
      desktop: HomePageDesktop(),
      tablet: HomePageDesktop(),
    );
  }
}
