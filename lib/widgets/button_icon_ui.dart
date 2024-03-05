import 'package:flutter/material.dart';

class ButtonIconUI extends StatelessWidget {
  const ButtonIconUI(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.color = Colors.black,
      this.border = false,
      this.width,
      this.height,
      this.iconColor = Colors.white,
      this.iconSize,
      this.margin,
      this.padding});

  const ButtonIconUI.whiteBorder(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.color = Colors.white,
      this.border = true,
      this.width,
      this.height,
      this.iconColor = Colors.black,
      this.iconSize,
      this.margin,
      this.padding});

  const ButtonIconUI.red(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.color = Colors.red,
      this.border = false,
      this.width,
      this.height,
      this.iconColor = Colors.black,
      this.iconSize,
      this.margin,
      this.padding});

  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;
  final bool border;
  final double? width;
  final double? height;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: padding ?? const EdgeInsets.all(6.0),
          margin: margin ?? const EdgeInsets.all(2.0),
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: border ? 2.2 : 0),
            color: color ?? Theme.of(context).colorScheme.surface,
          ),
          child: Icon(icon, color: iconColor, size: iconSize ?? 30.0),
        ));
  }
}
