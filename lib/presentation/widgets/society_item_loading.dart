import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/data/models/society.dart';

class SocietyItemLoading extends StatelessWidget {
  SocietyItemLoading({
    Key? key,
    @required this.isOneText = false,
  }) : super(key: key);

  final bool isOneText;
  final Color colorLight = Colors.black.withOpacity(0.2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
          color: Colors.white,
          child: Row(
            children: [
              Container(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: colorLight,
                  ),
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
                      child: Container(
                        color: colorLight,
                        child: AutoSizeText(
                          '                          ',
                          style: Get.textTheme.headline4!.copyWith(color: Get.theme.backgroundColor),
                          minFontSize: 15,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    isOneText
                        ? Container()
                        : SizedBox(
                            height: 8,
                          ),
                    isOneText
                        ? Container()
                        : Flexible(
                            child: Container(
                              color: colorLight,
                              child: AutoSizeText(
                                '                                                                ',
                                style: Get.textTheme.subtitle2!.copyWith(color: Get.theme.primaryColorLight),
                                maxLines: 1,
                              ),
                            ),
                          )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
