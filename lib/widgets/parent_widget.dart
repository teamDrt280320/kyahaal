import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParentWidget extends StatelessWidget {
  ///Default Contusctor
  const ParentWidget.custom({
    Key? key,
    required this.systemColor,
    required this.child,
    this.fab,
    this.brightness = Brightness.light,
    this.footer,
    this.padding = EdgeInsets.zero,
    this.appBar,
  }) : super(key: key);

  ///Constructor with statusbar color as white and brightness as dark
  const ParentWidget.white({
    Key? key,
    required this.child,
    this.fab,
    this.footer,
    this.padding = EdgeInsets.zero,
    this.appBar,
  })  : systemColor = Colors.white,
        brightness = Brightness.dark,
        super(key: key);

  ///Child Widget which will be used as the body parameter of Scaffold
  final Widget child;
  final Color systemColor;
  final Brightness brightness;
  final Widget? fab, footer;
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
      ),
      child: Scaffold(
        appBar: appBar,
        body: SafeArea(child: Padding(padding: padding, child: child)),
        floatingActionButton: fab,
        bottomSheet: footer,
      ),
    );
  }
}
