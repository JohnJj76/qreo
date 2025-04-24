import 'package:flutter/material.dart';
import 'package:qreo/models/countries.dart';

class GlobalProvider extends ChangeNotifier {
  // Country
  Country _mCountry = Country();
  Country get mCountry => _mCountry;
  set mCountry(Country mCountry) {
    _mCountry = mCountry;
    notifyListeners();
  }
}
