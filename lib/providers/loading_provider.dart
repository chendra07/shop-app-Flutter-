import 'package:flutter/foundation.dart';

// ignore: camel_case_types
class Loading_provider with ChangeNotifier {
  bool _screenLoading = false;
  bool _refreshLoading = false;
  bool _lazyLoading = false;

  bool get screenLoadingState {
    return _screenLoading;
  }

  bool get refreshLoadingState {
    return _refreshLoading;
  }

  bool get lazyLoadingState {
    return _lazyLoading;
  }

  //--------------------------

  void showLoading() {
    _screenLoading = true;
    notifyListeners();
  }

  void dismissLoading() {
    _screenLoading = false;
    notifyListeners();
  }

  //--------------------------

  void showRefreshLoading() {
    _refreshLoading = true;
    notifyListeners();
  }

  void dismissRefreshLoading() {
    _refreshLoading = false;
    notifyListeners();
  }

  //--------------------------

  void showLazyLoading() {
    _lazyLoading = true;
    notifyListeners();
  }

  void dismissLazyLoading() {
    _lazyLoading = false;
    notifyListeners();
  }
}
