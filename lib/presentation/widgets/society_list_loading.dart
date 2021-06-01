import 'package:flutter/material.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/presentation/widgets/society_item_loading.dart';
import 'package:shimmer/shimmer.dart';

class SocietyListLoading extends StatelessWidget {
  const SocietyListLoading({
    Key? key,
    this.isTopPadding = true,
    this.isBottomPadding = true,
    this.ratio = SizeConfig.LIST_SMALL_RATIO,
    this.isOneText = false,
  }) : super(key: key);

  final bool isTopPadding;
  final bool isBottomPadding;
  final bool isOneText;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: DefaultTheme.colorTweenBegin,
        highlightColor: DefaultTheme.colorTweenEnd,
        child: SizeConfig.isMobile
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(8, 8 + (isTopPadding ? kMinInteractiveDimension : 0.0), 8, 8),
                itemCount: 12,
                itemBuilder: (ctx, index) => Container(
                      child: AspectRatio(
                        aspectRatio: ratio,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: SocietyItemLoading(
                            isOneText: isOneText,
                          ),
                        ),
                      ),
                    ))
            : GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(8, 8 + (isTopPadding ? kMinInteractiveDimension : 0.0), 8, 8),
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: SizeConfig.gridMaxCrossAxisExtent,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: ratio,
                ),
                itemBuilder: (ctx, index) => SocietyItemLoading(
                  isOneText: isOneText,
                ),
              ),
      ),
    );
  }
}
