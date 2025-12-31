import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

/// Utility class for collecting device information
class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get device name/model
  /// Returns device model for iOS (e.g., "iPhone 14 Pro")
  /// Returns device model for Android (e.g., "Samsung Galaxy S23")
  static Future<String> getDeviceName() async {
    try {
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // Returns model like "iPhone14,3" which maps to "iPhone 14 Pro"
        return iosInfo.utsname.machine;
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Returns model like "SM-G991B" (Samsung Galaxy S21)
        final manufacturer = androidInfo.manufacturer;
        final model = androidInfo.model;
        return '$manufacturer $model'.trim();
      }
      return 'Unknown Device';
    } catch (e) {
      return 'Unknown Device';
    }
  }

  /// Get user agent string
  /// Format: "AppName/Version (Platform OS Version)"
  /// Example: "HMSMS/1.0.0 (iOS 17.2)"
  static Future<String> getUserAgent() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final appName = packageInfo.appName;
      final version = packageInfo.version;

      String platformInfo = '';
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final osVersion = iosInfo.systemVersion;
        platformInfo = 'iOS $osVersion';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        final osVersion = androidInfo.version.release;
        platformInfo = 'Android $osVersion';
      }

      return '$appName/$version ($platformInfo)';
    } catch (e) {
      return 'HMSMS/Unknown';
    }
  }

  /// Get complete device info for audit logging
  /// Returns a map with deviceName and userAgent
  static Future<Map<String, String>> getDeviceInfo() async {
    final deviceName = await getDeviceName();
    final userAgent = await getUserAgent();
    final ipAddress = await getIpAddress();

    return {
      'deviceName': deviceName,
      'userAgent': userAgent,
      'ipAddress': ipAddress,
    };
  }

  /// Get the device's public IP address
  /// Makes a request to ipify.org to get the public IP
  /// Returns 'Unknown' if unable to fetch
  static Future<String> getIpAddress() async {
    try {
      // Reduced timeout for faster login experience
      final response = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      ).timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ip'] ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      // Silently fail and return Unknown if IP fetch fails or times out
      return 'Unknown';
    }
  }
}
