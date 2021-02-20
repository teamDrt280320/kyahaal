import 'package:flutter/material.dart';
import 'package:kyahaal/Home/screens/Chats.dart';
import 'package:kyahaal/Home/screens/GoupChat.dart';
import 'package:kyahaal/global/helper/palette.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  var _selectedPageIndex = 0;

  String getTitle() {
    switch (_selectedPageIndex) {
      case 0:
        return "Chats";
        break;

      default:
        return "Group Chats";
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: KHColor.brandColorPrimary,
      appBar: AppBar(
        title: Text(
          getTitle(),
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedPageIndex = page;
            });
          },
          children: [
            ChatScreen(),
            GroupChat(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/contacts');
        },
        backgroundColor: KHColor.brandColorPrimary,
        child: Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
