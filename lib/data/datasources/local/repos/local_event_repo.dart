import 'package:injectable/injectable.dart';
import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/data/datasources/local/shared_prefs_constant.dart';
import 'package:flutter_starter/data/models/enums/distance_unit.dart';
import 'package:flutter_starter/data/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalEventRepo {
  Future<bool> cacheFavouriteEvents(List<Event> events);

  DistanceUnit findDistanceUnit();

  Future<bool> cacheDistanceUnit({DistanceUnit? distanceUnit});
}

@Injectable(as: LocalEventRepo)
class LocalEventRepoImpl implements LocalEventRepo {
  SharedPreferences? prefs;

  LocalEventRepoImpl({this.prefs});

  @override
  Future<bool> cacheFavouriteEvents(List<Event> events) {
    // TODO: implement cacheFavouriteEvents
    throw UnimplementedError();
  }

  @override
  DistanceUnit findDistanceUnit() {
    // TODO: implement findDistanceUnit

    try {
      final jsonString = prefs!.getString(DISTANCE_UNIT);
      if (jsonString != null) {
        dynamic data = jsonString;
        if (data == DistanceUnit.KM.toString()) {
          return DistanceUnit.KM;
        } else if (data == DistanceUnit.MI.toString()) {
          return DistanceUnit.MI;
        } else {
          return DistanceUnit.MI;
        }
      } else {
        return DistanceUnit.MI;
      }
    } catch (error) {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheDistanceUnit({DistanceUnit? distanceUnit = DistanceUnit.MI}) {
    // TODO: implement cacheDistanceUnit
    try {
      final jsonString = distanceUnit.toString();
      return prefs!.setString(
        DISTANCE_UNIT,
        jsonString,
      );
    } catch (error) {
      throw CacheException();
    }
  }
}
