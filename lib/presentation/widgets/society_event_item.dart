import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/config/themes/default/default_theme.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/extension/event_date_ext.dart';
import 'package:flutter_starter/services/event_service.dart';

class SocietyEventItem extends StatelessWidget {
  const SocietyEventItem({
    Key? key,
    required this.eventService,
    required this.currentEvent,
    required this.index,
  }) : super(key: key);

  final EventService? eventService;
  final Event currentEvent;
  final int index;

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            style: Get.theme.textTheme.headline3!.copyWith(fontSize: 26),
                            maxLines: 2,
                          ),
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
