import 'package:flutter/material.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';

class SharedDivider extends StatelessWidget {
  const SharedDivider({
    Key? key,
    this.height = 2,
    this.thickness = 2,
    this.color,
  }) : super(key: key);

  final double height;
  final double thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Divider(
        height: height,
        color: color ?? DefaultTheme.secondaryLight3,
        thickness: thickness,
      ),
    );
  }
}
