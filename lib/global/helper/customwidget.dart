import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/global/helper/palette.dart';
import 'package:kyahaal/global/services/auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'dart:math';

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
  FocusNode focusNode;
  bool readOnly;
  PhoneNumberTextField({
    Key key,
    this.controller,
    this.readOnly,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final SmsAutoFill _autoFill = SmsAutoFill();
    return PhoneFieldHint(
      focusNode: focusNode,
      readOnly: readOnly,
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
    @required this.controller3,
    @required this.image,
  }) : super(key: key);

  final StreamController<ErrorAnimationType> errorController;
  final TextEditingController controller2, controller3;
  final File image;
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
        bloc.verify(v, controller3.text, image);
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


class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    Key key,
    this.showIndicator = false,
    this.bubbleColor = const Color(0xFF646b7f),
    this.flashingCircleDarkColor = const Color(0xFF333333),
    this.flashingCircleBrightColor = const Color(0xFFaec1dd),
  }) : super(key: key);

  final bool showIndicator;
  final Color bubbleColor;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  AnimationController _appearanceController;

  Animation<double> _indicatorSpaceAnimation;

  Animation<double> _smallBubbleAnimation;
  Animation<double> _mediumBubbleAnimation;
  Animation<double> _largeBubbleAnimation;

  AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];

  @override
  void initState() {
    super.initState();

    _appearanceController = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _indicatorSpaceAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ).drive(Tween<double>(
      begin: 0.0,
      end: 60.0,
    ));

    _smallBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _mediumBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _largeBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.showIndicator) {
      _showIndicator();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _showIndicator();
      } else {
        _hideIndicator();
      }
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  void _showIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 750)
      ..forward();
    _repeatingController.repeat();
  }

  void _hideIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 150)
      ..reverse();
    _repeatingController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _indicatorSpaceAnimation,
      builder: (context, child) {
        return SizedBox(
          height: _indicatorSpaceAnimation.value,
          child: child,
        );
      },
      child: Stack(
        children: [
          _buildAnimatedBubble(
            animation: _smallBubbleAnimation,
            left: 8,
            bottom: 8,
            bubble: _buildCircleBubble(8),
          ),
          _buildAnimatedBubble(
            animation: _mediumBubbleAnimation,
            left: 10,
            bottom: 10,
            bubble: _buildCircleBubble(16),
          ),
          _buildAnimatedBubble(
            animation: _largeBubbleAnimation,
            left: 12,
            bottom: 12,
            bubble: _buildStatusBubble(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBubble({
    @required Animation<double> animation,
    @required double left,
    @required double bottom,
    @required Widget bubble,
  }) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            alignment: Alignment.bottomLeft,
            child: child,
          );
        },
        child: bubble,
      ),
    );
  }

  Widget _buildCircleBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.bubbleColor,
      ),
    );
  }

  Widget _buildStatusBubble() {
    return Container(
      width: 85,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: widget.bubbleColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFlashingCircle(0),
          _buildFlashingCircle(1),
          _buildFlashingCircle(2),
        ],
      ),
    );
  }

  Widget _buildFlashingCircle(int index) {
    return AnimatedBuilder(
      animation: _repeatingController,
      builder: (context, child) {
        final circleFlashPercent =
            _dotIntervals[index].transform(_repeatingController.value);
        final circleColorPercent = sin(pi * circleFlashPercent);

        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(widget.flashingCircleDarkColor,
                widget.flashingCircleBrightColor, circleColorPercent),
          ),
        );
      },
    );
  }
}

@immutable
class FakeMessage extends StatelessWidget {
  const FakeMessage({
    Key key,
    @required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
