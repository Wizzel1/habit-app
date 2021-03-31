import 'dart:convert';

import 'package:Marbit/models/models.dart';
import 'package:Marbit/util/util.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static final GetStorage storageBox = GetStorage();

  static void saveAllHabitsToLocalStorage(List<Habit> allHabits) {
    List _encodedHabits = allHabits.map((e) => e.toJson()).toList();
    storageBox.write("habits", _encodedHabits);
  }

  static Future<List<Habit>> loadHabitsFromLocalStorage() async {
    List _encodedHabits = await storageBox.read("habits");
    if (_encodedHabits == null) return [];
    List<Habit> _decodedHabits =
        _encodedHabits.map((e) => Habit.fromJson(e)).toList();
    return _decodedHabits;
  }

  static void saveAllRewardsToLocalStorage(List<Reward> allRewards) {
    List _encodedRewards = allRewards.map((e) => e.toJson()).toList();
    storageBox.write("rewards", _encodedRewards);
  }

  static Future<List<Reward>> loadRewardsFromLocalStorage() async {
    List _encodedRewards = await storageBox.read("rewards");
    if (_encodedRewards == null) return [];
    List<Reward> _decodedRewards =
        _encodedRewards.map((e) => Reward.fromJson(e)).toList();
    return _decodedRewards;
  }

  static void saveLatestActiveDay() {
    String _today = DateUtilits.formatter.format(DateTime.now());
    storageBox.write("latestActive", _today);
  }

  static DateTime getLatestActiveDay() {
    String _jsonDate = storageBox.read("latestActive");
    if (_jsonDate == null) return null;
    return DateTime.parse(_jsonDate);
  }
}
