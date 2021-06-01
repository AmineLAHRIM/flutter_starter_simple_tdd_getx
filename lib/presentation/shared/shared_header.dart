import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/presentation/shared/shared_back_btn.dart';

class SharedHeader extends StatelessWidget {
  const SharedHeader({
    Key? key,
    this.title,
    this.leadingIconColor,
    this.leading,
    this.leadingOnTap,
    this.trailing,
    this.trailingOnTap,
  }) : super(key: key);

  final String? title;
  final Color? leadingIconColor;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? leadingOnTap;
  final VoidCallback? trailingOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.headerActionsHeight,
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 8),
        child: FractionallySizedBox(
          heightFactor: SizeConfig.HIGHT_FACTOR_ACTIONBAR,
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: InkWell(
                    onTap: () => leadingOnTap!(),
                    child: leading ??
                        SharedBackBtn(
                          iconColor: leadingIconColor,
                        ),
                  ),
                ),
                Expanded(
                  flex: 60,
                  child: AutoSizeText(
                    title ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headline4!.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: InkWell(
                    onTap: () => trailingOnTap!(),
                    child: trailing ?? Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
