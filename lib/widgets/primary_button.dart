import 'package:flutter/material.dart';
import 'package:kyahaal/utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bgColor = brandBlack,
    this.fgColor = Colors.white,
    this.size = const Size(140, 50),
  })  : showLoader = false,
        super(key: key);

  const PrimaryButton.loader({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bgColor = brandBlack,
    this.fgColor = Colors.white,
    this.size = const Size(140, 50),
    this.showLoader = false,
  }) : super(key: key);

  final GestureTapCallback onPressed;
  final String text;
  final Color bgColor, fgColor;
  final Size size;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgColor),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          foregroundColor: MaterialStateProperty.all(fgColor),
        ),
        onPressed: onPressed,
        child: showLoader
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(fgColor))
            : Text(text),
      ),
    );
  }
}
