import 'package:flutter/material.dart';
import 'package:qreo/models/qre_models.dart';

class OrionQrProvider extends ChangeNotifier {
  // Provider eros qrs
  QrEros _mQro = QrEros();
  QrEros get mQro => _mQro;
  set mQro(QrEros mQro) {
    _mQro = mQro;
    notifyListeners();
  }
}
