import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation {
  static Widget adaptiveLoadingAnimation({
    Color color = Colors.black,
    double size = 150,
  }) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            animating: true,
            color: color,
            radius: size,
          )
        : SpinKitPouringHourGlass(
            color: color,
            size: size,
          );
  }
}
