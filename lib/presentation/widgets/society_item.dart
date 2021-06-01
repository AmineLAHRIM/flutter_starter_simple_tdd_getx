import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/core/routes/app_routes.dart';
import 'package:flutter_starter/data/models/society.dart';
import 'package:flutter_starter/presentation/shared/shared_image_placeholder.dart';

class SocietyItem extends StatelessWidget {
  const SocietyItem({
    Key? key,
    required this.currentSociety,
    required this.index,
  }) : super(key: key);

  final Society currentSociety;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        elevation: 2,
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
                          child: currentSociety.cover != null
                              ? CachedNetworkImage(
                                  imageUrl: currentSociety.cover!,
                                  placeholder: (context, url) => SharedImagePlaceHolder(
                                    imageAsset: 'assets/images/ic_society.svg',
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : SharedImagePlaceHolder(
                                  imageAsset: 'assets/images/ic_society.svg',
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              currentSociety.name?.capitalizeFirst ?? '',
                              style: Get.textTheme.headline4!.copyWith(color: Get.theme.backgroundColor),
                              minFontSize: 15,
                              maxLines: 1,
                            ),
                          ),
                          Flexible(
                            child: Container(
                              child: AutoSizeText(
                                currentSociety.universityInfo?.name?.capitalizeFirst ?? '',
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
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    splashColor: Get.theme.buttonColor.withOpacity(0.1),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await Future.delayed(Constant.DURATION_CLICK);
                      Get.toNamed(AppRoutes.SOCIETY_DETAIL, arguments: currentSociety.id);
                    },
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
