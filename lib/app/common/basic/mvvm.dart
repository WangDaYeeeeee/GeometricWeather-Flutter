// @dart=2.12

import 'dart:async';

import 'package:flutter/widgets.dart';

class LiveData<T> with ChangeNotifier {

  T _data;

  LiveData(this._data);

  T get value => _data;

  set value(T data) {
    _data = data;
    Timer.run(() {
      notifyListeners();
    });
  }
}

class NullableLiveData<T> with ChangeNotifier {

  T? _data;

  NullableLiveData([this._data]);

  T? get value => _data;

  set value(T? data) {
    _data = data;
    Timer.run(() {
      notifyListeners();
    });
  }
}

abstract class ViewModel {

  void dispose(BuildContext context);
}

