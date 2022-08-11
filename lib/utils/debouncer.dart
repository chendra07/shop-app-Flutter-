import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  final int milliseconds; //1 second = 1000 millisecond
  Timer _timer;

  Debouncer({@required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void disposeDebounce() {
    _timer?.cancel();
  }
}
