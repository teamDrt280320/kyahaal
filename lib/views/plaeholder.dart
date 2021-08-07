import 'package:flutter/material.dart';
import 'package:kyahaal/widgets/index.dart';

class PlaceHolderScreen extends StatelessWidget {
  const PlaceHolderScreen({Key? key, this.showloader = false})
      : super(key: key);
  final bool showloader;
  @override
  Widget build(BuildContext context) {
    return ParentWidget.white(
      child: showloader
          ? const Center(child: CircularProgressIndicator.adaptive())
          : const SizedBox.shrink(),
    );
  }
}
