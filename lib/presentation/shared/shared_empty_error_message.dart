import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/presentation/shared/entry.dart';

class SharedEmptyErrorMessage extends StatelessWidget {
  const SharedEmptyErrorMessage({
    Key? key,
    this.bodyHeight = double.infinity,
    this.isImageVisible = true,
    required this.message,
  }) : super(key: key);

  final double bodyHeight;
  final String message;
  final bool isImageVisible;

  @override
  Widget build(BuildContext context) {
    return Entry.all(
      scale: 1,
      yOffset: Constant.ENTRY_YOFFSET,
      //delay: Constant.FAST_ANIMTAION_DURATION,
      //curve: Curves.easeInCirc,
      duration: Constant.ANIMTAION_DURATION,
      child: Container(
        height: bodyHeight,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isImageVisible
                  ? Container(
                      height: 180,
                      child: SvgPicture.asset(
                        'assets/images/err_empty_event.svg',
                      ),
                    )
                  : Container(),
              SizedBox(
                height: isImageVisible ? 32 : 0,
              ),
              Text(
                'Oops! its empty!',
                style: Get.textTheme.headline4!.copyWith(color: Get.theme.backgroundColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message,
                  style: Get.textTheme.bodyText1!.copyWith(color: Get.theme.primaryColorLight),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
