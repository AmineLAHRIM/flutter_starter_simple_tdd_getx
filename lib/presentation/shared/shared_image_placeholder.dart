import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SharedImagePlaceHolder extends StatelessWidget {
  const SharedImagePlaceHolder({
    Key? key,
    this.bgColor,
    this.color = Colors.white,
    this.imageAsset = 'assets/images/ic_profile.svg',
  }) : super(key: key);

  final Color? bgColor;
  final Color? color;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: bgColor ?? Get.theme.buttonColor.withOpacity(0.2),
      child: SvgPicture.asset(
        '$imageAsset',
        color: color!,
      ),
    );
  }
}
