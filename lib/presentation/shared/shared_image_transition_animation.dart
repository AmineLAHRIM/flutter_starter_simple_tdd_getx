import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/data/models/image_tween_urls.dart';

class SharedImageTransitionAnimation extends StatefulWidget {
  const SharedImageTransitionAnimation({
    Key? key,
    this.imageTweenUrls,
  }) : super(key: key);

  final ImageTweenUrls? imageTweenUrls;

  @override
  _SharedImageTransitionAnimationState createState() => _SharedImageTransitionAnimationState();
}

class _SharedImageTransitionAnimationState extends State<SharedImageTransitionAnimation> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    print('animationvalue initState');
    // TODO: implement initState
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SharedImageTransitionAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    makeAnimtaion();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  makeAnimtaion() async {
    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: widget.imageTweenUrls!.imageUrl != null
            ? Stack(
                children: [
                  widget.imageTweenUrls?.placeHolderImageUrl != null
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: widget.imageTweenUrls!.placeHolderImageUrl!,
                            //fadeOutDuration: new Duration(milliseconds: 0),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: widget.imageTweenUrls?.placeHolderImageUrl != null
                        ? FadeTransition(
                            opacity: animation,
                            child: CachedNetworkImage(
                              imageUrl: widget.imageTweenUrls!.imageUrl!,
                              fit: BoxFit.cover,
                              fadeOutDuration: new Duration(milliseconds: 0),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: widget.imageTweenUrls!.imageUrl!,
                            fit: BoxFit.cover,
                            fadeOutDuration: new Duration(milliseconds: 0),
                          ),
                  ),
                ],
              )
            : Image.asset(
                'assets/images/img_bg.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
