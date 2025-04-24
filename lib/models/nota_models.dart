import 'dart:convert';

class Notass {
  List<Nota> items = [];

  Notass();

  Notass.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return;
    } else {
      for (var item in jsonList) {
        final mNota = Nota.fromJsonMap(item);
        items.add(mNota);
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

class Nota {
  String? mIdx;
  String? mContenido;
  DateTime? mCreatedAt;

  Nota({mIdx, mContenido, mCreatedAt});

  Nota.fromJsonMap(Map<String, dynamic> json) {
    mIdx = json['idx'];
    mContenido = json['contenido'];
    mCreatedAt =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
  }

  String toJson() {
    return jsonEncode(_toJsonMap());
  }

  Map<String, dynamic> _toJsonMap() => {
    'idx': mIdx,
    'contenido': mContenido,
    'created_at': mCreatedAt,
  };
}
