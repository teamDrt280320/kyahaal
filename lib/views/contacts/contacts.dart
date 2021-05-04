import 'package:flutter/material.dart';
import 'package:kyahaal/views/contacts/components/mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ContactsPageMobile(),
    );
  }
}
