import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String pagesBoxName = 'characters_pages';
  static const String favoritesBoxName = 'favorites';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(pagesBoxName);
    await Hive.openBox<dynamic>(favoritesBoxName);
  }

  Box<dynamic> get pagesBox => Hive.box<dynamic>(pagesBoxName);
  Box<dynamic> get favoritesBox => Hive.box<dynamic>(favoritesBoxName);
}
