import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatData(dynamic time) {
  DateTime dateTime;

  if (time is int) {
    // Handle the case where time is an int (milliseconds since epoch)
    dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  } else if (time is Timestamp) {
    // Handle the case where time is already a Timestamp
    dateTime = time.toDate();
  } else {
    // Handle other cases or return an empty string/error message
    return 'Invalid Timestamp';
  }

  String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);
  return formattedDate;
}
