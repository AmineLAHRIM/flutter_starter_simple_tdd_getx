import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/error/errors.dart';
import 'package:flutter_starter/core/error/failures.dart';
import 'package:flutter_starter/core/loading/loading_state.dart';
import 'package:flutter_starter/core/routes/app_routes.dart';
import 'package:flutter_starter/data/models/custom_native_ad.dart';
import 'package:flutter_starter/data/models/dto/events_dto.dart';
import 'package:flutter_starter/data/models/enums/distance_unit.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:flutter_starter/data/models/filters/sort_by.dart';
import 'package:flutter_starter/data/repos/abstract/event_repo.dart';
import 'package:flutter_starter/services/auth_service.dart';

enum ListId {
  ALLEVENT,
  FAVORITE,
  MYSOCIETY,
  ATTENDING,
  SEARCHEVENT,
  SEARCHSOCIETY,
}

@lazySingleton
class EventService {
  List<int> loadedTabIndex = [];

  Rx<DistanceUnit?> selectedDistanceUnit = DistanceUnit.MI.obs;

  final ALLEVENT_INDEX_TAB = 0;
  final FAVORITE_INDEX_TAB = 1;
  final MYSOCIETY_INDEX_TAB = 2;
  final ATTENDING_INDEX_TAB = 3;

  PagingController<int, Event>? pagingAllEventController;
  PagingController<int, Event>? pagingFavoriteEventController;
  PagingController<int, Event>? pagingMySocitiyEventController;
  PagingController<int, Event>? pagingAttendingEventController;
  PagingController<int, Event>? pagingSearchEventsController;

  // State for message of Event Added or Removed from favorite list
  var favoriteEventItemState = Rx<LoadingState?>(null);
  var currentEventState = Rx<Event?>(null);
  String? tagController;

  /*
  * this for pause the already request that didn't get result yet to have a replacement for unfavorite event from the favorite list
  * then will resumed by making the pagging state to the saved current state for favorite last loaded page
  * */
  bool isFavoriteListPagingPaused = false;
  var savedFavoritePagingError;

  // this is a complter for refresh or first fetch of the favorite list
  Completer<bool>? firstFetchOrRefreshFavoritePageCompleter;

  // this algo for cancel all multiple click for a specifi favorite event and send the last one only [reduce backend resources]
  int currentFavEventId = -1;
  int timesofClicksFav = 0;

  // for save the current state for favorite last loaded page
  int currentFavoritePage = 0;

  // total of favorite items
  int favoriteTotal = 0;

  /*
  * for multiple request of remove favorite then the pagging will be paused until the last one have their replaced favorite event if it have
  * and if it haven't it will make the state of pagging to end by appendlast([])
  * */
  List<Completer<bool>> unfavcompleters = [];
  Completer<bool>? lastunfavCompleter;

  /*
  * for multiple request of add favorite then all the request will be ignore to refresh
  * the favorite page until the last request then the favorite will be refreshed by getting 1st page size and refresh the state of pagging to 2
  * */
  List<Completer<bool>> favcompleters = [];
  Completer<bool>? lastfavCompleter;

  //________________________________________

  EventRepo? eventRepo;
  AuthService? authService;
  EventsDto? searchEventsFilterParams;

  //final GlobalKey<AnimatedListState> allEventsAnimatedListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> favoriteEventsAnimatedListKey = GlobalKey<AnimatedListState>();

  //final GlobalKey<AnimatedListState> societyEventsAnimatedListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> attendingEventsAnimatedListKey = GlobalKey<AnimatedListState>();

  EventService({this.eventRepo, this.authService}) {
    getDistanceUnit();
  }

  bool isEventTabStarted({int? index}) {
    //if (loadedTabIndex.contains(index)) {
    if (index == 0) {
      return (pagingAllEventController!.value.status == PagingStatus.firstPageError) || ((pagingAllEventController!.value.nextPageKey ?? 2) > 1 && pagingAllEventController!.value.status != PagingStatus.loadingFirstPage);
    } else if (index == 1) {
      return (pagingFavoriteEventController!.value.status == PagingStatus.firstPageError) || ((pagingFavoriteEventController!.value.nextPageKey ?? 2) > 1 && pagingFavoriteEventController!.value.status != PagingStatus.loadingFirstPage);
    } else if (index == 2) {
      return (pagingMySocitiyEventController!.value.status == PagingStatus.firstPageError) || ((pagingMySocitiyEventController!.value.nextPageKey ?? 2) > 1 && pagingMySocitiyEventController!.value.status != PagingStatus.loadingFirstPage);
    } else if (index == 3) {
      return (pagingAttendingEventController!.value.status == PagingStatus.firstPageError) || ((pagingAttendingEventController!.value.nextPageKey ?? 2) > 1 && pagingAttendingEventController!.value.status != PagingStatus.loadingFirstPage);
    }
    //}
    return false;
  }

  void fetchAllEventPage(int pageKey) async {
    int currentRefreshTime = preventDuplicatedRefresh(listId: ListId.ALLEVENT, pageKey: pageKey);
    //await Future.delayed(Duration(seconds: 2));
    print('params =${describeEnum(SortByType.START_DATE)}');
    final failureOrEventsPagination = await this.eventRepo!.getEvents(
          eventsDto: EventsDto(
            page: pageKey,
            //upcoming
            endDateGte: DateTime.now(),
            sortBy: describeEnum(SortByType.START_DATE),
            isAsc: true,
          ),
        );

    if (currentRefreshTime != refreshAllEventListTimes) {
      return;
    }

    failureOrEventsPagination.fold((failure) {
      if (failure is TokenFailure) {
        this.authService!.logout(byToken: true);
      } else {
        pagingAllEventController!.error = ERROR(message: failure.toString(), type: MessageType.danger);
      }
    }, (eventsPagination) {
      var newItems = eventsPagination.list!;

      /*final previouslyItemsSize = pagingAllEventController!.itemList
              ?.where((element) => element.isAdsItem == false)
              ?.toList()
              ?.length ??
          0;*/

      final previouslyItemsSize = pagingAllEventController!.itemList?.length ?? 0;
      final currentTotalCount = previouslyItemsSize + newItems.length;

      final isLastPage = currentTotalCount >= eventsPagination.total!;

      // Here Ad Advertising to the List
      if (Constant.ENABLE_ADS) newItems = addNativeAdsList(list: newItems, previouslyItemsSize: previouslyItemsSize, listId: ListId.ALLEVENT);

      if (isLastPage) {
        // 3
        pagingAllEventController!.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingAllEventController!.appendPage(newItems, nextPageKey);
      }
    });

//return failureOrEventsPagination;
  }

  void pauseFavoriteListPaging() {
    pagingFavoriteEventController?.appendLastPage([]);
    isFavoriteListPagingPaused = true;
    print('newItems paused');
  }

  void resumeFavoriteListPaging({List<Event> newItems = const [], int? nextPageKey, bool isLastPage = false, var error}) {
    isFavoriteListPagingPaused = false;
    if (isLastPage) {
      print('newItems resumed tolast');
      pagingFavoriteEventController?.appendLastPage(newItems);
    } else {
      print('newItems resumed with nextPageKey=$nextPageKey');
      pagingFavoriteEventController?.appendPage(newItems, nextPageKey);
      //pagingFavoriteEventController!.value=PagingState<int,Event>(nextPageKey: nextPageKey,error: error,itemList: newItems);
    }
    pagingFavoriteEventController!.error = error;
  }

  bool checkIsLastPage({
    @required int previouslyItemsSize = -1,
    @required int newItemsSize = 0,
    @required int totalListSize = 0,
  }) {
    if (previouslyItemsSize == -1) previouslyItemsSize = pagingFavoriteEventController!.itemList?.where((element) => element.isAdsItem == false)?.toList()?.length ?? 0;

    final currentTotalCount = previouslyItemsSize + newItemsSize;
    return currentTotalCount >= totalListSize;
  }

  void fetchFavoriteEventPage(int pageKey) async {
    // if Event Favorite tab didn't start loading
    /*if (!isEventTabStarted(index: FAVORITE_INDEX_TAB)) {
      return;
    }*/
    if (isFavoriteListPagingPaused) {
      return;
    }

    int currentRefreshTime = preventDuplicatedRefresh(listId: ListId.FAVORITE, pageKey: pageKey);

    if (pageKey == 1) {
      // here on refresh or first time fetch
      firstFetchOrRefreshFavoritePageCompleter = Completer<bool>();
      await Future.delayed(Duration(seconds: 1));
      currentFavoritePage = 1;
    } else {
      final isLastPage = checkIsLastPage(totalListSize: favoriteTotal);
      if (isLastPage) {
        if (currentFavoritePage != -1) {
          pagingFavoriteEventController!.appendLastPage([]);
          currentFavoritePage = -1;
        }
        return;
      }
    }
    final failureOrEventsPagination = await this.eventRepo!.getEvents(eventsDto: EventsDto(page: pageKey, isFavourite: true));

    // this conditions for ignore all current request response for the new refresh list
    if (currentRefreshTime != refreshFavListTimes) {
      return;
    }

    failureOrEventsPagination.fold((failure) {
      if (failure is TokenFailure) {
        this.authService!.logout(byToken: true);
      } else {
        pagingFavoriteEventController!.error = ERROR(message: failure.toString(), type: MessageType.danger);
        /*final isLastPage = checkIsLastPage(totalListSize: favoriteTotal);
        print('PAGEINFO EVENTS_NOT_EXISTS__________pageKey=${pageKey} currentPage=${currentPage} isLastPage=${isLastPage}');
*/
        /*if (failure.toString() == Messages.EVENTS_NOT_EXISTS) {
          final isLastPage = checkIsLastPage(totalListSize: favoriteTotal);
          print('PAGEINFO EVENTS_NOT_EXISTS__________pageKey=${pageKey} currentPage=${currentPage} isLastPage=${isLastPage}');
          pagingFavoriteEventController!.appendLastPage([]);
          currentPage = null;
        } else {
          pagingFavoriteEventController!.error = ERROR(message: failure.toString(), type: MessageType.danger);
        }*/
      }
    }, (eventsPagination) {
      var newItems = eventsPagination.list!;
      if (pageKey == 1) favoriteTotal = eventsPagination.total ?? 0;
      final previouslyItemsSize = pagingFavoriteEventController!.itemList?.where((element) => element.isAdsItem == false)?.toList()?.length ?? 0;

      final isLastPage = checkIsLastPage(
        previouslyItemsSize: previouslyItemsSize,
        newItemsSize: newItems.length,
        totalListSize: favoriteTotal,
      );

      // Here Ad Advertising to the List
      //if (Constant.ENABLE_ADS) newItems = addNativeAdsList(list: newItems, previouslyItemsSize: previouslyItemsSize);

      if (isLastPage) {
        // 3
        pagingFavoriteEventController!.appendLastPage(newItems);
        currentFavoritePage = -1;
        getListDebug(isFavorite: true, title: 'Last newItems', list: newItems);
      } else {
        final nextPageKey = pageKey + 1;
        currentFavoritePage = pageKey;
        pagingFavoriteEventController!.appendPage(newItems, nextPageKey);
        getListDebug(isFavorite: true, title: 'newItems', list: newItems);
      }
    });

    if (pageKey == 1) {
      if (firstFetchOrRefreshFavoritePageCompleter != null && !firstFetchOrRefreshFavoritePageCompleter!.isCompleted) firstFetchOrRefreshFavoritePageCompleter!.complete(true);
    }
    //return failureOrEventsPagination;
  }

  void fetchMySocietyEventPage(int pageKey) async {
    int currentRefreshTime = preventDuplicatedRefresh(listId: ListId.MYSOCIETY, pageKey: pageKey);

    final failureOrEventsPagination = await this.eventRepo!.getEvents(
          eventsDto: EventsDto(
            page: pageKey,
            isFollowed: true,
            //upcoming
            endDateGte: DateTime.now(),
            sortBy: describeEnum(SortByType.START_DATE),
            isAsc: true,
          ),
        );
    if (currentRefreshTime != refreshMySocietyListTimes) {
      return;
    }
    failureOrEventsPagination.fold((failure) {
      if (failure is TokenFailure) {
        this.authService!.logout(byToken: true);
      } else {
        pagingMySocitiyEventController!.error = ERROR(message: failure.toString(), type: MessageType.danger);
      }
    }, (eventsPagination) {
      var newItems = eventsPagination.list!;

      final previouslyItemsSize = pagingMySocitiyEventController!.itemList?.where((element) => element.isAdsItem == false)?.toList()?.length ?? 0;
      final currentTotalCount = previouslyItemsSize + newItems.length;

      final isLastPage = currentTotalCount >= eventsPagination.total!;

      // Here Ad Advertising to the List
      if (Constant.ENABLE_ADS) newItems = addNativeAdsList(list: newItems, previouslyItemsSize: previouslyItemsSize, listId: ListId.MYSOCIETY);

      if (isLastPage) {
        // 3
        pagingMySocitiyEventController!.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingMySocitiyEventController!.appendPage(newItems, nextPageKey);
      }
    });

    // return failureOrEventsPagination;
  }

  void fetchAttendingEventPage(int pageKey) async {
    int currentRefreshTime = preventDuplicatedRefresh(listId: ListId.ATTENDING, pageKey: pageKey);

    final failureOrEventsPagination = await this.eventRepo!.getEvents(
          eventsDto: EventsDto(
            page: pageKey,
            //updated_at desc
            sortBy: describeEnum(SortByType.UPDATED_AT),
            isAttending: true,
          ),
        );

    if (currentRefreshTime != refreshAttendingListTimes) {
      return;
    }
    failureOrEventsPagination.fold((failure) {
      if (failure is TokenFailure) {
        this.authService!.logout(byToken: true);
      } else {
        pagingAttendingEventController!.error = ERROR(message: failure.toString(), type: MessageType.danger);
      }
    }, (eventsPagination) {
      var newItems = eventsPagination.list!;

      final previouslyItemsSize = pagingAttendingEventController!.itemList?.where((element) => element.isAdsItem == false)?.toList()?.length ?? 0;
      final currentTotalCount = previouslyItemsSize + newItems.length;

      final isLastPage = currentTotalCount >= eventsPagination.total!;

      // Here Ad Advertising to the List
      if (Constant.ENABLE_ADS) newItems = addNativeAdsList(list: newItems, previouslyItemsSize: previouslyItemsSize, listId: ListId.ATTENDING);

      if (isLastPage) {
        // 3
        pagingAttendingEventController!.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingAttendingEventController!.appendPage(newItems, nextPageKey);
      }
    });

    //return failureOrEventsPagination;
  }

  removeErrorLoadedAd({int? id, int? index}) {
    if (id == null || index == null) return;

    if (id == 0) {
      if (index != -1) {
        //final ev = pagingAllEventController!.itemList!.toList()[index!];
        pagingAllEventController!.itemList?.removeAt(index);
        pagingAllEventController!.notifyListeners();
        //print('removeErrorLoadedAd evIndex=${index} ev.isAdsItem=${ev.isAdsItem} ev.isAdLoaded=${ev.isAdLoaded} listlength before=${pagingAllEventController!.itemList!.length}');
        print('$NativeAd.. failedToLoad: item ${index} REMOVED');

        print('removeErrorLoadedAd removed evIndex=${index}');
      }

      //print('removeErrorLoadedAd id=${id} index=${index} listlength after=${pagingAllEventController!.itemList!.length}');

    } else if (id == 1) {
      if (pagingFavoriteEventController!.itemList!.length - 1 >= index) {
        pagingFavoriteEventController!.itemList?.removeAt(index);
        pagingFavoriteEventController!.notifyListeners();
      }
    } else if (id == 2) {
      if (pagingMySocitiyEventController!.itemList!.length - 1 >= index) {
        pagingMySocitiyEventController!.itemList?.removeAt(index);
        pagingMySocitiyEventController!.notifyListeners();
      }
    } else if (id == 3) {
      if (pagingAttendingEventController!.itemList!.length - 1 >= index) {
        pagingAttendingEventController!.itemList?.removeAt(index);
        pagingAttendingEventController!.notifyListeners();
      }
    }
  }

  removeErrorSearchEventLoadedAd({required int index}) {
    pagingSearchEventsController!.itemList?.removeAt(index);
    pagingSearchEventsController!.notifyListeners();
  }

  List<Event> addNativeAdsList({required List<Event> list, int previouslyItemsSize = 0, required ListId listId}) {
    List<Event> returnedList = [];
    /*for (int i = 0; i <= list.length - 1; i++) {
      final adIndex =
          ((i + previouslyItemsSize) % Constant.INDEX_EACH_NATIVE_ADS_TO_SHOW)
              .toInt();
      if (i > 0 && adIndex == 0) {
        final newNativeAdsObj = Event(id: -2, isAdsItem: true);
        returnedList.add(newNativeAdsObj);
      }
      returnedList.add(list[i]);
    }*/

    ///New
    for (int i = previouslyItemsSize; i <= previouslyItemsSize + list.length - 1; i++) {
      print('ads index=${i}');
      if (i != 0 && Constant.INDEX_EACH_NATIVE_ADS_TO_SHOW > 1 && (i % Constant.INDEX_EACH_NATIVE_ADS_TO_SHOW).toInt() == 0) {
        final index = i - previouslyItemsSize;
        final newNativeAdsObj = Event(id: -2, isAdsItem: true);
        // Genearte CustomNativeAd
        final customNativeAd = generatedCustomNativeAd(index: i, event: newNativeAdsObj);
        saveAdToBeDisposed(customNativeAd: customNativeAd, listId: listId);
        // insert Object to list
        newNativeAdsObj.customNativeAd = customNativeAd;
        list.insert(index, newNativeAdsObj);
        //returnedList.add(list[index]);
      }
    }
    return list;
  }

  CustomNativeAd generatedCustomNativeAd({required int index, required Event event}) {
    //final adId = Uuid().v4();
    final adId = '${index}';
    print('$NativeAd.. loading. index=${index}');
    // Generate customNativeAd for nextIndex + added to customNativeAds List
    final Completer<NativeAd> nativeAdCompleter = Completer<NativeAd>();
    NativeAd nativeAd = NativeAd(
      adUnitId: Constant.NATIVE_AD_ID,
      request: AdRequest(),
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd.. loaded. index=${index}');
          nativeAdCompleter.complete(ad as NativeAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          //print('$NativeAd.. failedToLoad: $error');
          print('$NativeAd.. failedToLoad: ${index} event ${event.isAdLoading} ${event.isAdLoaded} ${event.isAdsItem}');
          //removeErrorLoadedAd(id: 0, index: index);

          if (event.isAdsItem && !event.isAdLoaded) {
            removeErrorLoadedAd(id: 0, index: index);
          } else {}
          nativeAdCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$NativeAd.. onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        //onApplicationExit: (Ad ad) => print('$NativeAd onApplicationExit.'),
      ),
    );
    nativeAd.load();
    return CustomNativeAd(adId: adId, nativeAd: nativeAd, nativeAdCompleter: nativeAdCompleter);
  }

  void fetchSearchEventsPage(int pageKey) async {
    int currentRefreshTime = preventDuplicatedRefresh(listId: ListId.SEARCHEVENT, pageKey: pageKey);

    EventsDto? params = EventsDto(
      page: pageKey,
      //upcoming
      endDateGte: DateTime.now(),
      sortBy: describeEnum(SortByType.START_DATE),
      isAsc: true,
    );
    if (searchEventsFilterParams != null) {
      searchEventsFilterParams!.page = pageKey;
      params = searchEventsFilterParams;
    }

    final failureOrEventsPagination = await this.eventRepo!.getEvents(eventsDto: params);
    if (currentRefreshTime != refreshSearchEventListTimes) {
      return;
    }

    failureOrEventsPagination.fold((failure) {
      if (failure is TokenFailure) {
        this.authService!.logout(byToken: true);
      } else {
        pagingSearchEventsController!.error = ERROR(message: failure.toString(), type: MessageType.danger);
      }
    }, (eventsPagination) {
      var newItems = eventsPagination.list!;

      final previouslyItemsSize = pagingSearchEventsController!.itemList?.where((element) => element.isAdsItem == false)?.toList()?.length ?? 0;
      final currentTotalCount = previouslyItemsSize + newItems.length;

      final isLastPage = currentTotalCount >= eventsPagination.total!;

      // Here Ad Advertising to the List
      if (Constant.ENABLE_ADS) newItems = addNativeAdsList(list: newItems, previouslyItemsSize: previouslyItemsSize, listId: ListId.SEARCHEVENT);

      if (isLastPage) {
        // 3
        pagingSearchEventsController!.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingSearchEventsController!.appendPage(newItems, nextPageKey);
      }
    });

    //return failureOrEventsPagination;
  }

  void getListDebug({bool? isFavorite, String? title, List<Event>? list}) {
    var s = '';
    if (list == null) {
      list = pagingFavoriteEventController!.itemList?.toList() ?? [];
    }
    list.forEach((element) {
      if (element.isAdsItem == false) {
        s += element.name! + ', ';
      }
    });
    print('[ListDebug$isFavorite] currentPage=$currentFavoritePage | $title | $s');
  }

//Click Favourite Button
  Future<bool> setFavourite({required Event event, bool isFavorite = false, String? tag}) async {
    if (event.id == null) {
      return Future.value(false);
    }

    tagController = tag;

    currentFavEventId = event.id!;

    // toggle the fav icon and add to fav list in UI only
    final favoriteIndex = await toggleFavourite(event: event, isFavorite: isFavorite);

    /*
    * Here try to wait if there multi click on favorite until
    * the user hold up the click from favourite of the same event then we send the request to server
    * */
    timesofClicksFav++;
    final int currentTimeClick = timesofClicksFav;
    // uncomment this
    await Future.delayed(Duration(seconds: 1));

    if (event.id == currentFavEventId && currentTimeClick != timesofClicksFav) {
      return false;
    }

    // Here to unlock/lock favorite request
    final currentCompleter = Completer<bool>();
    if (!isFavorite) {
      print('ListDebug 0');
      if (unfavcompleters.isEmpty) {
        unfavcompleters.add(currentCompleter);
        lastunfavCompleter = currentCompleter;
      } else {
        print('ListDebug 1');
        Completer<bool> currentlastCompleter = unfavcompleters.last;
        unfavcompleters.removeLast();
        unfavcompleters.add(currentCompleter);
        lastunfavCompleter = currentCompleter;
        if (!currentlastCompleter.isCompleted) {
          print('ListDebug 2');
          await currentlastCompleter.future;
          print('ListDebug 3');
        } else {
          print('ListDebug 4');
        }
      }
    } else {
      if (favcompleters.isEmpty) {
        favcompleters.add(currentCompleter);
        lastfavCompleter = currentCompleter;
      } else {
        Completer<bool> currentlastCompleter = favcompleters.last;
        favcompleters.removeLast();
        favcompleters.add(currentCompleter);
        lastfavCompleter = currentCompleter;
        if (!currentlastCompleter.isCompleted) {
          await currentlastCompleter.future;
        }
      }
    }

    // Send the request now
    EventsDto? params;

    if (favoriteIndex != -1) {
      params = EventsDto(page: getCurrentPageKey(), pageSize: Constant.LIST_PAGE_SIZE);
    }
    final failureOrFavouriteOrEvent = await eventRepo!.setFavourite(eventId: event.id!, isFavourite: event.isFavorite, eventsDto: params);

    return failureOrFavouriteOrEvent.fold((failure) {
      currentCompleter.complete(true);
      resumeFavoriteListPaging(nextPageKey: getCurrentPageKey() + 1, error: savedFavoritePagingError);
      print('newItems nextPageKey=${pagingFavoriteEventController!.nextPageKey} error savedpagingError=$savedFavoritePagingError');
      // here backup the saved error when paused paging and get error while set favorite in server
      return false;
    }, (r) {
      r.fold((favorite) async {
        if (event.isFavorite!) {
          //await refreshFavouritePage();
          final previouslyItems = pagingFavoriteEventController!.itemList?.where((element) => element.isAdsItem == false)?.toList() ?? [];

          getListDebug(isFavorite: isFavorite, title: 'events in list now', list: previouslyItems);

          final previouslyItemsSize = previouslyItems.length;
          if (previouslyItemsSize >= Constant.LIST_PAGE_SIZE) {
            // to pause paging listner
            //pauseFavoriteListPaging();

            final resultFavoriteEvents = previouslyItems.getRange(0, Constant.LIST_PAGE_SIZE).toList();
            //pagingFavoriteEventController!.notifyListeners();

            getListDebug(isFavorite: isFavorite, title: 'events that is selected for the first list now', list: resultFavoriteEvents);

            currentCompleter.complete(true);
            if (lastfavCompleter == currentCompleter) {
              final isLastPage = checkIsLastPage(
                previouslyItemsSize: resultFavoriteEvents.length,
                totalListSize: favoriteTotal,
              );
              pagingFavoriteEventController!.itemList!.clear();
              //pagingFavoriteEventController!.notifyListeners();

              //resume paging
              resumeFavoriteListPaging(newItems: resultFavoriteEvents, nextPageKey: 2, isLastPage: isLastPage);
              currentFavoritePage = 1;
            }
          } else {
            currentCompleter.complete(true);
          }
          //pagingFavoriteEventController!.refresh();
        } else {
          currentCompleter.complete(true);
        }
      }, (replacedEvent) {
        if (replacedEvent != null) {
          final isLastPage = checkIsLastPage(
            totalListSize: favoriteTotal,
          );

          if (isLastPage) {
            currentFavoritePage = -1;
          }

          getListDebug(isFavorite: false, title: 'events now before replaced  [${event.name}] => [${replacedEvent.name}]');

          //final length = pagingFavoriteEventController!.itemList?.length ?? 0;
          //if (favoriteIndex != -1 && length > 0 && pagingFavoriteEventController!.value.status != PagingStatus.completed) {
          var replacedEventAlreadyExist = false;
          final previouslyItemsSize = pagingFavoriteEventController!.itemList
                  ?.where((element) {
                    if (element.id == replacedEvent.id) replacedEventAlreadyExist = true;
                    return element.isAdsItem == false;
                  })
                  ?.toList()
                  ?.length ??
              0;

          if (favoriteIndex != -1 && !replacedEventAlreadyExist && currentFavoritePage != -1) {
            pagingFavoriteEventController!.itemList!.add(replacedEvent);
            pagingFavoriteEventController!.notifyListeners();
            getListDebug(isFavorite: false, title: 'events now after replaced  [${event.name}] => [${replacedEvent.name}]');

            currentCompleter.complete(true);
            // this 1 second only for the time between the click and send the request of favorite
            if (lastunfavCompleter == currentCompleter) {
              final isLastPage = checkIsLastPage(
                previouslyItemsSize: previouslyItemsSize,
                totalListSize: favoriteTotal,
              );
              //resume paging
              final nextPageKey = getCurrentPageKey() + 1;
              resumeFavoriteListPaging(newItems: [], nextPageKey: nextPageKey, isLastPage: isLastPage);
              if (isLastPage) currentFavoritePage = -1;
            }
            /*Future.delayed(Duration(seconds: 1), () {

            });*/
          } else {
            currentCompleter.complete(true);
            //resumeFavoriteListPaging(isLastPage: true);
          }
        } else {
          currentCompleter.complete(true);
          //resumeFavoriteListPaging();
        }
      });
      return true;
    });
  }

  int getCurrentPageKey() {
    var currentPageKey;
    currentPageKey = currentFavoritePage == -1 ? 0 : currentFavoritePage;
    if (currentFavoritePage == 0) {
      currentPageKey = (pagingFavoriteEventController!.value.nextPageKey ?? 1) - 1;
    } else {
      currentPageKey = currentPageKey;
    }
    currentPageKey = currentPageKey > 0 ? currentPageKey : 1;
    return currentPageKey;
  }

  void showFavoriteMsgs({required bool isFavorite}) {
    // Handle Messages
    print('FAV 0');
    favoriteEventItemState.value = LOADING();
    if (isFavorite) {
      print('FAV 1');
      //favoriteEventItemState.subject.add(ERROR(message: 'Event added to favorites!', type: MessageType.success));
      favoriteEventItemState.value = ERROR(message: 'Event added to favorites!', type: MessageType.success);
    } else {
      print('FAV 1_1');
      // Show SnackBar for deleted event
      //favoriteEventItemState.subject.add(ERROR(message: 'Event removed from favorites!', type: MessageType.danger));
      favoriteEventItemState.value = ERROR(message: 'Event removed from favorites!', type: MessageType.danger);
    }
  }

  Future<int> toggleFavourite({required Event event, bool isFavorite = false}) async {
    var favoriteIndex = -1;
    print('DISPOSED 0');

    // toggle the favourite
    event.isFavorite = isFavorite;

    // Show Messages
    showFavoriteMsgs(isFavorite: isFavorite);

    // is the event existe in the all event should refrech their state
    final indexAllEvent = pagingAllEventController?.itemList?.indexWhere((element) => element.id == event.id) ?? -1;
    if (indexAllEvent != -1) {
      var ev = pagingAllEventController!.itemList![indexAllEvent];
      ev.isFavorite = event.isFavorite;
      pagingAllEventController!.itemList![indexAllEvent] = ev;
      pagingAllEventController!.notifyListeners();
    }
    print('DISPOSED 1');

    // is the event existe in the my society event should refrech their state
    final indexMySociety = pagingMySocitiyEventController?.itemList?.indexWhere((element) => element.id == event.id) ?? -1;
    if (indexMySociety != -1) {
      var ev = pagingMySocitiyEventController!.itemList![indexMySociety];
      ev.isFavorite = event.isFavorite;
      pagingMySocitiyEventController!.itemList![indexMySociety] = event;
      pagingMySocitiyEventController!.notifyListeners();
    }
    print('DISPOSED 2');

    // is the event existe in the my attending event should refrech their state
    final indexAttending = pagingAttendingEventController?.itemList?.indexWhere((element) => element.id == event.id) ?? -1;
    if (indexAttending != -1) {
      var ev = pagingAttendingEventController!.itemList![indexAttending];
      ev.isFavorite = event.isFavorite;
      pagingAttendingEventController!.itemList![indexAttending] = event;
      pagingAttendingEventController!.notifyListeners();
    }
    print('DISPOSED 3');

    // is the event existe in the my attending event should refrech their state
    //final indexSearchEvent = pagingAttendingEventController!.itemList?.indexWhere((element) => element.id == event.id) ?? -1;
    final indexSearchEvent = pagingSearchEventsController?.itemList?.indexWhere((element) => element.id == event.id) ?? -1;
    if (indexSearchEvent != -1) {
      var ev = pagingSearchEventsController!.itemList![indexSearchEvent];
      ev.isFavorite = event.isFavorite;
      pagingSearchEventsController!.itemList![indexSearchEvent] = event;
      pagingSearchEventsController!.notifyListeners();
    }
    print('DISPOSED 4');

    // here to wait until the first fetch of list loaded then start adding the waiting favorite events
    if (firstFetchOrRefreshFavoritePageCompleter != null && !firstFetchOrRefreshFavoritePageCompleter!.isCompleted) {
      await firstFetchOrRefreshFavoritePageCompleter?.future;
    }

    if (isEventTabStarted(index: FAVORITE_INDEX_TAB)) {
      if (event.isFavorite!) {
        // is the event state change to [isFavourite=true] should add to favouriteList
        //final status = pagingFavoriteEventController!.value.status;
        favoriteTotal++;

        //before pause know if paging have error
        savedFavoritePagingError = pagingFavoriteEventController!.error;

        //pause in time when click to favorite event
        pauseFavoriteListPaging();

        pagingFavoriteEventController!.itemList!.insert(0, event);
        pagingFavoriteEventController!.notifyListeners();
        favoriteIndex = 0;
      } else {
        if (favoriteTotal > 0) favoriteTotal--;

        // is the event state change to [isFavourite=false] should remove from favouriteList if exist

        // search the index of unfavorite event from the list of favorite
        favoriteIndex = pagingFavoriteEventController?.itemList?.indexWhere((element) => element.id == event.id) ?? -1;
        if (favoriteIndex != -1) {
          /*favoriteEventsAnimatedListKey.currentState
            ?.removeItem(favoriteIndex, (_, animation) => SharedAnimation.slideIt(_, favoriteIndex, animation), duration: const Duration(milliseconds: 700));*/
          //final nextPageKey=pagingFavoriteEventController!.nextPageKey;
          savedFavoritePagingError = pagingFavoriteEventController!.error;

          currentFavoritePage = getCurrentPageKey();
          // pause paging from listner to scrolling
          pauseFavoriteListPaging();

          // remove unfavorite event from the list
          pagingFavoriteEventController!.itemList!.removeAt(favoriteIndex);
          pagingFavoriteEventController!.notifyListeners();
        }
      }
    }
    print('DISPOSED 5');

    return Future.value(favoriteIndex);
  }

// Rest
  void resetAllEvent() {
    /*pagingAllEventController!.nextPageKey = 1;
    pagingAllEventController!.itemList?.clear();*/
  }

  void resetFavoriteEventList() {
    favcompleters.clear();
    unfavcompleters.clear();
    lastunfavCompleter = null;
    lastfavCompleter = null;
    firstFetchOrRefreshFavoritePageCompleter = null;
    isFavoriteListPagingPaused = false;
    savedFavoritePagingError = null;
    currentFavoritePage = 0;
    favoriteTotal = 0;
    /*pagingFavoriteEventController?.nextPageKey = 1;
    pagingFavoriteEventController?.itemList?.clear();*/
  }

  void resetSocietyEventList() {
    /*pagingMySocitiyEventController!.nextPageKey = 1;
    pagingMySocitiyEventController!.itemList?.clear();*/
  }

  void resetAttentingEventList() {
    /*pagingAttendingEventController!.nextPageKey = 1;
    pagingAttendingEventController!.itemList?.clear();*/
  }

// Reset Search
  void resetSearchEventList() {
    /*pagingSearchEventController!.nextPageKey = 1;
    pagingSearchEventController!.itemList?.clear();*/
    searchEventsFilterParams = null;
  }

  void goToEventDetail({int? eventId}) {
    Get.toNamed(AppRoutes.EVENT_DETAIL, arguments: eventId)!.then((value) {
      if (value != null) {
        if (value == Messages.CHECKOUT_SUCCESS) {
          print('Get current page3 ' + Get.currentRoute);
        }
      }
    });
  }

  Future<Either<Failure, DistanceUnit>> getDistanceUnit() async {
    final failureOrDistanceUnit = await this.eventRepo!.getDistanceUnit();
    failureOrDistanceUnit.fold((l) {}, (distanceUnit) {
      selectedDistanceUnit.value = distanceUnit;
    });

    return failureOrDistanceUnit;
  }

  Future<Either<Failure, bool>> saveDistanceUnit({DistanceUnit? distanceUnit}) async {
    selectedDistanceUnit.value = distanceUnit;
    return this.eventRepo!.saveDistanceUnit(distanceUnit: distanceUnit);
  }

  @disposeMethod
  void dispose() {
    resetAllEvent();
    resetFavoriteEventList();
    resetSocietyEventList();
    resetAttentingEventList();
    resetSearchEventList();

    loadedTabIndex.clear();
  }

  onRefreshFavorite() {
    resetFavoriteEventList();
    //just to force refresh
    pagingFavoriteEventController!.appendPage([], 2);
    print('newitems ONREFRESH______________statue=${pagingFavoriteEventController!.value.status}');
    pagingFavoriteEventController!.refresh();
  }

  int refreshAllEventListTimes = 0;
  int refreshFavListTimes = 0;
  int refreshMySocietyListTimes = 0;
  int refreshAttendingListTimes = 0;
  int refreshSearchEventListTimes = 0;

  int preventDuplicatedRefresh({ListId? listId, int? pageKey}) {
    int currentRefreshTime = -1;
    if (listId == ListId.ALLEVENT) {
      currentRefreshTime = refreshAllEventListTimes > 0 ? refreshAllEventListTimes : -1;
      if (pageKey == 1) {
        refreshAllEventListTimes++;
        currentRefreshTime = refreshAllEventListTimes;
      }
    } else if (listId == ListId.FAVORITE) {
      currentRefreshTime = refreshFavListTimes > 0 ? refreshFavListTimes : -1;
      if (pageKey == 1) {
        refreshFavListTimes++;
        currentRefreshTime = refreshFavListTimes;
      }
    } else if (listId == ListId.MYSOCIETY) {
      currentRefreshTime = refreshMySocietyListTimes > 0 ? refreshMySocietyListTimes : -1;
      if (pageKey == 1) {
        refreshMySocietyListTimes++;
        currentRefreshTime = refreshMySocietyListTimes;
      }
    } else if (listId == ListId.ATTENDING) {
      currentRefreshTime = refreshAttendingListTimes > 0 ? refreshAttendingListTimes : -1;
      if (pageKey == 1) {
        refreshAttendingListTimes++;
        currentRefreshTime = refreshAttendingListTimes;
      }
    } else if (listId == ListId.SEARCHEVENT) {
      currentRefreshTime = refreshSearchEventListTimes > 0 ? refreshSearchEventListTimes : -1;
      if (pageKey == 1) {
        refreshSearchEventListTimes++;
        currentRefreshTime = refreshSearchEventListTimes;
      }
    }

    return currentRefreshTime;
  }

  void onRefreshAllEvent() {
    pagingAllEventController!.appendPage([], 2);
    pagingAllEventController!.refresh();
  }

  void onRefreshMySocietyEvent() {
    pagingMySocitiyEventController!.appendPage([], 2);
    pagingMySocitiyEventController!.refresh();
  }

  void onRefreshAttendingEvent() {
    pagingAttendingEventController!.appendPage([], 2);
    pagingAttendingEventController!.refresh();
  }

  List<CustomNativeAd> customNativeAdsAllEvents = [];
  List<CustomNativeAd> customNativeAdsMySocietyEvents = [];
  List<CustomNativeAd> customNativeAdsAttendingEvents = [];
  List<CustomNativeAd> customNativeAdsSearchEvents = [];

  void saveAdToBeDisposed({required CustomNativeAd customNativeAd, required ListId listId}) {
    if (listId == ListId.ALLEVENT) {
      customNativeAdsAllEvents.add(customNativeAd);
    } else if (listId == ListId.MYSOCIETY) {
      customNativeAdsMySocietyEvents.add(customNativeAd);
    } else if (listId == ListId.ATTENDING) {
      customNativeAdsAttendingEvents.add(customNativeAd);
    } else if (listId == ListId.SEARCHEVENT) {
      customNativeAdsSearchEvents.add(customNativeAd);
    }
  }
}
