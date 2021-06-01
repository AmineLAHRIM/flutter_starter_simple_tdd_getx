import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uuid/uuid.dart';

class CustomNativeAd extends Equatable {
  String? adId;
  NativeAd? nativeAd;
  Completer<NativeAd>? nativeAdCompleter;
  bool failed = false;

  CustomNativeAd({this.adId, this.nativeAd, this.nativeAdCompleter, this.failed = false});

  @override
  // TODO: implement props
  List<Object?> get props => [
        adId,
        nativeAd,
        nativeAdCompleter,
      ];
}
