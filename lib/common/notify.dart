import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum NotiType { none, success, error, notice }

class Notify {
  static void show(BuildContext context, NotiType msgType, String msg) {
    ToastificationType type;
    String title;

    switch (msgType) {
      case NotiType.success:
        type = ToastificationType.success;
        title = 'SUCCESS';
        break;
      case NotiType.error:
        type = ToastificationType.error;
        title = 'ERROR';
        break;
      default:
        type = ToastificationType.info;
        title = 'NOTICE';
        break;
    }

    toastification.show(
        context: context,
        type: type,
        style: ToastificationStyle.minimal,
        title: Text(title),
        description: Text(msg),
        autoCloseDuration: const Duration(seconds: 5),
        showProgressBar: false);
  }
}
