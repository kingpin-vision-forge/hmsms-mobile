import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivityService extends GetxService {
  final Connectivity connectivity = Connectivity();

  /// Checks if the device has an active network adapter (WiFi, Mobile, Ethernet)
  /// This does NOT guarantee internet access, just that a network is available
  Future<bool> hasNetworkAdapter() async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  /// Performs an actual internet reachability check by attempting DNS lookup
  /// Returns true only if we can actually reach the internet
  Future<bool> checkInternetConnectivity() async {
    // First check if we have a network adapter at all
    if (!await hasNetworkAdapter()) {
      return false;
    }

    // Then verify actual internet connectivity with DNS lookup
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      // Network adapter is connected but no internet access
      return false;
    } on TimeoutException catch (_) {
      // Network is too slow or unreachable
      return false;
    } catch (_) {
      // Any other error, assume no internet
      return false;
    }
  }

  /// Returns detailed connectivity status for better error messaging
  Future<ConnectivityStatus> getConnectivityStatus() async {
    // Check network adapter first
    if (!await hasNetworkAdapter()) {
      return ConnectivityStatus.noNetwork;
    }

    // Check actual internet connectivity
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return ConnectivityStatus.connected;
      }
      return ConnectivityStatus.noInternet;
    } on TimeoutException catch (_) {
      return ConnectivityStatus.slowNetwork;
    } catch (_) {
      return ConnectivityStatus.noInternet;
    }
  }
}

/// Enum representing different connectivity states for better error handling
enum ConnectivityStatus {
  connected,    // Internet is working
  noNetwork,    // No network adapter (WiFi/Mobile off)
  noInternet,   // Network adapter on but no internet access
  slowNetwork,  // Network is too slow (timeout)
}