import 'package:flutter/material.dart';

class Utils {
  static double customHeight(
    BuildContext context,
    AppBar appBar,
    double heightPct,
  ) {
    return (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) *
        heightPct;
  }
}
