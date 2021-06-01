import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/presentation/shared/shared_divider.dart';

class SharedShowMoreModal {
  const SharedShowMoreModal({
    Key? key,
    required this.title,
    @required this.height = 0,
    required this.text,
  });

  final String title;
  final double height;
  final String? text;

  Future<void> show(BuildContext context) {
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
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(text ?? ''),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Container(
              width: double.infinity,
              height: SizeConfig.heightXXL,
              child: ElevatedButton(
                onPressed: () => Get.back(),
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
          ),
        ],
      ),
    );
  }
}
