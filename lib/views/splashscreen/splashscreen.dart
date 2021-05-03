import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/utility/sized_config.dart';
import 'package:kyahaal/utility/utility.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(150),
              child: Image.asset('assets/images/logo.png'),
            ),
            AutoSizeText(
              'KyaHaal',
              style: GoogleFonts.openSans(
                color: kSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
              minFontSize: 18,
            )
          ],
        ),
      ),
    );
  }
}
