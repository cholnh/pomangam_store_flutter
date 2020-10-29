import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DialogUtils {
  static void dialog(BuildContext context, String contents, {Function(BuildContext) onPressed}) {

    bool isAndroid = true;
    try {
      isAndroid = Platform.isAndroid;
    } on PlatformException {
      isAndroid = true;
    }

    isAndroid
    ? showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: null,
          content: Text('$contents'),
          actions: <Widget>[
            FlatButton(
              child: Text('확인', style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: onPressed != null
                ? () async {
                  await onPressed(dialogContext);
                  if(Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                }
                : () {
                  if(Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                }
            ),
          ],
        );
      },
    )
    : showCupertinoDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return CupertinoAlertDialog(
            title: null,
            content: Text('$contents'),
            actions: <Widget>[
              FlatButton(
                child: Text('확인', style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: onPressed != null
                  ? () async {
                    await onPressed(dialogContext);
                    if(Navigator.of(dialogContext).canPop()) {
                      Navigator.of(dialogContext).pop();
                    }
                  }
                  : () {
                    if(Navigator.of(dialogContext).canPop()) {
                      Navigator.of(dialogContext).pop();
                    }
                  }
              )
            ],
          );
        }
    );
  }

  static void dialogYesOrNo(BuildContext context, String contents, {
    String confirm = '예',
    String cancel = '아니오',
    Function(BuildContext) onConfirm,
    Function(BuildContext) onCancel,
  }) {

    bool isAndroid = true;
    try {
      isAndroid = Platform.isAndroid;
    } on PlatformException {
      isAndroid = true;
    }

    !isAndroid
    ? showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: null,
          content: Text('$contents'),
          actions: <Widget>[
            FlatButton(
              child: Text('$confirm', style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: onConfirm != null
                ? () async {
                  await onConfirm(dialogContext);
                  if(Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                }
                : () {
                  if(Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                }
            ),
            FlatButton(
              child: Text('$cancel', style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: onCancel != null
                ? () async {
                  await onCancel(dialogContext);
                  if(Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                }
                : () {
                  if(Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                }
            ),
          ],
        );
      }
    )
    : showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: null,
          content: Text('$contents'),
          actions: <Widget>[
            FlatButton(
                child: Text('$confirm', style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: onConfirm != null
                  ? () async {
                    await onConfirm(dialogContext);
                    if(Navigator.of(dialogContext).canPop()) {
                      Navigator.of(dialogContext).pop();
                    }
                  }
                  : () {
                    if(Navigator.of(dialogContext).canPop()) {
                      Navigator.of(dialogContext).pop();
                    }
                  }
            ),
            FlatButton(
                child: Text('$cancel', style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: onCancel != null
                    ? () async {
                      await onCancel(dialogContext);
                      if(Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                    }
                    : () {
                      if(Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                    }
            ),
          ],
        );
      },
    );
  }
}
