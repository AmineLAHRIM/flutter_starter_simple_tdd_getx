import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_starter/config/constant.dart';
import 'package:flutter_starter/config/messages.dart';
import 'package:flutter_starter/core/network/network_info.dart';

@lazySingleton
class FirebaseRemoteConfigService {
  NetworkInfo? networkInfo;
  // this need to update options
  Dio? dio;

  FirebaseRemoteConfigService({this.networkInfo,this.dio}) {
    networkInfo!.connectionRestoredStream.stream.listen((event) {
      refreshData();
    });
  }

  Future<bool> initialize() async {
    print('welcome message: initialize');

    //return Future.value(true);
    try {
      final RemoteConfig remoteConfig = RemoteConfig.instance;
      final defaults = <String, dynamic>{
        'refund_policy': Messages.REFUND_POLICY,
        'refund_time': Messages.REFUND_TIME,
        'host_url': Constant.HOST_URL,
        'enable_ads': Constant.ENABLE_ADS_MOBILE,
        'native_ad_id': Constant.NATIVE_AD_ID,
        'stripe_secret_key': Constant.STRIPE_SECRET_KEY,
      };
      await remoteConfig.setDefaults(defaults);
      print('welcome message: setDefaults');
      //await remoteConfig.fetch(expiration: const Duration(seconds: 5));
      //set configuartin about fetchTimeout and minimumFetchInterval: time of cache
      await remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(minutes: 1), minimumFetchInterval: const Duration(seconds: 5)));
      return fetchData(remoteConfig: remoteConfig);
    } catch (err) {
      print('welcome message: err ${err}');
      //return Future.value(false);
      await Future.delayed(Duration(seconds: 1));
      return false;
    }
  }

  Future<bool> fetchData({required RemoteConfig remoteConfig}) async {
    try {
      final isUpdated = await remoteConfig.fetchAndActivate();
      if (isUpdated) {
      } else {}
      print('welcome message: fetchAndActivate');
      Messages.REFUND_POLICY = remoteConfig.getString('refund_policy');
      Messages.REFUND_TIME = remoteConfig.getString('refund_time');
      Constant.HOST_URL = remoteConfig.getString('host_url');
      Constant.ENABLE_ADS_MOBILE = remoteConfig.getBool('enable_ads');
      Constant.NATIVE_AD_ID = remoteConfig.getString('native_ad_id');
      Constant.STRIPE_SECRET_KEY = remoteConfig.getString('stripe_secret_key');
      updateApiBaseOptions();


      print('welcome message: ${dio!.options.baseUrl}');
      print('welcome message: ${remoteConfig.getAll()}');
      return true;
    } catch (e) {
      return false;
    }
  }

  void refreshData() {
    fetchData(remoteConfig: RemoteConfig.instance);
  }

  void updateApiBaseOptions() {
    Constant.options.baseUrl=Constant.REMOTE_URL;
    dio!.options = Constant.options;
  }
}
