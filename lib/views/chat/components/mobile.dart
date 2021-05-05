import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/modals/contact.dart';
import 'package:kyahaal/utility/constants.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:line_icons/line_icons.dart';

class ChatPageMobile extends StatefulWidget {
  final ContactsModal userModal;

  const ChatPageMobile({Key key, this.userModal}) : super(key: key);
  @override
  _ChatPageMobileState createState() => _ChatPageMobileState();
}

class _ChatPageMobileState extends State<ChatPageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: kPrimaryLightColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert_outlined,
              color: kDarkPurple,
            ),
            onPressed: () {},
          )
        ],
        title: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                boxShadow: boxShadow,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.userModal.photo,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(
                10,
              ),
            ),
            Text(
              widget.userModal.contactName,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                color: kDarkPurple,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Hero(
            tag: widget.userModal.photo,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    widget.userModal.photo,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: boxShadow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: kDarkPurple,
                    size: 32,
                  ),
                  Flexible(
                    child: CupertinoTextField.borderless(
                      maxLines: 10,
                      minLines: 1,
                      placeholder: 'Start Typing...',
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: FloatingActionButton(
                      backgroundColor: kPrimaryLightColor,
                      elevation: 0.0,
                      onPressed: () {},
                      child: Icon(
                        Icons.send,
                        color: kDarkPurple,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
