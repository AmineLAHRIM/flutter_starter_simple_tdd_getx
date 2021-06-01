import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_starter/config/size_config.dart';
import 'package:flutter_starter/core/loading/loading_state.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/presentation/shared/shared_empty_error_message.dart';
import 'package:flutter_starter/presentation/shared/shared_error_message.dart';
import 'package:flutter_starter/presentation/shared/shared_new_page_progress_indicator.dart';
import 'package:flutter_starter/presentation/widgets/horizontal_event_list_loading.dart';
import 'package:flutter_starter/presentation/widgets/society_event_item.dart';
import 'package:flutter_starter/services/event_service.dart';

class InfinitHorizontalEvents extends StatefulWidget {
  InfinitHorizontalEvents({
    Key? key,
    required this.pagingController,
    this.bodyHeight = 0,
    required this.eventService,
    required this.onRefresh,
    this.isNestedList = false,
  }) : super(key: key);

  final PagingController<int, Event> pagingController;
  final double bodyHeight;
  final bool isNestedList;
  final VoidCallback onRefresh;
  final EventService? eventService;
  final isPagingPreLoaded = true;

  @override
  _InfinitHorizontalEventsState createState() => _InfinitHorizontalEventsState();
}

class _InfinitHorizontalEventsState extends State<InfinitHorizontalEvents> {
  var isList = false;

  @override
  void initState() {
    isList = widget.pagingController.itemList?.isNotEmpty ?? false;

    widget.pagingController.addListener(() {
      final currentIsList = widget.pagingController.itemList?.isNotEmpty ?? false;
      if (currentIsList != isList) {
        if (mounted) {
          setState(() {
            isList = currentIsList;
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
          child = Container();
          /*EventAdItem(
            currentEvent: event,
            index: index,
            onRemoveErrorLoadingAd: ({required index}) {
              widget.eventService!.removeErrorSearchEventLoadedAd(
                index: index,
              );
            },
          );*/
        } else {
          child = SocietyEventItem(eventService: widget.eventService, currentEvent: event, index: index);
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
        var message = 'Failed loading events please try later!';

        final error = widget.pagingController.error;
        if (error is ERROR) {
          message = error.message ?? message;
        }

        return Container(
          width: double.infinity,
          height: widget.bodyHeight,
          child: SharedErrorMessage(
            message: message,
            isImageVisible: false,
            onTapRefresh: () => widget.onRefresh(),
          ),
        );
      },
      noItemsFoundIndicatorBuilder: (context) {
        var message = 'No events yet!';

        return SharedEmptyErrorMessage(bodyHeight: widget.bodyHeight, message: message);
      },
      firstPageProgressIndicatorBuilder: (context) {
        return Container(
          width: double.infinity,
          height: widget.bodyHeight,
          child: HorizontalEventListLoading(),
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

        noMoreItemsIndicatorBuilder: (context) {
          return Container(
            width: double.infinity,
            height: 400,
            color: Colors.lightGreenAccent,
          );
        },*/
    );

    Widget pagedListView = PagedListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollDirection: isList ? Axis.horizontal : Axis.vertical,
      physics: isList ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
      padding: isList ? EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.zero,
      pagingController: widget.pagingController,
      builderDelegate: pagedChildBuilderDelegate,
    );

    /*if (isList) {
      pagedListView = Entry.all(
          scale: 1,
          xOffset: Constant.ENTRY_YOFFSET_LIST,
          yOffset: 0,
          delay: Constant.DURATION2,
          //curve: Curves.easeInCirc,
          duration: Constant.LONG_ANIMTAION_DURATION,
          child: pagedListView);
    }*/

    return pagedListView;
  }
}
