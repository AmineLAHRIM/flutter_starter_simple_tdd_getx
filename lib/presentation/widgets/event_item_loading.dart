import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';

class EventItemLoading extends StatelessWidget {
  const EventItemLoading({
    Key? key,
    //@required this.animationOne,
    //@required this.animationTwo,
  }) : super(key: key);

  //final Animation<Color> animationOne;
  //final Animation<Color> animationTwo;

  @override
  Widget build(BuildContext context) {
    //final dateFormat = DateFormat('dd.MM.yy | ${DateFormat.jm().pattern} ');
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      child: Card(
        elevation: 10,
        shadowColor: Get.theme.shadowColor,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
        ),
        color: Colors.white,
        child: Container(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
