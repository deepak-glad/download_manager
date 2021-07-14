import 'package:flutter/cupertino.dart';

class Data {
  String name;
  int progress;
  Data(this.name, {required this.progress});
}

class DataProvider with ChangeNotifier {
  var _progress;
  var _imageData;
  void addProgress(int data, var url) {
    _progress = data;
    _imageData = url;
    notifyListeners();
  }

  get progressData => _progress;
  get imageData => _imageData;
}
