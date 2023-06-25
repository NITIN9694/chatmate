import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utills{

  static void showSnackbar(BuildContext context, String msg) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(
content: Text(msg),
backgroundColor: Colors.blue.withOpacity(.8),
behavior: SnackBarBehavior.floating));
}
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}