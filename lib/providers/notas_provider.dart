import 'package:flutter/material.dart';
import 'package:qreo/models/nota_models.dart';

class NotasProvider extends ChangeNotifier {
  // Notas
  Nota _mNota = Nota();
  Nota get mNota => _mNota;
  set mNota(Nota mNota) {
    _mNota = mNota;
    notifyListeners();
  }
}
