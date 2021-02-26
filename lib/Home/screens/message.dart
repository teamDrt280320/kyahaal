import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/Home/Modals/localDbKhuser.dart';
import 'package:kyahaal/global/helper/customwidget.dart';
import 'package:kyahaal/global/helper/palette.dart';

class MessageScreen extends StatefulWidget {
  final LocalKhUser contact;
  const MessageScreen({Key key, this.contact}) : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: KHColor.brandColorPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Container(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: widget.contact.dpurl != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                              imageUrl: widget.contact.dpurl),
                        )
                      : Center(
                          child: widget.contact.devicename == null
                              ? Text(
                                  widget.contact.number.substring(3, 4),
                                )
                              : Text(
                                  widget.contact.devicename.substring(0, 1),
                                ),
                        ),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(widget.contact.devicename),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: Container()),
            TypingIndicator(
              showIndicator: true,
              bubbleColor: KHColor.brandColorPrimary,
              flashingCircleBrightColor: Colors.white,
              flashingCircleDarkColor: KHColor.brandDark,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          elevation: 5,
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: GoogleFonts.openSans(
                                color: Color(0xff212223),
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: "Type your Message....",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      elevation: 8,
                      backgroundColor: KHColor.brandColorPrimary,
                      child: Icon(Icons.send),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
