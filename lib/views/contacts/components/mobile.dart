import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kyahaal/controllers/contactscontroller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kyahaal/modals/contact.dart';
import 'package:kyahaal/utility/pages.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:kyahaal/views/chat/chat.dart';
import 'package:line_icons/line_icons.dart';

class ContactsPageMobile extends StatefulWidget {
  @override
  _ContactsPageMobileState createState() => _ContactsPageMobileState();
}

class _ContactsPageMobileState extends State<ContactsPageMobile> {
  ContactsController _contactsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // var contact = await ContactsService.openContactForm();
        },
        backgroundColor: kPrimaryLightColor,
        child: Icon(
          LineIcons.userPlus,
          color: kPrimaryDarkColor,
        ),
        elevation: 8,
      ),
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Contacts',
          style: GoogleFonts.openSans(
            color: kDarkPurple,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Obx(
            () => Visibility(
              visible: _contactsController.fetching.value,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                height: 24,
                width: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(
                    kDarkPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<ContactsModal>>(
        valueListenable: _contactsController.friendsBox.listenable(),
        builder: (context, box, _) {
          print(box.values.length.toString());
          return Container(
            child: Center(
              child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  var contact = box.getAt(index);
                  return Card(
                    elevation: 8,
                    shadowColor: kPrimaryColor.withOpacity(
                      0.5,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(
                            RoutesName.CHAT,
                            arguments: ChatScreenArguments(contact),
                          );
                        },
                        selectedTileColor: kDarkPurple,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: kDarkPurple,
                          size: 16,
                        ),
                        leading: InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            showCupertinoDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Hero(
                                    tag: contact.photo,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: SizeConfig.screenHeight * 0.1,
                                      ),
                                      height: SizeConfig.screenHeight * 0.3,
                                      width: SizeConfig.screenHeight * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            contact.photo,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Hero(
                            tag: contact.photo,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: kPrimaryColor.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 10.0,
                                    offset: Offset(
                                      1,
                                      3,
                                    ),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    contact.photo,
                                  ),
                                ),
                              ),
                              height: 48,
                              width: 48,
                            ),
                          ),
                        ),
                        title: Text(
                          contact.contactName,
                        ),
                        subtitle: Text(
                          contact.number,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
