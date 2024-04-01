import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

Future<bool?> alert(BuildContext context, String message, {String okLabel = 'Ok'}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            ElevatedButton(
              child: Text(okLabel),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      });
}

void showErrorMessage(String message, {int duration = 4}) {
  _showToastInternal(message, Colors.white, Colors.red, duration);
}

void _showToastInternal(
  String message,
  Color fgColor,
  Color bgColor, [
  int duration = 1,
]) {
  showToastWidget(
    Container(
      // color: ApolloColors.darkPurple,
      margin: EdgeInsets.only(left: 32, right: 32),
      padding: EdgeInsets.all(6),
      // width: 640,
      child: Container(
        decoration: new BoxDecoration(
          color: bgColor,
          borderRadius: new BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            new BoxShadow(
              color: Color.fromARGB(140, 0, 0, 0),
              offset: new Offset(4.0, 8.0),
              blurRadius: 10,
            )
          ],
        ),
        padding: EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
        child: Text(
          message,
          style: TextStyle(fontSize: 15, color: fgColor),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    dismissOtherToast: true,
    position: ToastPosition.top,
    duration: Duration(seconds: duration),
  );
}
