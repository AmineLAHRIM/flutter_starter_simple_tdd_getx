import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';

class FollowerItemLoading extends StatelessWidget {
  FollowerItemLoading({
    Key? key,
    required this.index,
    required this.length,
  }) : super(key: key);

  final int index;
  final int length;
  final Color colorLight = DefaultTheme.colorLightLoading;

  @override
  Widget build(BuildContext context) {
    if (length > 1 && index == 0) {
      return Container(
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: ProfileAvatarLoading(colorLight: colorLight),
        ),
      );
    } else if (index < length - 1) {
      return Container(
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: AlignPositioned(
            moveByChildWidth: index * (-0.2),
            child: ProfileAvatarLoading(colorLight: colorLight),
          ),
        ),
      );
    } else {
      return Container();
      /*return Container(
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: 1/1,
          child: AlignPositioned(
            moveByChildWidth: (index-1) * (-0.2),
            child: Center(child: Text('+2.5K'),),
          ),
        ),
      );*/
    }
  }
}

class ProfileAvatarLoading extends StatelessWidget {
  const ProfileAvatarLoading({
    Key? key,
    required this.colorLight,
  }) : super(key: key);

  final Color colorLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          'assets/images/ic_profile.svg',
          color: colorLight,
        ),
      ),
    );
  }
}
