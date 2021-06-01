import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/presentation/shared/shared_back_btn.dart';

class SharedAnimatedHeader extends StatefulWidget {
  SharedAnimatedHeader({
    Key? key,
    required this.scrollController,
    required this.title,
    this.bgColor,
    @required this.showTitle = false,
  }) : super(key: key);

  final ScrollController scrollController;
  final String? title;
  Color? bgColor;
  final bool showTitle;

  @override
  _SharedAnimatedHeaderState createState() => _SharedAnimatedHeaderState();
}

class _SharedAnimatedHeaderState extends State<SharedAnimatedHeader> {
  bool lastStatus = false;
  double expandedHeight = SizeConfig.headerActionsHeight;

  _scrollListener() {
    print('sharedoffset=${widget.scrollController.offset} | sum${(expandedHeight - kToolbarHeight)}');
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    // expandedHeight - expandedHeight for if it was the appbar in column and the scroll list in the bottom
    //10 just more exemple size
    return widget.scrollController.hasClients && widget.scrollController.offset > (expandedHeight - expandedHeight);
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: isShrink ? 10 : 0,
      shadowColor: Get.theme.shadowColor,
      color: Colors.transparent,
      child: AnimatedContainer(
        width: double.infinity,
        height: expandedHeight,
        color: widget.bgColor?.withOpacity(isShrink ? 1 : 0) ?? Get.theme.backgroundColor.withOpacity(isShrink ? 1 : 0),
        duration: Constant.FAST_ANIMTAION_DURATION,
        curve: Curves.easeInOut,
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 8),
          child: FractionallySizedBox(
            heightFactor: SizeConfig.HIGHT_FACTOR_ACTIONBAR,
            child: Container(
              child: Row(
                children: [
                  Expanded(flex: 20, child: SharedBackBtn()),
                  Expanded(
                    flex: 60,
                    child: AutoSizeText(
                      (widget.showTitle || isShrink) ? (widget.title!.capitalizeFirst ?? '') : '',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline4!.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(flex: 20, child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return NestedScrollView(
      controller: widget.scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: expandedHeight,
            floating: false,
            pinned: true,
            //shadowColor: Colors.transparent,
            elevation: isShrink ? 0 : 4,

            backgroundColor: isShrink ? Colors.blue : Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("text sample",
                  style: TextStyle(
                    color: isShrink ? Colors.black : Colors.white,
                    fontSize: 16.0,
                  )),
              /* background: CachedNetworkImage(
                  imageUrl:
                  'htps://www1.chester.ac.uk/sites/default/files/styles/hero/public/Events%20Management%20festival%20image.jpg',
                  fit: BoxFit.cover,
                )*/
            ),
          ),
        ];
      },
      body: Container(
        alignment: Alignment.topCenter,
        color: Colors.yellowAccent,
        child: Builder(builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber above.
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              Container(
                width: double.infinity,
                height: 400,
                margin: EdgeInsets.all(16),
                child: Placeholder(),
              ),
              Container(
                width: double.infinity,
                height: 400,
                margin: EdgeInsets.all(16),
                child: Placeholder(),
              ),
              Container(
                width: double.infinity,
                height: 400,
                margin: EdgeInsets.all(16),
                child: Placeholder(),
              ),
              Container(
                width: double.infinity,
                height: 400,
                margin: EdgeInsets.all(16),
                child: Placeholder(),
              ),
              Container(
                width: double.infinity,
                height: 400,
                margin: EdgeInsets.all(16),
                child: Placeholder(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
