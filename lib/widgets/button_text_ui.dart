import 'package:flutter/material.dart';

class ButtonTextUI extends StatelessWidget {
  const ButtonTextUI(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color = Colors.black,
      this.border = false,
      this.width,
      this.height,
      this.textColor = Colors.white,
      this.fontSize,
      this.margin,
      this.padding});

  const ButtonTextUI.whiteBorder(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color = Colors.white,
      this.border = true,
      this.width,
      this.height,
      this.textColor = Colors.black,
      this.fontSize,
      this.margin,
      this.padding});

  const ButtonTextUI.red(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color = Colors.red,
      this.border = false,
      this.width,
      this.height,
      this.textColor = Colors.black,
      this.fontSize,
      this.margin,
      this.padding});

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final bool border;
  final double? width;
  final double? height;
  final Color? textColor;
  final double? fontSize;
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
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: textColor),
          ),
        ));
  }
}
