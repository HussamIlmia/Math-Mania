import 'package:flutter/material.dart';
import '/src/core/color_scheme.dart';

class CommonAlertDialog extends AlertDialog {
  final Widget child;

  const CommonAlertDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.dialogBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      content: child,
    );
  }
}
