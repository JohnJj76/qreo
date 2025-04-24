import 'package:intl/intl.dart';
String formatearFecha(timeStamp) {
  var dateFromTimeStamp =
      DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  return DateFormat('dd-MM-yyyy').format(dateFromTimeStamp);
  //return DateFormat('dd-MM-yyyy hh:mm a').format(dateFromTimeStamp);
}

