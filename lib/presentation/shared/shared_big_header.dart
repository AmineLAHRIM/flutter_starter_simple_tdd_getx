import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';

class SharedBigHeader extends StatelessWidget {
  const SharedBigHeader({
    Key? key,
    required this.title,
    this.trailing,
  }) : super(key: key);
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.headerTitleHeight,
      color: Get.theme.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Container(
        alignment: SizeConfig.HEADER_ALIGENMENT,
        child: FractionallySizedBox(
          heightFactor: 0.55,
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 60,
                  child: AutoSizeText(
                    title,
                    maxLines: 1,
                    style: Get.textTheme.headline1!.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Spacer(flex: 20),
                Expanded(flex: 20, child: trailing ?? Container() /*InkResponse(
                    splashFactory: InkRipple.splashFactory,
                     onTap: () async {
                                        await Future.delayed(Constant.DURATION_CLICK);

                      controller.logout();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/images/ic_logout.svg',
                        alignment: Alignment.centerRight,
                        color: Colors.white,
                      ),
                    ),
                  ),*/
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
