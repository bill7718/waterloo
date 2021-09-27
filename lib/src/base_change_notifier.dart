

import 'package:flutter/material.dart';

class BaseChangeNotifier with ChangeNotifier {

  void notify() {
    notifyListeners();
  }

}