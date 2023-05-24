import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final storage = FlutterSecureStorage();

  Future<void> saveString(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> readString(String key) async {
    return await storage.read(key: key);
  }

  Future<void> deleteString(String key) {
    return storage.delete(key: key);
  }
}
