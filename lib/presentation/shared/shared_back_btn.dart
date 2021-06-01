import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';

class SharedBackBtn extends StatelessWidget {
  const SharedBackBtn({
    Key? key,
    this.iconColor,
    this.hideIcon = false,
  }) : super(key: key);

  final Color? iconColor;
  final bool hideIcon;

  @override
  Widget build(BuildContext context) {
    return hideIcon
        ? Container()
        : Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.centerLeft,
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
                  onTap: () async {
                    await Future.delayed(Constant.DURATION_CLICK);
                    Get.back();
                  },
                  child: Container(
                    //color: Colors.blue,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        //color: Colors.red,
                        child: SvgPicture.asset(
                          'assets/images/ic_back.svg',
                          alignment: Alignment.center,
                          color: iconColor ?? Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
