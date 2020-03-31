import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class CustomToast {
  static simpleNotification(
      {String message, Color color = Colors.green, Widget widget}) {
    showSimpleNotification(
      widget ?? Text(message),
      background: color,
    );
  }

  static OverlaySupportEntry entry;

  static showCard(
      {String title,
      String body,
      Widget trailing = const SizedBox(),
      Widget leading = const SizedBox()}) {
    entry = showSimpleNotification(
        body != null
            ? Card(
                child: ListTile(
                  onTap: () {
                    print('Test');
                    entry.dismiss();

                  },
                  leading: leading,
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: trailing,
                  subtitle: Text(body, style: TextStyle(color: Colors.black)),
                ),
              )
            : Card(
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: trailing,
                ),
              ),
        contentPadding: EdgeInsets.all(0),
        background: Colors.white.withOpacity(0),
        slideDismiss: true);
  }

  static simpleNotificationFixed({String message, Color color = Colors.green}) {
    showSimpleNotification(
      Text(message),
      trailing: Builder(builder: (context) {
        return FlatButton(
            textColor: Colors.yellow,
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Text('Dismiss'));
      }),
      background: color,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

  static showToast(String message) {
    toast(message);
  }
}
