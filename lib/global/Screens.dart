import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/global/helper/palette.dart';

class FullScreenDP extends StatefulWidget {
  final File image;

  const FullScreenDP({Key key, this.image}) : super(key: key);
  @override
  _FullScreenDPState createState() => _FullScreenDPState();
}

class _FullScreenDPState extends State<FullScreenDP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: KHColor.brandColorPrimary,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("KyaHaal",
              style: GoogleFonts.openSans(
                color: KHColor.brandColorPrimary,
              ))),
      body: InteractiveViewer(
        child: Container(
          child: Center(
            child: Image.file(widget.image),
          ),
        ),
      ),
    );
  }
}
