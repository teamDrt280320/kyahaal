import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kyahaal/global/helper/palette.dart';
import 'package:kyahaal/global/services/auth.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KHColor.brandColorPrimary,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [],
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
          child: ListView(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: FirebaseAuth.instance.currentUser.photoURL,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                title: Text(
                  FirebaseAuth.instance.currentUser.displayName,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  signOut();
                },
                leading: Icon(
                  Icons.logout,
                  color: KHColor.brandColorPrimary,
                ),
                title: Text("Sign Out"),
              ),
            ],
          ),
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
