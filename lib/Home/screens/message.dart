import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/Home/Bloc/messageBloc.dart';
import 'package:kyahaal/Home/Modals/localDbKhuser.dart';
import 'package:kyahaal/Home/Modals/messages.dart';
import 'package:kyahaal/global/helper/customwidget.dart';
import 'package:kyahaal/global/helper/palette.dart';
import 'package:intl/intl.dart' as intl;

class MessageScreen extends StatefulWidget {
  final LocalKhUser contact;
  const MessageScreen({Key key, this.contact}) : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _messageController;
  ScrollController _messageListController;
  MessageBloc bloc;
  List<Messages> messageList = [];
  bool isTyping = false;
  List<int> _selectedIndex = [];
  @override
  void initState() {
    super.initState();
    bloc = MessageBloc(uid: widget.contact.uid);
    _messageController = TextEditingController();
    _messageListController = ScrollController();
    setupDatabase();
    listentoIncomingMessage(widget.contact.uid, bloc);
    listentoOutgoingMessage(widget.contact.uid, bloc);
    bloc.isTypingController.stream.listen((event) {
      setState(() {
        isTyping = event;
      });
    });
    _messageListController.animateTo(0.0,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  @override
  void didUpdateWidget(covariant MessageScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex.isEmpty
          ? AppBar(
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
                                        widget.contact.devicename
                                            .substring(0, 1),
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
              actions: [
                IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
              ],
            )
          : AppBar(
              centerTitle: false,
              backgroundColor: KHColor.brandColorPrimary,
              title: Text("${_selectedIndex.length} Selected"),
              leading: IconButton(
                icon: Icon(Icons.cancel_rounded),
                onPressed: () {
                  setState(
                    () {
                      _selectedIndex.clear();
                    },
                  );
                },
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.copy_outlined),
                    onPressed: () {
                      String text = "";
                      _selectedIndex.sort((a, b) => b.compareTo(a));
                      for (int i in _selectedIndex) {
                        text = "$text\n${messageList[i].message}";
                      }
                      Clipboard.setData(
                        ClipboardData(
                          text: text.trim(),
                        ),
                      ).whenComplete(
                        () {
                          Fluttertoast.showToast(
                            msg: 'Copied ${_selectedIndex.length} messages',
                          );
                          setState(() {
                            _selectedIndex.clear();
                          });
                        },
                      );
                    })
              ],
            ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Messages>>(
                stream: bloc.messageController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messageList = snapshot.data.reversed.toList();
                    return ListView.builder(
                      controller: _messageListController,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messageList.length,
                      itemBuilder: (con, index) {
                        bool prevSameSender = false;
                        bool selectd = false;
                        if (_selectedIndex.isNotEmpty) {
                          selectd = _selectedIndex.contains(index);
                        }
                        if (index != messageList.length - 1) {
                          if (messageList[index].sentBy ==
                              messageList[index + 1].sentBy) {
                            prevSameSender = true;
                          }
                        }
                        Messages message = messageList[index];
                        bool sentByMe = message.sentBy != widget.contact.uid;
                        return InkWell(
                          onLongPress: () {
                            setState(() {
                              if (!_selectedIndex.contains(index)) {
                                _selectedIndex.add(index);
                              } else {
                                _selectedIndex.remove(index);
                              }
                            });
                          },
                          onTap: () {
                            setState(() {
                              if (_selectedIndex.contains(index)) {
                                _selectedIndex.remove(index);
                              } else {
                                if (_selectedIndex.isNotEmpty) {
                                  _selectedIndex.add(index);
                                }
                              }
                            });
                          },
                          child: Stack(
                            children: [
                              buildReceiverChatBubble(
                                sentByMe,
                                message,
                                prevSameSender,
                              ),
                              Visibility(
                                visible: selectd,
                                child: Positioned.fill(
                                  child: Container(
                                    color: Colors.blue.withOpacity(0.2),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            TypingIndicator(
              showIndicator: true,
              bubbleColor: Colors.white,
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
                              controller: _messageController,
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
                              onChanged: (abd) {
                                bloc.addWhetherTyping(true);
                              },
                              onEditingComplete: () {
                                bloc.addWhetherTyping(false);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      elevation: 8,
                      backgroundColor: KHColor.brandColorPrimary,
                      child: Icon(Icons.send),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          bloc.sendBlocMessages(
                            new Messages(
                              message: _messageController.text.trim(),
                              sentTo: widget.contact.uid,
                            ),
                          );
                          _messageController.clear();
                          _messageListController.animateTo(0.0,
                              duration: Duration(milliseconds: 100),
                              curve: Curves.easeIn);
                        }
                      },
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

  Bubble buildReceiverChatBubble(
      bool sentByMe, Messages message, bool prevSameSender) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(message.timeStamp);
    String formatted = intl.DateFormat('hh:mm a').format(date);

    return sentByMe
        ? Bubble(
            padding: BubbleEdges.only(
              right: 25,
              left: 10,
            ),
            margin: BubbleEdges.only(
              top: 2.5,
              left: 50,
              right: 10,
              bottom: 2.5,
            ),
            alignment: Alignment.topRight,
            nip: prevSameSender ? BubbleNip.no : BubbleNip.rightTop,
            color: KHColor.brandColorPrimary.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      message.message,
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Text(
                  formatted,
                  style: GoogleFonts.openSans(
                    color: Colors.white60,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        : Bubble(
            padding: BubbleEdges.only(
              left: 25,
              right: 10,
            ),
            margin: BubbleEdges.only(
              top: 5,
              right: 50,
              left: 10,
            ),
            // stick: true,
            alignment: Alignment.topLeft,
            nip: prevSameSender ? BubbleNip.no : BubbleNip.leftTop,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      message.message,
                      style: GoogleFonts.openSans(
                        color: KHColor.brandColorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Text(
                  formatted,
                  style: GoogleFonts.openSans(
                    color: Colors.white60,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
  }
}
