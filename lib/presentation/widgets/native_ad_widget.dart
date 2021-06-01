import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_starter/data/models/custom_native_ad.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/presentation/widgets/item_loading.dart';
import 'package:flutter_starter/services/event_service.dart';

class NativeAdWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NativeAdState();

  NativeAdWidget({
    Key? key,
    required this.currentEvent,
    required this.index,
    required this.onRemoveErrorLoadingAd,
    required this.eventService,
    this.customNativeAd,
  }) : super(key: key);

  final Event currentEvent;
  final int index;
  final Function({String? adId}) onRemoveErrorLoadingAd;
  final CustomNativeAd? customNativeAd;
  final EventService eventService;
}

class NativeAdState extends State<NativeAdWidget> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  NativeAd? _nativeAd;
  Completer<NativeAd> _nativeAdCompleter = Completer<NativeAd>();
  bool isInit = true;

  /*@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit) _nativeAd?.load();
    isInit = false;
  }*/

  @override
  void initState() {
    //setupNativeAd();
    widget.currentEvent.isAdLoading=true;

    if (widget.customNativeAd?.nativeAd != null && widget.customNativeAd!.nativeAdCompleter != null) {
      _nativeAd = widget.customNativeAd!.nativeAd;
      _nativeAdCompleter = widget.customNativeAd!.nativeAdCompleter!;
    } else {
      // in case the item lose state and want to recreate ad for it
      //setupNativeAd();
      //widget.eventService!.removeErrorLoadedAd(index: widget.index, id: 0);

      //widget.onRemoveErrorLoadingAd(index: widget.index);
    }
    super.initState();
    //Future<void>.delayed(Duration(seconds: 1), () => _nativeAd?.load());
  }

  /*Future<void> setupNativeAd() async {
    _nativeAdCompleter = Completer<NativeAd>();
    _nativeAd = NativeAd(
      adUnitId: NativeAd.testAdUnitId,
      request: AdRequest(),
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          _nativeAdCompleter.complete(ad as NativeAd);
          widget.currentEvent.isAdLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error isLOADED=${widget.currentEvent.isAdLoaded}');

          if (!widget.currentEvent.isAdLoaded) {
            print('onRemoveErrorLoadingAd');
            print('funonRemoveErrorLoadingAd | ${widget.index}');
            //widget.onRemoveErrorLoadingAd(index: widget.index);
            widget.eventService!.removeErrorLoadedAd(index: widget.index, id: 0);
          }
          _nativeAdCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        //onApplicationExit: (Ad ad) => print('$NativeAd onApplicationExit.'),
      ),
    );
    if (isInit) _nativeAd?.load();
    widget.currentEvent.isAdLoading = true;
    isInit = false;
  }*/

  @override
  void dispose() {
    super.dispose();
    //_nativeAd?.dispose();
    //_nativeAd = null;
  }

  @override
  Widget build(BuildContext context) {
    // for AutomaticKeepAliveClientMixin
    super.build(context);

    return FutureBuilder<NativeAd>(
      future: _nativeAdCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<NativeAd> snapshot) {
        Widget? child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.done:
            print('getListPrint index=${widget.index} ConnectionState.done');
            print('NativeAd snapshot ${snapshot.hasData}');
            if (snapshot.hasData) {
              widget.currentEvent.isAdLoaded = true;
              child = AdWidget(ad: _nativeAd!);
            } else {
              //removeErrorLoadedAd(id: 0, index: index);
              print('NativeAd onRemoveErrorLoadingAd fun3 ${widget.index}');
              child = Text('Error loading $NativeAd');
            }
            break;
        }

        return Container(
          //duration: Constant.FAST_ANIMTAION_DURATION,
          child: child != null ? Container(color: Get.theme.backgroundColor, child: child) : ItemLoading(),
          //child: child != null ? Container(color: Get.theme.backgroundColor, child: child) : Container(),
        );
      },
    );
  }
}
