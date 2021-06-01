import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedActionBtn extends StatelessWidget {
  const SharedActionBtn({
    Key? key,
    this.child,
    this.onTap,
  }) : super(key: key);

  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Container(
        height: double.infinity,
        width: 52,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: CircleBorder(),
            splashFactory: InkRipple.splashFactory,
            splashColor: Get.theme.primaryColorDark.withOpacity(0.2),
            highlightColor: Colors.transparent,
            onTap: () => onTap!(),
            child: Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FittedBox(
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
