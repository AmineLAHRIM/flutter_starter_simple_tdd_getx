import 'package:flutter/material.dart';
import 'package:flutter_starter/config/size_config.dart';

class SharedAnimation {
  static Widget slideIt(BuildContext context, int index, animation) {
    /*return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: Container(
        child: AspectRatio(
          aspectRatio: SizeConfig.LIST_RATIO,
          child: Container(
            margin: EdgeInsets.only(bottom: 8),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );*/

    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Container(
        child: AspectRatio(
          aspectRatio: SizeConfig.LIST_EVENT_RATIO,
          child: Container(
            margin: EdgeInsets.only(bottom: 8),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
