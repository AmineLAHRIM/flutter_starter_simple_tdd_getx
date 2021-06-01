import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/presentation/shared/entry.dart';

class SharedErrorMessage extends StatelessWidget {
  SharedErrorMessage({
    Key? key,
    required this.message,
    this.isImageVisible = true,
    required this.onTapRefresh,
  }) : super(key: key);

  final String? message;
  bool isImageVisible;
  final VoidCallback onTapRefresh;

  @override
  Widget build(BuildContext context) {
    var title = 'Failed Loading!';
    var image = 'assets/images/err_connection.svg';
    if (message == Messages.NO_CONNECTION) {
      title = 'Connection Lost!';
      image = 'assets/images/err_connection.svg';
    } else if (message == Messages.SERVER_FAILURE) {
      image = 'assets/images/err_connection.svg';
      title = 'Failed Loading!';
    }
    isImageVisible = Get.mediaQuery.size.height < SizeConfig.SMALL_MOBILE_HEIGHT ? false : isImageVisible;

    return Entry.all(
      scale: 1,
      yOffset: Constant.ENTRY_YOFFSET,
      //delay: Constant.FAST_ANIMTAION_DURATION,
      //curve: Curves.easeInCirc,
      duration: Constant.ANIMTAION_DURATION,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isImageVisible
                ? Container(
                    height: 180,
                    child: SvgPicture.asset(
                      image,
                    ),
                  )
                : Container(),
            isImageVisible
                ? SizedBox(
                    height: 32,
                  )
                : Container(),
            Text(
              title,
              style: Get.textTheme.headline4!.copyWith(color: Get.theme.backgroundColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '$message',
                style: Get.textTheme.bodyText1!.copyWith(color: Get.theme.primaryColorLight),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
                ),
                color: Get.theme.backgroundColor,
                child: Stack(
                  children: [
                    Container(
                      width: 180,
                      height: SizeConfig.heightXXL,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        Messages.REFRESH_TEXT_BTN,
                        style: Get.theme.textTheme.subtitle1!.copyWith(color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashFactory: InkRipple.splashFactory,
                          splashColor: Colors.white.withOpacity(0.1),
                          onTap: () => onTapRefresh(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
