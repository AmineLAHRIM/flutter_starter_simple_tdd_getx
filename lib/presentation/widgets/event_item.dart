import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/core/routes/app_routes.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/extension/event_date_ext.dart';
import 'package:flutter_starter/presentation/shared/shared_image_placeholder.dart';
import 'package:flutter_starter/services/event_service.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    Key? key,
    required this.eventService,
    required this.currentEvent,
    required this.index,
    required this.tag,
    this.skipFavoriteAnimation = false,
  }) : super(key: key);

  final EventService? eventService;
  final Event currentEvent;
  final int index;
  final String tag;
  final bool skipFavoriteAnimation;

  @override
  Widget build(BuildContext context) {
    final dateText = currentEvent.eventDate;

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
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: currentEvent.photo != null
                        ? CachedNetworkImage(
                            imageUrl: currentEvent.photo!,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/img_bg.png',
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/img_bg.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: DefaultTheme.darkerItem,
                  ),
                ],
              ),
              // card body
              Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Container(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.topLeft,
                          child: AutoSizeText(
                            dateText,
                            style: Get.theme.textTheme.subtitle1!.copyWith(height: 1, fontSize: 14, fontWeight: FontWeight.w600),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          width: double.infinity,
                          child: AutoSizeText(
                            currentEvent.name?.capitalizeFirst ?? '',
                            //'${index}',
                            style: Get.theme.textTheme.headline3!.copyWith(fontSize: 26),
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 60,
                            child: Row(
                              children: [
                                Container(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: AutoSizeText(
                                            currentEvent.societyInfo?.name?.capitalizeFirst ?? '',
                                            style: Get.textTheme.headline4!,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            child: AutoSizeText(
                                              currentEvent.address?.capitalizeFirst ?? '',
                                              style: Get.textTheme.subtitle2!,
                                              maxLines: 1,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    splashColor: Get.theme.primaryColorDark.withOpacity(0.2),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      //Get.toNamed(AppRoutes.EVENT_DETAIL, arguments: currentEvent.id, preventDuplicates: false,);
                      await Future.delayed(Constant.DURATION_CLICK);
                      eventService!.goToEventDetail(eventId: currentEvent.id);
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    //await Future.delayed(Constant.DURATION_CLICK);
                    eventService!.setFavourite(
                      event: currentEvent,
                      isFavorite: !currentEvent.isFavorite!,
                      tag: tag,
                    );
                  }
                  //controller.events.refresh();
                  ,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: FractionallySizedBox(
                      widthFactor: 0.08,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: skipFavoriteAnimation
                            ? Container(
                                key: ValueKey('${currentEvent.id}${currentEvent.isFavorite}'),
                                child: currentEvent.isFavorite!
                                    ? SvgPicture.asset(
                                        'assets/images/ic_joined.svg',
                                        color: DefaultTheme.danger,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/ic_favourites.svg',
                                        color: Colors.white,
                                      ),
                              )
                            : AnimatedSwitcher(
                                duration: Constant.FAST_ANIMTAION_DURATION,
                                switchOutCurve: Curves.elasticOut,
                                switchInCurve: Curves.elasticIn,
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    child: child,
                                    scale: animation,
                                  );
                                },
                                child: Container(
                                  key: ValueKey('${currentEvent.id}${currentEvent.isFavorite}'),
                                  child: currentEvent.isFavorite!
                                      ? SvgPicture.asset(
                                          'assets/images/ic_joined.svg',
                                          color: DefaultTheme.danger,
                                        )
                                      : SvgPicture.asset(
                                          'assets/images/ic_favourites.svg',
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 60,
                      child: Row(
                        children: [
                          Container(
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    await Future.delayed(Constant.DURATION_CLICK);

                                    if (currentEvent.societyInfo?.id != null) Get.toNamed(AppRoutes.SOCIETY_DETAIL, arguments: currentEvent.societyInfo!.id);
                                  },
                                  child: currentEvent.societyInfo?.cover != null
                                      ? CachedNetworkImage(
                                          imageUrl: currentEvent.societyInfo!.cover!,
                                          placeholder: (context, url) => SharedImagePlaceHolder(
                                            imageAsset: 'assets/images/ic_society.svg',
                                            bgColor: Get.theme.primaryColor.withOpacity(0.8),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : SharedImagePlaceHolder(
                                          imageAsset: 'assets/images/ic_society.svg',
                                          bgColor: Get.theme.primaryColor.withOpacity(0.8),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
