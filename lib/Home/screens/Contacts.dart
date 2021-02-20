import 'package:flutter/material.dart';
import 'package:kyahaal/global/helper/palette.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KHColor.brandColorPrimary,
      appBar: AppBar(
        title: Text(
          "Contacts",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Center(
          child: Text("Contacts Screen"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, '/contacts');
        },
        backgroundColor: KHColor.brandColorPrimary,
        child: Icon(
          Icons.person_add,
        ),
      ),
    );
  }
}
