import 'package:intl/intl.dart';

// Función para formatear la fecha
String formatDate(DateTime date) {
  // return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  return DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(date);
}

String formatOnlyDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
