import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius = 2.0,
    required this.onPressed,
    this.height = 50.0,
  });

  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey[400],
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
