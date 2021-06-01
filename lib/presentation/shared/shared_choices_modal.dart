import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/data/models/modal_choice.dart';
import 'package:flutter_starter/presentation/shared/shared_divider.dart';

class SharedChoicesModal {
  SharedChoicesModal({
    Key? key,
    required this.title,
    this.height = 0.0,
    required this.onSelectedChoiceId,
    required this.choices,
    @required this.isClosed = true,
  });

  final String title;
  double height;
  Function(int?) onSelectedChoiceId;
  final bool isClosed;
  final List<ModalChoice> choices;

  Future<void> show(BuildContext context) {
    // height of each choice + height of each margin bottom + header
    height = height > 0 ? height : ((SizeConfig.heightXXL * choices.length) + (16 * choices.length) + 100).toDouble();
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(topLeft: const Radius.circular(SizeConfig.borderRadiusModal), topRight: const Radius.circular(SizeConfig.borderRadiusModal)),
        ),
        context: context,
        builder: (context) {
          return modal(context);
        });
  }

  Widget modal(BuildContext context) {
    return Container(
      color: Colors.white,
      height: height > 0 ? height + MediaQuery.of(context).viewInsets.bottom : 500 + MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Container(
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                width: 50,
                margin: EdgeInsets.symmetric(vertical: 4),
                child: SharedDivider(
                  color: Get.theme.primaryColorLight.withOpacity(0.2),
                  thickness: 4,
                  height: 4,
                ),
              )),
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
            decoration: BoxDecoration(),
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              title,
              style: Get.textTheme.headline4!.copyWith(fontWeight: FontWeight.w600, height: 1, fontSize: 18, color: Get.theme.backgroundColor),
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: SharedDivider(
              color: Get.theme.primaryColorLight.withOpacity(0.2),
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
    );
  }
}
