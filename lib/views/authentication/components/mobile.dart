import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/controllers/authcontroller.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:kyahaal/views/widgets.dart/customkeyboard.dart';

class AuthPageMobile extends StatefulWidget {
  @override
  _AuthPageMobileState createState() => _AuthPageMobileState();
}

class _AuthPageMobileState extends State<AuthPageMobile> {
  AuthController _authController = Get.find();
  addText(String text) {
    if (!_authController.codeSent.value) {
      if (_authController.phoneController.text.length < 10)
        _authController.phoneController.text =
            _authController.phoneController.text + text;
    } else {
      if (_authController.otpController.text.length < 6)
        _authController.otpController.text =
            _authController.otpController.text + text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Continue with Phone',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            color: kDarkPurple,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            buildVector(),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                boxShadow: boxShadow,
                color: Colors.white,
              ),
              height: getProportionateScreenHeight(80),
              child: Row(
                children: [
                  Flexible(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Obx(
                          () => _authController.codeSent.value
                              ? SizedBox.shrink()
                              : buildPrefixText(),
                        ),
                        Obx(
                          () => _authController.codeSent.value
                              ? buildOtpField()
                              : buildPhoneField(),
                        ),
                      ],
                    ),
                  ),
                  buildContinueButton(),
                ],
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Expanded(
              child: CustomKeyboard(
                onPresses: (s) {
                  addText(s);
                },
                onBackPressed: () {
                  if (!_authController.codeSent.value) {
                    if (_authController.phoneController.text.isNotEmpty)
                      _authController.phoneController.text =
                          _authController.phoneController.text.substring(
                        0,
                        _authController.phoneController.text.length - 1,
                      );
                  } else {
                    if (_authController.otpController.text.isNotEmpty)
                      _authController.otpController.text =
                          _authController.otpController.text.substring(
                        0,
                        _authController.otpController.text.length - 1,
                      );
                  }
                },
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
          ],
        ),
      ),
    );
  }

  Center buildVector() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: defaultRadius,
          boxShadow: boxShadow,
          image: DecorationImage(
            alignment: FractionalOffset.topCenter,
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/auth.webp',
            ),
          ),
        ),
        height: SizeConfig.screenHeight * 0.33,
        width: SizeConfig.screenWidth * 0.7,
      ),
    );
  }

  Builder buildPrefixText() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, top: 16.0, right: 8.0),
          child: Text(
            '+91 ',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      },
    );
  }

  IgnorePointer buildPhoneField() {
    return IgnorePointer(
      child: TextFormField(
        controller: _authController.phoneController,
        readOnly: true,
        maxLength: 10,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          prefixText: '+91 ',
          prefixStyle: TextStyle(color: Colors.transparent),
          labelText: 'Enter your phone',
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        cursorColor: kPrimaryColor,
        cursorRadius: Radius.circular(25),
        cursorWidth: 1,
        showCursor: true,
      ),
    );
  }

  IgnorePointer buildOtpField() {
    return IgnorePointer(
      child: TextFormField(
        controller: _authController.otpController,
        readOnly: false,
        maxLength: 6,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          prefixStyle: TextStyle(color: Colors.transparent),
          labelText: 'Enter OTP',
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        cursorColor: kPrimaryColor,
        cursorRadius: Radius.circular(25),
        cursorWidth: 1,
        showCursor: true,
      ),
    );
  }

  Padding buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            kPrimaryLightColor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            Size(
              70,
              50,
            ),
          ),
          elevation: MaterialStateProperty.resolveWith(
              (states) => getElevation(states)),
          shadowColor: MaterialStateProperty.all(
            kPrimaryDarkColor.withOpacity(0.2),
          ),
        ),
        onPressed: () {
          if (_authController.codeSent.value) {
            _authController.linkWithCredential();
          } else {
            _authController.sendOtp();
          }
        },
        child: Obx(
          () => _authController.signingIn.value
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(kPrimaryDarkColor),
                  ),
                )
              : Text(
                  'Continue',
                  style: GoogleFonts.openSans(
                    color: kPrimaryDarkColor,
                  ),
                ),
        ),
      ),
    );
  }
}
