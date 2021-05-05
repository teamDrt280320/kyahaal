import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/controllers/authcontroller.dart';
import 'package:kyahaal/utility/pages.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:kyahaal/views/widgets.dart/theme_config.dart';
import 'package:line_icons/line_icons.dart';
import 'drawerlisttile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key key,
    @required AuthController authController,
  })  : _authController = authController,
        super(key: key);

  final AuthController _authController;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              UserAccountsDrawerHeader(
                arrowColor: kPrimaryDarkColor,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                ),
                onDetailsPressed: () {},
                currentAccountPicture: Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kSecondaryColor.withOpacity(0.5),
                          blurRadius: 8.0,
                          offset: Offset(3, 2),
                        ),
                      ],
                    ),
                    child: widget._authController.firestoreUser.value == null ||
                            widget._authController.firestoreUser.value.imgUrl ==
                                null
                        ? ClipOval(
                            child: Icon(
                              LineIcons.user,
                              color: kDarkPurple,
                            ),
                          )
                        : ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget
                                  ._authController.firestoreUser.value.imgUrl,
                              placeholder: (s, _) => Icon(
                                LineIcons.user,
                                color: kDarkPurple,
                              ),
                            ),
                          ),
                  ),
                ),
                accountName: Obx(
                  () => Text(
                    widget._authController.firestoreUser.value == null
                        ? ''
                        : widget._authController.firestoreUser.value.uName ??
                            '',
                    style: GoogleFonts.openSans(
                      color: kPrimaryDarkColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                accountEmail: Obx(
                  () => Text(
                    widget._authController.firebaseUser.value == null
                        ? ''
                        : widget._authController.firebaseUser.value
                                .phoneNumber ??
                            '',
                    style: GoogleFonts.openSans(
                      color: kPrimaryDarkColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10.0,
                top: 50,
                child: ThemeSwitcher(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(
                        Icons.brightness_3_outlined,
                        color: kDarkPurple,
                      ),
                      onPressed: () {
                        //Get.back();
                        // ThemeSwitcher.of(context).changeTheme(
                        //   theme: ThemeProvider.of(context).brightness ==
                        //           Brightness.light
                        //       ? darkTheme
                        //       : lightTheme,
                        // );
                        // setState(() {});
                      },
                    );
                  },
                ),
              )
            ],
          ),
          DrawerListTile(
            iconData: LineIcons.userFriends,
            title: 'New Group',
            onTilePressed: () {},
          ),
          Divider(),
          DrawerListTile(
            iconData: Icons.contacts_outlined,
            title: 'Contacts',
            onTilePressed: () {
              Get.back();
              Get.toNamed(RoutesName.CONTACTS);
            },
          ),
          DrawerListTile(
            iconData: Icons.bookmark_border_outlined,
            title: 'Saved Messages',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.person_add_alt_1_outlined,
            title: 'Invite Friends',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.settings,
            title: 'Settings',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.help_outline_outlined,
            title: 'KyaHaal FAQ',
            onTilePressed: () {},
          ),
        ],
      ),
    );
  }
}
