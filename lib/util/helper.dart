import 'package:intl/intl.dart';

class Prettifier {
  static String date(String? dateString){
    if(dateString != null) {
      DateTime d = DateFormat("yyyy-MM-dd").parse(dateString);
      return DateFormat("dd MMM yyyy").format(d);
    } else {
      return "";
    }
  }
}