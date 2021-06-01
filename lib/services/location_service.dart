import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

enum LOCATION_STATUS {
  SERVICE_DISABLED,
  PERMISSION_DENIED,
  PERMISSION_DENIED_FOREVER,
  PERMISSION_GRANTED,
}

@lazySingleton
class LocationService {
  Location location = new Location();
  var locationData = Rx<LocationData?>(null);

  LocationService() {
    setupLocationListener();
  }

  Future<LOCATION_STATUS> checkForGeo() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LOCATION_STATUS.SERVICE_DISABLED;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        print('_permissionGranted03 :$_permissionGranted');
        return LOCATION_STATUS.PERMISSION_DENIED;
      } else if (_permissionGranted == PermissionStatus.deniedForever) {
        print('_permissionGranted04 :$_permissionGranted');
        return LOCATION_STATUS.PERMISSION_DENIED_FOREVER;
      }
    }

    locationData.value = await location.getLocation();
    print('_permissionGranted05 :$_permissionGranted');
    return LOCATION_STATUS.PERMISSION_GRANTED;
  }

  void setupLocationListener() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      //print('currentLocation ${currentLocation}');
      locationData.value = currentLocation;
    });
  }
}
