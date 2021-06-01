import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/data/models/society.dart';
import 'package:flutter_starter/extension/followers_number_ext.dart';

class FollowedSocietyItem extends StatelessWidget {
  FollowedSocietyItem({
    Key? key,
    required this.currentSociety,
    required this.index,
    required this.length,
    required this.followersTotal,
  }) : super(key: key);

  final Society? currentSociety;
  final int index;
  final int length;
  int followersTotal;

  final Color color1 = DefaultTheme.secondaryLight3;
  final Color color2 = DefaultTheme.secondaryLight;

  //final Color colorBg = Color(0xFFF1F2FE);
  //final Color colorLight = Color(0xFFE4E7FC);

  @override
  Widget build(BuildContext context) {
    print('event index==' + index.toString() + ' length==' + length.toString());
    if (length > 1 && index == 0) {
      return Container(
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: ProfileAvatar(colorBg: color1, currentSociety: currentSociety, colorLight: color2),
        ),
      );
    } else if (index < length - 1) {
      return Container(
        height: double.infinity,
        child: Align(
          widthFactor: 0.7,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ProfileAvatar(colorBg: color1, currentSociety: currentSociety, colorLight: color2),
          ),
        ),
      );
    } else {
      return Container(
        height: double.infinity,
        child: Align(
          widthFactor: 1,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: followersTotal > Constant.FOLLOWERS_MAX_SIZE
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      '+ ${(followersTotal - Constant.FOLLOWERS_MAX_SIZE).toFollowersNum}',
                      style: Get.textTheme.subtitle2!.copyWith(
                        color: Get.theme.primaryColorLight,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      minFontSize: 10,
                    ),
                  )
                : Container(),
          ),
        ),
      );
    }
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key? key,
    required this.colorBg,
    required this.currentSociety,
    required this.colorLight,
  }) : super(key: key);

  final Color colorBg;
  final Society? currentSociety;
  final Color colorLight;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shadowColor: Get.theme.shadowColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      color: colorBg,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: currentSociety?.cover != null
            ? CachedNetworkImage(
                imageUrl: currentSociety!.cover!,
                fit: BoxFit.cover,
              )
            : currentSociety?.coverThumb != null
                ? CachedNetworkImage(
                    imageUrl: currentSociety!.coverThumb!,
                    fit: BoxFit.cover,
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/images/ic_profile.svg',
                      color: colorLight,
                    ),
                  ),
      ),
    );
  }
}
