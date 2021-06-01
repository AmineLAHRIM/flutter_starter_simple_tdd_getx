import 'package:flutter/material.dart';
import 'package:flutter_starter/config/size_config.dart';

class TextItemLoading extends StatelessWidget {
  const TextItemLoading({
    Key? key,
    this.widthFactor = 1,
    this.height = SizeConfig.heightLoading,
    this.width = 0.0,
    this.margin = EdgeInsets.zero,
    this.alignment = Alignment.centerLeft,
    this.color = Colors.white,
    this.radius = 5.0,
  }) : super(key: key);

  final double widthFactor;
  final double height;
  final double width;
  final double radius;
  final EdgeInsets margin;
  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width > 0 ? width : double.infinity,
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Card(
          elevation: 0,
          margin: margin,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Container(
            height: height,
            color: color,
          ),
        ),
      ),
    );
  }
}
