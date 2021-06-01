import 'package:flutter/material.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/presentation/widgets/follower_item_loading.dart';

class FollowersListLoading extends StatefulWidget {
  FollowersListLoading({
    Key? key,
  }) : super(key: key);
  final listSize = SizeConfig.isMobile ? 5 : 7;

  @override
  _FollowersListLoadingState createState() => _FollowersListLoadingState();
}

class _FollowersListLoadingState extends State<FollowersListLoading> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Color?> animationOne;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: Constant.FAST_ANIMTAION_DURATION, vsync: this);
    animationOne = ColorTween(begin: DefaultTheme.colorTweenBegin2, end: DefaultTheme.colorTweenEnd2).animate(animationController);

    animationController.forward();
    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (animationController.status == AnimationStatus.dismissed) {
        animationController.forward();
      }
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(tileMode: TileMode.mirror, begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [animationOne.value!, animationOne.value!]).createShader(rect);
      },
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.listSize + 1,
          itemBuilder: (context, index) {
            int length = widget.listSize + 1;
            /*if (index < length - 1) {
              currentUser = currentFollowers[index];
            } else {
              currentUser = null;
            }*/
            return FollowerItemLoading(
              index: index,
              length: length,
            );
          },
        ),
      ),
    );
  }
}
