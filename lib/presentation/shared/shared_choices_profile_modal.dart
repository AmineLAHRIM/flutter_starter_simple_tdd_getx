import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/data/models/modal_choice.dart';
import 'package:flutter_starter/data/models/user.dart';
import 'package:flutter_starter/presentation/shared/shared_divider.dart';

class SharedChoicesProfileModal {
  SharedChoicesProfileModal({
    Key? key,
    required this.title,
    this.height = 0.0,
    required this.onSelectedChoiceId,
    required this.choices,
    required this.currentUser,
    this.isClosed = true,
  });

  final String title;
  double height;
  Function(int?) onSelectedChoiceId;
  final User? currentUser;
  final bool isClosed;
  final List<ModalChoice> choices;
  final double imageHeight = 90.0;

  Future<void> show(BuildContext context) {
    // height of each choice + height of each margin bottom + header
    height = height > 0 ? height : ((SizeConfig.heightXXL * choices.length) + (16 * choices.length) + imageHeight / 2 + imageHeight / 2 + 16 + 30 + 8 + 20 + 8 + 20 + 20).toDouble();
    //height = height > 0 ? height : ((SizeConfig.heightXXL * choices.length) + (16 * choices.length) +40+40).toDouble();
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        //clipBehavior: Clip.antiAlias,
        /*shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(topLeft: const Radius.circular(SizeConfig.borderRadiusModal), topRight: const Radius.circular(SizeConfig.borderRadiusModal)),
        ),*/
        context: context,
        builder: (context) {
          return modal(context);
        });
  }

  Widget modal(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: (height > 0 ? height + MediaQuery.of(context).viewInsets.bottom : 500 + MediaQuery.of(context).viewInsets.bottom),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: imageHeight / 2),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(topLeft: const Radius.circular(SizeConfig.borderRadiusModal), topRight: const Radius.circular(SizeConfig.borderRadiusModal)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: imageHeight / 2,
                ),
                SizedBox(
                  height: 16,
                ),
                Column(
                  children: [
                    // FullName
                    Container(
                      child: AutoSizeText(
                        (currentUser!.firstName != null ? currentUser!.firstName![0].toUpperCase()  : '') + (currentUser!.firstName?.substring(1) ?? '') + " " + (currentUser!.lastName?.toUpperCase() ?? ''),
                        style: Get.textTheme.headline3!.copyWith(fontSize: 22, color: Get.theme.colorScheme.onPrimary),
                      ),
                    ),
                    // University
                    AutoSizeText(currentUser!.university?.name ?? '',
                        style: Get.textTheme.headline5!.copyWith(
                          color: Get.theme.buttonColor,
                          fontSize: 14,
                        )),
                    // Degree
                    AutoSizeText(currentUser!.degree ?? '', style: Get.textTheme.subtitle2!.copyWith(color: Get.theme.primaryColorLight, fontSize: 12)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: SharedDivider(
                    thickness: 2,
                    height: 2,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
                      itemCount: choices.length,
                      itemBuilder: (context, index) {
                        final choice = choices[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          width: double.infinity,
                          height: SizeConfig.heightXXL,
                          child: TextButton(
                            onPressed: () async {
                              await Future.delayed(Constant.DURATION_CLICK);
                              onSelectedChoiceId(choice.id);
                            },
                            child: AutoSizeText(
                              choice.name ?? '',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600, color: Get.theme.primaryColor),
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              primary: Get.theme.buttonColor,
                              elevation: 0,
                              backgroundColor: DefaultTheme.secondaryLight3,
                              onSurface: Colors.white.withOpacity(0.1),
                              //onPrimary: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                isClosed
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          height: SizeConfig.heightXXL,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Future.delayed(Constant.DURATION_CLICK);
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.borderRadius)),
                              primary: Get.theme.primaryColorLight,
                              elevation: 0,
                              onPrimary: Colors.white.withOpacity(0.1),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Close',
                                style: Get.theme.textTheme.button!.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
            height: imageHeight,
            width: double.infinity,
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: currentUser!.profilePicture != null
                      ? CachedNetworkImage(
                          imageUrl: currentUser!.profilePicture!,
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(100),
                              child: SvgPicture.asset(
                                'assets/images/ic_profile.svg',
                                color: Get.theme.primaryColorLight,
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(100),
                            child: SvgPicture.asset(
                              'assets/images/ic_profile.svg',
                              color: Get.theme.primaryColorLight,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
