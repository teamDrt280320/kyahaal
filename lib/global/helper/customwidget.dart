import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/global/helper/palette.dart';
import 'package:kyahaal/global/services/auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:math' as math;

import 'package:sms_autofill/sms_autofill.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: 2.5,
      style: GoogleFonts.openSans(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}

class StepsText extends StatelessWidget {
  final String text;

  const StepsText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text,
              textScaleFactor: 2.5,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                //fontSize: 19,
              ),
            ),
            Text(
              "/2",
              textScaleFactor: 1.2,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        Text(
          "STEPS",
          textScaleFactor: 1.2,
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class ProfilePIcture extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  const ProfilePIcture({
    Key key,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  //spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(6, 4), // changes position of shadow
                ),
              ],
            ),
            child: child ??
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: KHColor.brandColorPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: 140 * math.pi / 180,
                        child: Icon(
                          Icons.attach_file_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            child != null
                ? "Gosh!! You Really are\ngorgeous"
                : "Upload a Profile Picture\n(optional)",
            textScaleFactor: 1.1,
            maxLines: 2,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class PhoneNumberTextField extends StatelessWidget {
  TextEditingController controller;
  PhoneNumberTextField({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhoneFieldHint(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        counter: null,
        counterStyle: TextStyle(
          color: Colors.amber,
        ),
        prefixText: "+91",
        prefixStyle: GoogleFonts.openSans(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        labelText: "Phone Number".toUpperCase(),
        labelStyle: GoogleFonts.openSans(
          color: Colors.white,
          letterSpacing: 1.1,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        focusColor: Colors.orange,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber,
            width: 2.2,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white30,
            width: 2.2,
          ),
        ),
      ),
    );
  }
}

class OTP extends StatelessWidget {
  const OTP({
    Key key,
    @required this.errorController,
    @required this.controller2,
    @required this.bloc,
  }) : super(key: key);

  final StreamController<ErrorAnimationType> errorController;
  final TextEditingController controller2;
  final UserBloc bloc;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        activeColor: Colors.grey,
        selectedColor: Colors.amber,
        inactiveColor: Colors.grey,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
      ),
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      //enableActiveFill: true,
      errorAnimationController: errorController,
      controller: controller2,
      textStyle: TextStyle(
        color: Colors.amber,
      ),
      onCompleted: (v) {
        bloc.verify(v);
      },
      onChanged: (value) {},
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        return true;
      },
      appContext: context,
    );
  }
}

class KHErrorWidget extends StatelessWidget {
  const KHErrorWidget({
    Key key,
    @required this.error,
  }) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        color: Colors.red,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.white,
              ),
              Text(
                error?.toUpperCase()?.replaceAll("-", " ") ?? "",
                textScaleFactor: 1.3,
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
