import 'package:flutter/material.dart';
import 'package:flutter_app/common_widgets/custom_elevated_button.dart';

class FlutterAppButtonLoisir extends CustomElevatedButton {
  FlutterAppButtonLoisir({
    super.key,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
