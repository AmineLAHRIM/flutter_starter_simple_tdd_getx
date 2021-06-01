import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:shimmer/shimmer.dart';

class ItemLoading extends StatelessWidget {
  const ItemLoading({
    Key? key,
    //@required this.animationOne,
    //@required this.animationTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final dateFormat = DateFormat('dd.MM.yy | ${DateFormat.jm().pattern} ');
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: /*Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Get.theme.backgroundColor),
          ),
        )*/
          Shimmer.fromColors(
        baseColor: Get.theme.backgroundColor,
        highlightColor: DefaultTheme.bgDarker,
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
