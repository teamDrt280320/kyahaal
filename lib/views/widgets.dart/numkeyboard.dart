import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/utility/utility.dart';

class CustNumKeyoard extends StatelessWidget {
  const CustNumKeyoard({
    Key key,
    this.text,
    this.child,
    @required this.onPressed,
    this.onLongPress,
  }) : super(key: key);
  final String text;
  final void Function() onPressed, onLongPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onLongPress: onLongPress,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.white,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            90,
            50,
          ),
        ),
        elevation: MaterialStateProperty.resolveWith(
          (states) => getElevation(states),
        ),
        shadowColor: MaterialStateProperty.all(
          kPrimaryDarkColor.withOpacity(0.2),
        ),
      ),
      onPressed: onPressed,
      child: child == null
          ? Text(
              text,
              style: GoogleFonts.openSans(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            )
          : child,
    );
  }
}
