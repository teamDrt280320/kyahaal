import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyahaal/controllers/authcontroller.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:line_icons/line_icons.dart';

import 'drawerlisttile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
    @required AuthController authController,
  })  : _authController = authController,
        super(key: key);

  final AuthController _authController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
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
                child: _authController.firestoreUser.value == null ||
                        _authController.firestoreUser.value.imgUrl == null
                    ? ClipOval(
                        child: Icon(
                          LineIcons.user,
                          color: kDarkPurple,
                        ),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: _authController.firestoreUser.value.imgUrl,
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
                _authController.firestoreUser.value == null
                    ? ''
                    : _authController.firestoreUser.value.uName ?? '',
                style: GoogleFonts.openSans(
                  color: kPrimaryDarkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            accountEmail: Obx(
              () => Text(
                _authController.firebaseUser.value == null
                    ? ''
                    : _authController.firebaseUser.value.phoneNumber ?? '',
                style: GoogleFonts.openSans(
                  color: kPrimaryDarkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
            onTilePressed: () {},
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
