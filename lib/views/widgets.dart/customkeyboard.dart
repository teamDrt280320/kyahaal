import 'package:flutter/material.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:kyahaal/views/widgets.dart/numkeyboard.dart';

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    Key key,
    this.onPresses,
    this.onBackPressed,
  }) : super(key: key);

  final Function(String) onPresses;
  final Function() onBackPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustNumKeyoard(
                text: '1',
                onPressed: () {
                  onPresses('1');
                },
              ),
              CustNumKeyoard(
                text: '2',
                onPressed: () {
                  onPresses('2');
                },
              ),
              CustNumKeyoard(
                text: '3',
                onPressed: () {
                  onPresses('3');
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustNumKeyoard(
                text: '4',
                onPressed: () {
                  onPresses('4');
                },
              ),
              CustNumKeyoard(
                text: '5',
                onPressed: () {
                  onPresses('5');
                },
              ),
              CustNumKeyoard(
                text: '6',
                onPressed: () {
                  onPresses('6');
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustNumKeyoard(
                text: '7',
                onPressed: () {
                  onPresses('7');
                },
              ),
              CustNumKeyoard(
                text: '8',
                onPressed: () {
                  onPresses('8');
                },
              ),
              CustNumKeyoard(
                text: '9',
                onPressed: () {
                  onPresses('9');
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustNumKeyoard(
                text: '',
                onPressed: () {},
              ),
              CustNumKeyoard(
                text: '0',
                onPressed: () {
                  onPresses('0');
                },
              ),
              CustNumKeyoard(
                child: Icon(
                  Icons.backspace_outlined,
                  color: kPrimaryColor,
                ),
                onPressed: onBackPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
