import 'package:marquee/marquee.dart';
import 'package:flutter/material.dart';

class CustomRunningText extends StatelessWidget {
  final String text;
  const CustomRunningText({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text: text,
      style: const TextStyle(fontWeight: FontWeight.bold),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      blankSpace: 20.0,
      velocity: 25.0,
      pauseAfterRound: const Duration(seconds: 1),
      startPadding: 1.0,
      accelerationDuration: const Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: const Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}
