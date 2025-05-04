import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qreo/models/qre_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class QrProvider with ChangeNotifier {
  late QrEros itemModel;
  Qress mQres = Qress();

  List<QrEros> search = [];
  productModels(QueryDocumentSnapshot element) {
    itemModel = QrEros(
      mIdx: element.get("idx"),
      mFecha: element.get("fecha"),
      mConcepto: element.get("concepto"),
      mFactura: element.get("factura"),
      mValor: element.get("valor"),
      mRevisado: element.get("revisado"),
      mEmpleado: element.get("empleado"),
    );
    search.add(itemModel);
  }

  /////////////// herbsProduct ///////////////////////////////
  List<QrEros> herbsProductList = [];

  fatchHerbsProductData() async {
    final mSupabase = Supabase.instance.client;

    List<QrEros> newList = [];

    /*final mResult = await mSupabase
        .from('erosqr')
        .select()
        .eq('revisado', false)
        .order('fecha', ascending: true);

    mQres = Qress.fromJsonList(mResult);*/

    QuerySnapshot value =
        (await mSupabase
                .from('erosqr')
                .select()
                .eq('revisado', false)
                .order('fecha', ascending: true))
            as QuerySnapshot<Object?>;

    value.docs.forEach((element) {
      productModels(element);
      newList.add(itemModel);
    });
    herbsProductList = newList;
    notifyListeners();
  }

  List<QrEros> get getHerbsProductDataList {
    return herbsProductList;
  }

  /////////////////// Search Return ////////////
  List<QrEros> get gerAllProductSearch {
    return search;
  }
}
