import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/Home/Bloc/contactsBloc.dart';
import 'package:kyahaal/Home/Modals/khuser.dart';
import 'package:kyahaal/Home/Modals/localDbKhuser.dart';
import 'package:kyahaal/Home/screens/message.dart';
import 'package:kyahaal/global/helper/palette.dart';
import 'package:kyahaal/global/helper/strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  ContactsBloc contactsBloc = ContactsBloc();
  User me = FirebaseAuth.instance.currentUser;
  List<LocalKhUser> commonUser = [];
  List<LocalKhUser> searchedCommonUser = [];
  bool proceed = false;
  bool refreshing = false;
  bool searching = false;
  TextEditingController _searchQuery = TextEditingController();

  //check and ask for contact permission
  askContactPermission() async {
    if (await Permission.contacts.request().isGranted) {
      setupDatabase();
      getContacts();
      setState(() {
        proceed = true;
      });
    } else {
      setState(() {
        proceed = false;
      });
    }
  }

//search user in list
  searchUser() {
    if (_searchQuery.text.isNotEmpty && searching) {
      searchedCommonUser.clear();
      for (LocalKhUser user in commonUser) {
        if (user.devicename
                .toLowerCase()
                .contains(_searchQuery.text.toLowerCase()) ||
            user.number.contains(_searchQuery.text.toLowerCase())) {
          setState(() {
            searchedCommonUser.add(user);
          });
        }
      }
    } else {
      setState(() {
        searchedCommonUser.clear();
      });
    }
  }

//getCOntacts from API and match with the users contacts database and add to the database
  getContacts() async {
    contactsBloc.getContacts();
    if (mounted) {
      setState(() {
        refreshing = true;
      });
    }
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    List<Contact> contacts1 = [];
    contacts1.addAll(contacts);
    var response = await http.get(KHStrings.allContactEndPoint,
        headers: {"x-api-key": KHStrings.apiKey});
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    List<KHUser> users =
        parsed.map<KHUser>((json) => KHUser.fromJson(json)).toList();

    for (KHUser user in users) {
      if (me.phoneNumber != user.number) {
        var contactList = await ContactsService.getContactsForPhone(
          user.number,
          withThumbnails: false,
          photoHighResolution: false,
        );
        if (contactList.isNotEmpty) {
          Contact contact = contactList.first;
          contactsBloc.insert(user, name: contact.displayName);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    askContactPermission();

    contactsBloc.contactsController.stream.listen((event) {
      commonUser.clear();
      commonUser.addAll(event);
      if (mounted) {
        setState(() {});
      }
    });

    contactsBloc.loadingController.stream.listen((event) {
      if (mounted) {
        setState(() {
          refreshing = event;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    contactsBloc.dispose();
    _searchQuery.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KHColor.brandColorPrimary,
      appBar: AppBar(
        title: searching
            ? TextField(
                onChanged: (string) {
                  searchUser();
                },
                autofocus: true,
                controller: _searchQuery,
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              )
            : buildTitleText(),
        actions: [
          Visibility(
            visible: refreshing,
            child: new Container(
              margin: EdgeInsets.symmetric(
                vertical: 17,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: new CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !refreshing,
            child: IconButton(
              icon:
                  searching ? Icon(Icons.cancel_outlined) : Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchedCommonUser.clear();
                  searching = !searching;
                });
              },
            ),
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
        child: proceed
            ? Container(
                child: ListView.builder(
                  itemCount:
                      searching ? searchedCommonUser.length : commonUser.length,
                  itemBuilder: (context, index) {
                    LocalKhUser user = searching
                        ? searchedCommonUser[index]
                        : commonUser[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MyCustomRoute(
                            //fullscreenDialog: true,
                            builder: (context) {
                          return MessageScreen(
                            contact: user,
                          );
                        }));
                      },
                      leading: CircleAvatar(
                        backgroundColor: KHColor.brandColorPrimary,
                        child: user.dpurl != null
                            ? ClipOval(
                                child: CachedNetworkImage(imageUrl: user.dpurl),
                              )
                            : Center(
                                child: user.devicename == null
                                    ? Text(
                                        user.number.substring(3, 4),
                                      )
                                    : Text(
                                        user.devicename.substring(0, 1),
                                      ),
                              ),
                      ),
                      title: Text(user.devicename),
                    );
                  },
                ),
              )
            : Center(
                child: Text("Contacts Screen"),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: KHColor.brandColorPrimary,
        child: Icon(
          Icons.person_add,
        ),
      ),
    );
  }

  Text buildTitleText() {
    return Text(
      "Contacts",
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 1.2,
      ),
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Fades between routes.
    var begin = Offset(1.5, 0.0);
    var end = Offset.zero;
    var curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
    //return new FadeTransition(opacity: animation, child: child);
  }
}
