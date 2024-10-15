import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomToggleButtons extends StatelessWidget {
  const CustomToggleButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    this.onPressed,
    this.color,
    this.height,
    this.radius,
  });

  final SvgPicture icon;
  final Text text;
  final List<bool> isSelected;
  final void Function(int)? onPressed;
  final Color? color;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      constraints: height != null
          ? BoxConstraints(minHeight: height!, maxHeight: height!)
          : null,
      borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
      onPressed: onPressed,
      selectedBorderColor: color,
      fillColor: color,
      selectedColor: color,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 4.0),
              text,
            ],
          ),
        ),
      ],
    );
  }
}
