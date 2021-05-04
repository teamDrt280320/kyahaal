import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTilePressed;

  const DrawerListTile(
      {Key key,
      @required this.iconData,
      @required this.title,
      @required this.onTilePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(iconData),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTilePressed,
    );
  }
}
