import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/presentation/shared/shared_image_placeholder.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key? key,
    @required this.isDark = false,
    required this.controller,
    this.imageAsset,
    required this.title,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  final bool isDark;
  final String? imageAsset;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Card(
        elevation: 0,
        shadowColor: Get.theme.shadowColor,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
          /*side: BorderSide(
                color: Get.theme.buttonColor,
                width: 2
            )*/
        ),
        color: isDark ? Get.theme.colorScheme.primaryVariant : DefaultTheme.secondaryLight3,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // card body
              Container(
                //padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            /*clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),*/
                            child: SharedImagePlaceHolder(
                              imageAsset: imageAsset ?? 'assets/images/ic_nav_settings.svg',
                              bgColor: isDark ? Get.theme.backgroundColor : Get.theme.buttonColor.withOpacity(0.2),
                              color: isDark ? Get.theme.colorScheme.primaryVariant : Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              title,
                              style: Get.textTheme.headline4!.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Get.theme.backgroundColor),
                              minFontSize: 12,
                              maxLines: 1,
                            ),
                          ),
                          /*Flexible(
                            child: Container(
                              child: AutoSizeText(
                                currentUniversity?.name?.capitalizeFirst ?? '',
                                style: Get.textTheme.subtitle2.copyWith(color: Get.theme.primaryColorLight),
                                maxLines: 1,
                              ),
                            ),
                          )*/
                        ],
                      ),
                    )),
                    SizedBox(
                      width: 8,
                    ),
                    trailing != null
                        ? Container(
                            height: double.infinity,
                            margin: EdgeInsets.only(right: 16),
                            alignment: Alignment.center,
                            child: FractionallySizedBox(
                              heightFactor: 0.5,
                              child: AspectRatio(
                                aspectRatio: 2.4 / 1,
                                child: trailing,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    splashColor: Get.theme.primaryColorDark.withOpacity(0.2),
                    highlightColor: Colors.transparent,
                    onTap: () => onTap(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
