import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum MessageType { none, success, error, notice }

enum StatusApp {
  none,
  success,
  error,

  containSpecialChar,
  wrongNumberElement,
  wrongDate,
  nameEmpty,
  itemEmpty,
  wrongStatus,
  wrongPrice,

  failConnection,

  incorrectAccount,
  blankAccount,

  newFeature,
  newFeaturePornhub
}

class ConfigApp {
  static String message(StatusApp e) {
    String msg = '';

    switch (e) {
      case StatusApp.success:
        msg = 'Lưu dữ liệu thành công, tải lại trang sau 2s!';
        break;
      case StatusApp.error:
        msg = 'Đã có lỗi xảy ra!';
        break;
      case StatusApp.containSpecialChar:
        msg = 'Văn bản có chứa kí tự đặc biệt!';
        break;
      case StatusApp.wrongNumberElement:
        msg = 'Kiểm tra lại số trường trong văn bản!';
        break;
      case StatusApp.wrongDate:
        msg = 'Định dạng thời gian không hợp lệ!';
        break;
      case StatusApp.nameEmpty:
        msg = 'Tên không được trống!';
        break;
      case StatusApp.itemEmpty:
        msg = 'Mặt hàng không được trống!';
        break;
      case StatusApp.wrongStatus:
        msg = 'Trạng thái không hợp lệ (0 hoặc 1)!';
        break;
      case StatusApp.wrongPrice:
        msg = 'Số tiền không hợp lệ!';
        break;
      case StatusApp.incorrectAccount:
        msg = 'Tài khoản hoặc mật khẩu không đúng!';
        break;
      case StatusApp.blankAccount:
        msg = 'Tài khoản hoặc mật khẩu không được trống!';
        break;
      case StatusApp.failConnection:
        msg = 'Hãy kiểm tra kết nối mạng!';
        break;
      case StatusApp.newFeature:
        msg = 'Cho tiền thì làm!';
        break;
      case StatusApp.newFeaturePornhub:
        msg = 'Xem Porn ít thôi, không đăng nhập được đâu!';
        break;
      default:
        break;
    }

    return msg;
  }

  static void showNotify(
      BuildContext context, MessageType msgType, StatusApp msg) {
    ToastificationType type;
    String title;

    switch (msgType) {
      case MessageType.success:
        type = ToastificationType.success;
        title = 'SUCCESS';
        break;
      case MessageType.error:
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
        description: Text(message(msg)),
        autoCloseDuration: const Duration(seconds: 5),
        showProgressBar: false);
  }
}
