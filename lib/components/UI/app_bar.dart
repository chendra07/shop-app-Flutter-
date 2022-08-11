import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomAppBar {
  //headerComponent
  static Widget adaptiveAppBar(String title, List<Widget> actions) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(title), //title
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions ?? [],
            ), //actions
          )
        : AppBar(
            title: Text(title),
            actions: actions ?? [],
          );
  }
}
