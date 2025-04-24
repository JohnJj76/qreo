import 'dart:convert';

class Qress {
  List<QrEros> items = [];

  Qress();

  Qress.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return;
    } else {
      for (var item in jsonList) {
        final mQre = QrEros.fromJsonMap(item);
        items.add(mQre);
      }
    }
  }

  String toArrayJson() {
    String jsonArray = '';
    for (var i = 0; i < items.length; i++) {
      jsonArray += items[i].toJson();
      if ((i + 1) < items.length) {
        jsonArray += ", ";
      }
    }
    return jsonArray = '[$jsonArray]';
  }
}

class QrEros {
  String? mIdx;
  String? mFecha;
  String? mConcepto;
  int? mFactura;
  int? mValor;
  bool? mRevisado;
  String? mEmpleado;

  QrEros({mIdx, mFecha, mConcepto, mFactura, mValor, mRevisado, mEmpleado});

  QrEros.fromJsonMap(Map<String, dynamic> json) {
    mIdx = json['idx'];
    mFecha = json['fecha'];
    mConcepto = json['concepto'];
    mFactura = json['factura'];
    mValor = json['valor'];
    mRevisado = json['revisado'];
    mEmpleado = json['empleado'];
  }

  String toJson() {
    return jsonEncode(_toJsonMap());
  }

  Map<String, dynamic> _toJsonMap() => {
    'idx': mIdx,
    'fecha': mFecha,
    'concepto': mConcepto,
    'factura': mFactura,
    'valor': mValor,
    'revisado': mRevisado,
    'empleado': mEmpleado,
  };
}
