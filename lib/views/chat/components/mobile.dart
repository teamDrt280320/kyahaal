import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/controllers/chatcontroller.dart';
import 'package:kyahaal/modals/contact.dart';
import 'package:kyahaal/modals/message.dart';
import 'package:kyahaal/utility/constants.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../main.dart';

class ChatPageMobile extends StatefulWidget {
  final ContactsModal userModal;

  const ChatPageMobile({Key key, this.userModal}) : super(key: key);
  @override
  _ChatPageMobileState createState() => _ChatPageMobileState();
}

class _ChatPageMobileState extends State<ChatPageMobile> {
  ChatController _chatController = Get.find();
  @override
  void initState() {
    _chatController.uid.value = widget.userModal.uid;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: buildAppBar(),
          body: Stack(
            children: [
              buildChatList(),
              buildMessageField(),
              buildHeader(),
            ],
          ),
        ),
      ),
    );
  }

  Hero buildChatList() {
    return Hero(
      tag: widget.userModal.photo,
      child: Container(
        margin: EdgeInsets.only(top: kToolbarHeight),
        decoration: BoxDecoration(
          color: Colors.transparent,
          // image: DecorationImage(
          //   fit: BoxFit.cover,
          //   image: CachedNetworkImageProvider(
          //     widget.userModal.photo,
          //   ),
          // ),
        ),
        child: ValueListenableBuilder<Box<MessageModal>>(
            valueListenable: messageBox.listenable(),
            builder: (context, box, _) {
              var sublist = box.values
                  .toList()
                  .where(
                    (element) =>
                        (element.receiver == widget.userModal.uid &&
                            element.sender ==
                                _chatController.auth.currentUser.uid) ||
                        (element.receiver ==
                                _chatController.auth.currentUser.uid &&
                            element.sender == widget.userModal.uid),
                  )
                  .toList();
              sublist.sort((a, b) => b.time.compareTo(a.time));
              return ListView.builder(
                reverse: true,
                controller: _chatController.scrollController,
                padding: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(
                    80,
                  ),
                ),
                physics: BouncingScrollPhysics(),
                itemCount: sublist.length,
                itemBuilder: (context, index) {
                  var message = sublist[index];
                  var isSender = message.sender != widget.userModal.uid;
                  return buildChatBubble(isSender, message, index, sublist);
                },
              );
            }),
      ),
    );
  }

  BubbleSpecialOne buildChatBubble(bool isSender, MessageModal message,
      int index, List<MessageModal> sublist) {
    return BubbleSpecialOne(
      seen: !isSender ? false : message.read,
      delivered: !isSender
          ? false
          : message.read
              ? false
              : true,
      textStyle: GoogleFonts.openSans(
        fontSize: 16,
        color: isSender ? Colors.white : kTextColor,
      ),
      color: isSender ? kPrimaryColor : Color(0xFFEEF2F8),
      tail: index == sublist.length - 1 ||
          sublist[index + 1].sender != message.sender,
      text: message.message,
      isSender: isSender,
    );
  }

  Positioned buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: kPrimaryDarkColor.withOpacity(0.1),
              blurRadius: 16.0,
              offset: Offset(3, 3),
            ),
          ],
        ),
        height: kToolbarHeight,
        width: double.infinity,
        child: ListTile(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: kDarkPurple,
              size: 20,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          trailing: Icon(
            Icons.more_vert_outlined,
            color: kDarkPurple,
          ),
          title: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryDarkColor.withOpacity(0.1),
                      blurRadius: 16.0,
                      offset: Offset(3, 3),
                    ),
                  ],
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
      ),
    );
  }

  buildMessageField() {
    return Positioned(
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
                controller: _chatController.messageController,
                maxLines: 10,
                minLines: 1,
                placeholder: 'Start Typing...',
              ),
            ),
            RotatedBox(quarterTurns: 1, child: Icon(Icons.attach_file)),
            SizedBox(
              width: getProportionateScreenWidth(15),
            ),
            SizedBox(
              height: 48,
              width: 48,
              child: FloatingActionButton(
                backgroundColor: kPrimaryLightColor,
                elevation: 0.0,
                onPressed: () {
                  _chatController.sendMessage(
                    new MessageModal(
                      message: _chatController.messageController.text.trim(),
                      type: 'text',
                      read: false,
                      receiver: widget.userModal.uid,
                    ),
                    widget.userModal.publicKey,
                  );
                },
                child: Icon(
                  Icons.send,
                  color: kDarkPurple,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
    );
  }
}
