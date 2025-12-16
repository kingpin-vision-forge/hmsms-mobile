import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivityService extends GetxService {
  final Connectivity connectivity = Connectivity();

  Future<bool> checkInternetConnectivity() async {
    if (!Platform.isAndroid) {
      // For non-Android platforms, always return true (skip checking)
      return true;
    }

    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet)) {
      // Return true if the device is connected to the internet
      return true;
    }
    // Return false if the device is not connected to the internet
    return false;
  }
}