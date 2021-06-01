// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:connectivity/connectivity.dart' as _i17;
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i15;

import '../../core/network/network_info.dart' as _i8;
import '../../data/datasources/local/repos/local_event_repo.dart' as _i9;
import '../../data/datasources/local/repos/local_user_repo.dart' as _i11;
import '../../data/datasources/remote/repos/remote_event_repo.dart' as _i10;
import '../../data/datasources/remote/repos/remote_stripe_payment_repo.dart'
    as _i19;
import '../../data/datasources/remote/repos/remote_user_repo.dart' as _i20;
import '../../data/repos/abstract/event_repo.dart' as _i6;
import '../../data/repos/abstract/stripe_payment_repo.dart' as _i21;
import '../../data/repos/abstract/user_repo.dart' as _i4;
import '../../data/repos/event_repo_impl.dart' as _i7;
import '../../data/repos/stripe_payment_repo_impl.dart' as _i22;
import '../../data/repos/user_repo_impl.dart' as _i24;
import '../../presentation/pages/home_page/home.controller.dart' as _i14;
import '../../services/auth_service.dart' as _i3;
import '../../services/event_service.dart' as _i12;
import '../../services/firebase_remote_config_service.dart' as _i13;
import '../../services/location_service.dart' as _i16;
import '../../services/notification_service.dart' as _i18;
import '../../services/stripe_payment_service.dart' as _i23;
import 'register_module.dart' as _i25; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i3.AuthService>(
      () => _i3.AuthService(userRepo: get<_i4.UserRepo>()),
      dispose: (i) => i.dispose());
  gh.lazySingleton<_i5.Dio>(() => registerModule.dio());
  gh.factory<_i6.EventRepo>(() => _i7.EventRepoImpl(
      networkInfo: get<_i8.NetworkInfo>(),
      localEventRepo: get<_i9.LocalEventRepo>(),
      remoteEventRepo: get<_i10.RemoteEventRepo>(),
      localUserRepo: get<_i11.LocalUserRepo>()));
  gh.lazySingleton<_i12.EventService>(
      () => _i12.EventService(
          eventRepo: get<_i6.EventRepo>(), authService: get<_i3.AuthService>()),
      dispose: (i) => i.dispose());
  gh.lazySingleton<_i13.FirebaseRemoteConfigService>(() =>
      _i13.FirebaseRemoteConfigService(
          networkInfo: get<_i8.NetworkInfo>(), dio: get<_i5.Dio>()));
  gh.factory<_i14.HomeController>(() => _i14.HomeController(
      eventService: get<_i12.EventService>(),
      authService: get<_i3.AuthService>()));
  gh.factory<_i9.LocalEventRepo>(
      () => _i9.LocalEventRepoImpl(prefs: get<_i15.SharedPreferences>()));
  gh.factory<_i11.LocalUserRepo>(
      () => _i11.LocalUserRepoImpl(prefs: get<_i15.SharedPreferences>()));
  gh.lazySingleton<_i16.LocationService>(() => _i16.LocationService());
  gh.lazySingleton<_i8.NetworkInfo>(
      () => _i8.NetworkInfoImpl(connectivity: get<_i17.Connectivity>()));
  gh.lazySingleton<_i18.NotificationService>(() => _i18.NotificationService());
  gh.factory<_i10.RemoteEventRepo>(
      () => _i10.RemoteEventRepoImpl(get<_i5.Dio>()));
  gh.factory<_i19.RemoteStripePaymentRepo>(
      () => _i19.RemoteStripePaymentRepoImpl(get<_i5.Dio>()));
  gh.factory<_i20.RemoteUserRepo>(
      () => _i20.RemoteUserRepoImpl(get<_i5.Dio>()));
  await gh.factoryAsync<_i15.SharedPreferences>(() => registerModule.prefs,
      preResolve: true);
  gh.factory<_i21.StripePaymentRepo>(() => _i22.StripePaymentRepoImpl(
      networkInfo: get<_i8.NetworkInfo>(),
      remoteStripePaymentRepo: get<_i19.RemoteStripePaymentRepo>(),
      localUserRepo: get<_i11.LocalUserRepo>()));
  gh.lazySingleton<_i23.StripePaymentService>(() => _i23.StripePaymentService(
      stripePaymentRepo: get<_i21.StripePaymentRepo>()));
  gh.factory<_i4.UserRepo>(() => _i24.UserRepoImpl(
      networkInfo: get<_i8.NetworkInfo>(),
      localUserRepo: get<_i11.LocalUserRepo>(),
      remoteUserRepo: get<_i20.RemoteUserRepo>()));
  gh.singleton<_i17.Connectivity>(registerModule.connectivity);
  return get;
}

class _$RegisterModule extends _i25.RegisterModule {
  @override
  _i17.Connectivity get connectivity => _i17.Connectivity();
}
