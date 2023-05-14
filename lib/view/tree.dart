import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:farmbase/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:farmbase/utils.dart';
import 'package:farmbase/view/note/note_index_screen.dart';
import 'package:farmbase/view/home/home_screen.dart';

class Tree extends StatefulWidget {
  final String uid;
  const Tree({Key? key, required this.uid}) : super(key: key);

  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      NoteIndexScreen(uid: widget.uid),
      HomeScreen(uid: widget.uid),
      ProfileSrceen(uid: widget.uid),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: children,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        animationDuration: const Duration(milliseconds: 300),
        buttonBackgroundColor: AppStyle.mainColor,
        backgroundColor: AppStyle.bgColor.withOpacity(0),
        items: const <Widget>[
          Icon(Icons.description_outlined, size: 30),
          Icon(Icons.home_rounded, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),
    );
  }
}

// body: ListView.builder(
//   itemCount: _users.length,
//   itemBuilder: (context, index) {
//     final user = _users[index];
//     return ListTile(
//       title: Text(user['name']),
//       subtitle: Text(user['email']),
//     );
//   },
// ),