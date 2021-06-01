import 'package:flutter/material.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/presentation/widgets/event_item_loading.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalEventListLoading extends StatelessWidget {
  const HorizontalEventListLoading({
    Key? key,
    this.itemCount = 12,
    this.isNestedList = false,
    this.paddingTop = 0,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  final int itemCount;
  final bool isNestedList;
  final double paddingTop;
  final scrollDirection;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: DefaultTheme.colorTweenBegin2,
        highlightColor: DefaultTheme.colorTweenEnd2,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemCount: itemCount,
            itemBuilder: (ctx, index) => Container(
                  child: AspectRatio(
                    aspectRatio: SizeConfig.LIST_EVENT_RATIO,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: EventItemLoading(),
                    ),
                  ),
                )),
      ),
    );
  }
}
