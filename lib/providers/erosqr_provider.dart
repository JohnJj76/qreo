import 'package:flutter/material.dart';
import 'package:qreo/models/qre_models.dart';

class ErosQrProvider extends ChangeNotifier {
  // Provider eros qrs
  QrEros _mQre = QrEros();
  QrEros get mQre => _mQre;
  set mQre(QrEros mQre) {
    _mQre = mQre;
    notifyListeners();
  }
}
