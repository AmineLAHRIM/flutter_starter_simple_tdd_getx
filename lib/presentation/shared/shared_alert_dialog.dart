import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/presentation/shared/shared_divider.dart';

class SharedAlertDialog extends StatelessWidget {
  final Color bgColor;
  final Color negativeColortext;
  final Color positiveColortext;
  final String? title;
  final String? message;
  final String? positiveBtnText;
  final String? negativeBtnText;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double circularBorderRadius;

  SharedAlertDialog({
    this.title,
    this.message,
    this.circularBorderRadius = 14.0,
    this.bgColor = Colors.white,
    this.positiveBtnText,
    this.negativeBtnText,
    this.negativeColortext = DefaultTheme.bg,
    this.positiveColortext = DefaultTheme.primary,
    this.onPostivePressed,
    this.onNegativePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.isMobile ? 20.3 : (Get.size.width - 350)/2),
      child: Dialog(
        backgroundColor: bgColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularBorderRadius)),
        child: Container(
          height: 300,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: AutoSizeText(
                  title ?? '',
                  style: Get.textTheme.headline4!.copyWith(color: Get.theme.backgroundColor, fontSize: 20),
                  maxLines: 1,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: AutoSizeText(
                    message ?? '',
                    style: Get.textTheme.headline5!.copyWith(color: Get.theme.primaryColorDark, fontSize: 16),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  ),
                ),
              ),
              Container(
                height: 90,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 50,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                            child: SharedDivider(
                              thickness: SizeConfig.borderSideWidth,
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    positiveBtnText!,
                                    maxLines: 1,
                                    style: Get.textTheme.headline5!.copyWith(color: positiveColortext, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashFactory: InkRipple.splashFactory,
                                      splashColor: positiveColortext.withOpacity(0.1),
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await Future.delayed(Constant.DURATION_CLICK);
                                        if (onPostivePressed != null) {
                                          onPostivePressed!();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                            child: SharedDivider(
                              thickness: SizeConfig.borderSideWidth,
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    negativeBtnText!,
                                    maxLines: 1,
                                    style: Get.textTheme.headline5!.copyWith(color: negativeColortext, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashFactory: InkRipple.splashFactory,
                                      splashColor: Get.theme.primaryColorDark.withOpacity(0.2),
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await Future.delayed(Constant.DURATION_CLICK);
                                        if (onNegativePressed != null) {
                                          onNegativePressed!();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*Widget build(BuildContext context) {
  return AlertDialog(
    title: title != null ? Text(title, style: Get.textTheme.headline4.copyWith(color: Get.theme.backgroundColor)) : null,
    content: message != null ? Text(message, style: Get.textTheme.subtitle2.copyWith(color: Get.theme.backgroundColor), maxLines: 2) : null,
    backgroundColor: bgColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circularBorderRadius)),
    actions: <Widget>[
      negativeBtnText != null
          ? TextButton(
              child: Text(
                negativeBtnText,
                style: Get.textTheme.headline5.copyWith(color: negativeColortext, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                await Future.delayed(Constant.DURATION_CLICK);
                if (onNegativePressed != null) {
                  onNegativePressed();
                }
              },
            )
          : null,
      positiveBtnText != null
          ? TextButton(
              child: Text(
                positiveBtnText,
                style: Get.textTheme.headline5.copyWith(color: positiveColortext, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                await Future.delayed(Constant.DURATION_CLICK);
                if (onPostivePressed != null) {
                  onPostivePressed();
                }
              },
            )
          : null,
    ],
  );
}*/
