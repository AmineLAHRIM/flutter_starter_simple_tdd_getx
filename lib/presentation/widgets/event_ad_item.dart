import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/data/models/custom_native_ad.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/presentation/widgets/native_ad_widget.dart';
import 'package:flutter_starter/services/event_service.dart';

class EventAdItem extends StatelessWidget {
  EventAdItem({
    Key? key,
    required this.currentEvent,
    required this.index,
    required this.onRemoveErrorLoadingAd,
    this.customNativeAd,
    required this.eventService,

    //@required this.nativeAdController,
  }) : super(key: key);

  //final NativeAdmobController nativeAdController;
  final EventService eventService;
  final int index;
  final Event currentEvent;
  final Function({String? adId}) onRemoveErrorLoadingAd;
  final CustomNativeAd? customNativeAd;

  @override
  Widget build(BuildContext context) {

    /*if (!isAdLoaded) {
      nativeAdController.reloadAd(forceRefresh: true, numberAds: 1);
      isAdLoaded = true;
    }*/
    //final dateFormat = DateFormat('dd.MM.yy | ${DateFormat.jm().pattern} ');
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        elevation: 10,
        shadowColor: Get.theme.shadowColor,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
        ),
        color: Colors.white,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: NativeAdWidget(
                    //key: Key('$index'),
                    eventService: eventService,
                    currentEvent: currentEvent,
                    onRemoveErrorLoadingAd: ({adId}) => onRemoveErrorLoadingAd(adId :adId),
                    index: index,
                    customNativeAd: customNativeAd,
                  ), /*FacebookNativeAd(
                        placementId: "YOUR_PLACEMENT_ID",
                        adType: NativeAdType.NATIVE_AD,
                        //width: double.infinity,
                        //height: 300,
                        backgroundColor: Get.theme.backgroundColor,
                        titleColor: Colors.white,
                        descriptionColor: Colors.white,
                        buttonColor: Get.theme.buttonColor,
                        buttonTitleColor: Colors.white,
                        buttonBorderColor: Get.theme.buttonColor,
                        keepAlive: true,
                        //set true if you do not want adview to refresh on widget rebuild
                        keepExpandedWhileLoading: false,
                        // set false if you want to collapse the native ad view when the ad is loading
                        expandAnimationDuraion: 300,
                        //in milliseconds. Expands the adview with animation when ad is loaded
                        listener: (result, value) {
                          print("Native Ad: $result --> $value");
                          if (result == NativeAdResult.MEDIA_DOWNLOADED) {
                          } else if (result == NativeAdResult.LOADED) {
                            currentEvent.isAdLoaded = true;
                          } else if (result == NativeAdResult.LOGGING_IMPRESSION) {
                          } else if (result == NativeAdResult.CLICKED) {
                          } else if (result == NativeAdResult.ERROR) {
                            print('removeErrorLoadedAd ERROR index=${index} isAdLoaded ${currentEvent.isAdLoaded}');
                            if (!currentEvent.isAdLoaded) {
                              onRemoveErrorLoadingAd(index: index);
                            }
                          }
                        },
                      )*/
                )
              ],
            )),
      ),
    );
  }
}
