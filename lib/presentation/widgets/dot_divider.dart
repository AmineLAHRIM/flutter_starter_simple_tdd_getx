import 'package:flutter/material.dart';

class DotDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Axis direction;

  const DotDivider({this.height = 1, this.color = Colors.black, this.width = 10.0, this.direction = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = this.direction == Axis.horizontal ? constraints.constrainWidth() : constraints.constrainHeight();
        final dashWidth = width;
        final dashHeight = height;
        final dashCount = this.direction == Axis.horizontal ? (boxWidth / (2 * dashWidth)).floor() : (boxWidth / (2 * dashHeight)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
        );
      },
    );
  }
}
