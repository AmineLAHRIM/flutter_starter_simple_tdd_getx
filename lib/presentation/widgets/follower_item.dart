import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/data/models/user.dart';
import 'package:flutter_starter/extension/followers_number_ext.dart';

class FollowerItem extends StatelessWidget {
  FollowerItem({
    Key? key,
    required this.currentUser,
    required this.index,
    required this.length,
    required this.followersTotal,
  }) : super(key: key);

  final User? currentUser;
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
          child: ProfileAvatar(colorBg: color1, currentUser: currentUser, colorLight: color2),
        ),
      );
    } else if (index < length - 1) {
      return Container(
        height: double.infinity,
        child: Align(
          widthFactor: 0.7,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ProfileAvatar(colorBg: color1, currentUser: currentUser, colorLight: color2),
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
    required this.currentUser,
    required this.colorLight,
  }) : super(key: key);

  final Color colorBg;
  final User? currentUser;
  final Color colorLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colorBg),
      child: currentUser?.profilePicture != null
          ? CachedNetworkImage(
              imageUrl: currentUser!.profilePicture!,
              fit: BoxFit.cover,
            )
          : currentUser?.profilePictureThumb != null
              ? CachedNetworkImage(
                  imageUrl: currentUser!.profilePictureThumb!,
                  fit: BoxFit.cover,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/images/ic_profile.svg',
                    color: colorLight,
                  ),
                ),
    );
  }
}
