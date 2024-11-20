import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum ToastType { success, error, warning, info }

class MyToastBar {
  static void _show(
      BuildContext context, String message, ToastType type, Color color) {
    DelightToastBar(
      builder: (context) => ToastCard(
        color: color,
        leading: _icon(type),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      position: DelightSnackbarPosition.bottom,
      autoDismiss: true,
      snackbarDuration: Durations.extralong4,
    ).show(context);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, ToastType.success, const Color(0xFF3ABE3F));
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, ToastType.error, Colors.red);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, ToastType.warning, Colors.orange);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, ToastType.info, Colors.blue);
  }

  static void showCustom(
      BuildContext context, String message, IconData icon, Color color) {
    DelightToastBar(
      builder: (context) => ToastCard(
        color: color,
        leading: Icon(
          icon,
          size: 32,
          color: Colors.white,
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      position: DelightSnackbarPosition.bottom,
      autoDismiss: true,
      snackbarDuration: Durations.extralong4,
    ).show(context);
  }

  static Widget _icon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Icon(
          Iconsax.tick_circle,
          size: 32,
          color: Colors.white,
        );
      case ToastType.error:
        return const Icon(
          Iconsax.close_circle,
          size: 32,
          color: Colors.white,
        );
      case ToastType.warning:
        return const Icon(
          Iconsax.warning_2,
          size: 32,
          color: Colors.white,
        );
      case ToastType.info:
        return const Icon(
          Iconsax.info_circle,
          size: 32,
          color: Colors.white,
        );
      default:
        return const Icon(
          Icons.notifications,
          size: 32,
          color: Colors.white,
        );
    }
  }
}
