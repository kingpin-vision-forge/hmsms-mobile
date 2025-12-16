import 'package:get_storage/get_storage.dart';

class SecureStorage {
  static GetStorage storage = GetStorage();

  /// Writes data to secure storage
  Future<void> write(String key, dynamic value) async {
    await storage.write(key, value);
  }

  /// Reads data from secure storage
  Future<dynamic> read(String key) async {
    return storage.read(key);
  }

  /// Checks if a key exists in secure storage
  Future<bool> hasData(String key) async {
    return storage.hasData(key);
  }

  /// Deletes a specific key from secure storage
  Future<void> delete(String key) async {
    await storage.remove(key);
  }

  /// Deletes all keys from secure storage
  Future<void> erase() async {
    await storage.erase();
  }
}