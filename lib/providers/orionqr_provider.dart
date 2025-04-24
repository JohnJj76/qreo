import 'package:flutter/material.dart';
import 'package:qreo/models/qro_models.dart';

class OrionQrProvider extends ChangeNotifier {
  // Provider eros qrs
  QrOrion _mQro = QrOrion();
  QrOrion get mQro => _mQro;
  set mQro(QrOrion mQro) {
    _mQro = mQro;
    notifyListeners();
  }
}
