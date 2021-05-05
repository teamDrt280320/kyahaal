import 'package:flutter/material.dart';
import 'package:kyahaal/modals/contact.dart';
import 'package:kyahaal/views/chat/components/mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChatScreenArguments args =
        ModalRoute.of(context).settings.arguments as ChatScreenArguments;
    return ScreenTypeLayout(
      mobile: ChatPageMobile(
        userModal: args.userModal,
      ),
    );
  }
}

class ChatScreenArguments {
  final ContactsModal userModal;

  ChatScreenArguments(this.userModal);
}
