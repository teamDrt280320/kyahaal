import 'package:flutter/material.dart';
import 'package:kyahaal/Authentication/Screens/register.dart';
import 'package:kyahaal/global/helper/palette.dart';
import 'package:kyahaal/global/services/auth.dart';

class CommonAuthScreen extends StatefulWidget {
  final UserBloc bloc;

  const CommonAuthScreen({Key key, this.bloc}) : super(key: key);
  @override
  _CommonAuthScreenState createState() => _CommonAuthScreenState();
}

class _CommonAuthScreenState extends State<CommonAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: KHColor.brandColorPrimary,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RegisterUser(
              bloc: widget.bloc,
            ),
          );
        },
      ),
    );
  }
}
