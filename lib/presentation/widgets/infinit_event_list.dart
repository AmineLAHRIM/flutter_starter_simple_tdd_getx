import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/core/loading/loading_state.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/presentation/shared/shared_empty_error_message.dart';
import 'package:flutter_starter/presentation/shared/shared_error_message.dart';
import 'package:flutter_starter/presentation/shared/shared_new_page_progress_indicator.dart';
import 'package:flutter_starter/presentation/widgets/event_ad_item.dart';
import 'package:flutter_starter/presentation/widgets/event_item.dart';
import 'package:flutter_starter/services/event_service.dart';

class InfinitEventList extends StatefulWidget {
  InfinitEventList({
    Key? key,
    required this.pagingController,
    required this.eventService,
    this.animatedListKey,
    required this.bodyHeight,
    required this.controller,
    required this.id,
    this.skipFavoriteAnimation = false,
  }) : super(key: key);

  final PagingController<int, Event> pagingController;
  final EventService eventService;
  final animatedListKey;
  final bodyHeight;
  final int? id;
  final dynamic controller;
  final bool skipFavoriteAnimation;

  @override
  _InfinitEventListState createState() => _InfinitEventListState();
}

class _InfinitEventListState extends State<InfinitEventList> {
  var isList = false;
  var isInit = true;

  //

  @override
  void initState() {
    isList = widget.pagingController.itemList?.isNotEmpty ?? false;
    //

    widget.pagingController.addListener(() {
      final currentIsList =
          widget.pagingController.itemList?.isNotEmpty ?? false;
      if (currentIsList != isList) {
        if (mounted) {
          setState(() {
            isList = currentIsList;
            //
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pagedChildBuilderDelegate = PagedChildBuilderDelegate<Event>(
      itemBuilder: (context, event, index) {
        Widget child;

        if (event.isAdsItem) {
          child = EventAdItem(
            key: Key('${event.adId}'),
            currentEvent: event,
            index: index,
            eventService: widget.eventService,
            onRemoveErrorLoadingAd: ({adId}) {
              /*
              * Because of PreLoading of Ad so if there is no cox this fun will be trigged before the Widget Render in the list
              * so it will not be removed from the list until you refresh to list or scroll down then up to refresh the list items widgets
              * */
            },
            customNativeAd: event.customNativeAd,
          );
        } else {
          child = EventItem(
            currentEvent: event,
            eventService: widget.eventService,
            index: index,
            tag: widget.controller.tag,
            skipFavoriteAnimation: widget.skipFavoriteAnimation,
          );
        }
        return Container(
          child: AspectRatio(
            aspectRatio: SizeConfig.LIST_EVENT_RATIO,
            child: Container(
              //margin: EdgeInsets.only(bottom: 8),
              width: double.infinity,
              height: double.infinity,
              child: child,
            ),
          ),
        );
      },
      firstPageErrorIndicatorBuilder: (context) {
        var message = 'Data not found please try later!';

        final error = widget.pagingController.error;
        if (error is ERROR) {
          message = error.message ?? message;
        }

        return Container(
          width: double.infinity,
          height: widget.bodyHeight,
          child: SharedErrorMessage(
            message: message,
            onTapRefresh: () {
              widget.controller.onRefresh(widget.id);
            },
          ),
        );
      },
      noItemsFoundIndicatorBuilder: (context) {
        var message = 'Data not found please try later!';

        if (widget.id == 0) {
          message = 'No events yet!';
        } else if (widget.id == 1) {
          message = 'Try to add a favorite event!';
        } else if (widget.id == 2) {
          message = 'No society events for you yet!';
        } else if (widget.id == 3) {
          message = 'No attending events yet!';
        }

        return SharedEmptyErrorMessage(
            bodyHeight: widget.bodyHeight, message: message);
      },
      firstPageProgressIndicatorBuilder: (context) {
        return Container(
          width: double.infinity,
          height: widget.bodyHeight,
          child: RefreshIndicator(
            onRefresh: () {
              return widget.controller.onRefresh(widget.id, isBySwipe: true);
            },
            color: Get.theme.backgroundColor,
            child: Center(child: CircularProgressIndicator(),),
              //EventListLoading()
          ),
        );
      },
      newPageProgressIndicatorBuilder: (context) {
        return SharedNewPageProgressIndicator();
      },
      /*newPageErrorIndicatorBuilder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            color: Colors.red,
          );
        },
        newPageProgressIndicatorBuilder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            color: Colors.yellowAccent,
          );
        },
        noMoreItemsIndicatorBuilder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            color: Colors.lightGreenAccent,
          );
        },*/
    );
    Widget pagedListView;
    if (SizeConfig.isMobile) {
      pagedListView = PagedListView(
        cacheExtent: 8,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: isList
            ? EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            : EdgeInsets.zero,
        pagingController: widget.pagingController,
        builderDelegate: pagedChildBuilderDelegate,
      );
    } else {
      pagedListView = PagedGridView(
        cacheExtent: 8,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        pagingController: widget.pagingController,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: SizeConfig.gridMaxCrossAxisExtent,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: SizeConfig.LIST_EVENT_RATIO,
        ),
        padding: isList
            ? EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            : EdgeInsets.zero,
        //padding: EdgeInsets.zero,
        builderDelegate: pagedChildBuilderDelegate,
      );
    }

    /*if (isList) {
      //

      pagedListView = Entry.all(
          scale: 1,
          yOffset: Constant.ENTRY_YOFFSET_LIST,
          //delay: Constant.FAST_ANIMTAION_DURATION,
          //curve: Curves.easeInCirc,
          duration: Constant.LONG_ANIMTAION_DURATION,
          child: pagedListView);
    }*/

    return pagedListView;
  }
}
