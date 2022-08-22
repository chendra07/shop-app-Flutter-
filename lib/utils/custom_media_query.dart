import 'package:flutter/material.dart';

class CMediaQuery {
  static double customHeight(
    BuildContext context,
    AppBar appBar,
    double heightPct,
  ) {
    double appBarHeight = appBar.preferredSize.height;
    double ySize = (MediaQuery.of(context).size.height -
        (appBarHeight ?? 0) -
        MediaQuery.of(context).padding.top);
    debugPrint('y: $ySize');
    return ySize * heightPct;
  }

  static double customWidht(
    BuildContext context,
    double widthPct,
  ) {
    double xSize = MediaQuery.of(context).size.width;
    debugPrint('x: $xSize');
    return xSize * widthPct;
  }
}
