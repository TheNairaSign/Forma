import 'package:hive/hive.dart';

class HiveBoxManager {
  static Future<Box<T>> openUserBox<T>({
    required String boxType,
    required String userId,
  }) async {
    final boxName = '${boxType}_$userId';
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  static Future<void> clearUserBox({
    required String boxType,
    required String userId,
  }) async {
    final boxName = '${boxType}_$userId';
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).clear();
    } else {
      final box = await Hive.openBox(boxName);
      await box.clear();
    }
  }

  static Future<void> deleteUserBox({
    required String boxType,
    required String userId,
  }) async {
    final boxName = '${boxType}_$userId';
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }
}
