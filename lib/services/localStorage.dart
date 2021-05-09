import 'dart:convert';

import 'package:Marbit/models/models.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final GetStorage storageBox = GetStorage();
  static final String reschedulingNotificationsKey =
      "reschedulingNotifications";
  static final String habitsKey = "habits";
  static final String rewardsKey = "rewards";
  static final String latestPrefixKey = "latestPrefix";

  static void saveAllHabits(List<Habit> allHabits) {
    assert(allHabits != null);

    if (allHabits == null) return;
    List _encodedHabits = allHabits.map((e) => e.toJson()).toList();
    if (_encodedHabits == null) return;
    storageBox.write(habitsKey, _encodedHabits);
  }

  static Future<List<Habit>> loadHabits() async {
    List _encodedHabits = await storageBox.read(habitsKey);
    if (_encodedHabits == null) return [];
    List<Habit> _decodedHabits =
        _encodedHabits.map((e) => Habit.fromJson(e)).toList();
    return _decodedHabits;
  }

  static void saveAllRewards(List<Reward> allRewards) {
    assert(allRewards != null);

    if (allRewards == null) return;
    List _encodedRewards = allRewards.map((e) => e.toJson()).toList();
    if (_encodedRewards == null) return;
    storageBox.write(rewardsKey, _encodedRewards);
  }

  static Future<List<Reward>> loadRewards() async {
    List _encodedRewards = await storageBox.read(rewardsKey);
    if (_encodedRewards == null) return [];
    List<Reward> _decodedRewards =
        _encodedRewards.map((e) => Reward.fromJson(e)).toList();
    return _decodedRewards;
  }

  static void saveTutorialProgress(String name, bool value) {
    assert(value != null, "Value must not be null");
    assert(name != null, "Name must not be null");
    storageBox.write(name, value);
  }

  static Future<bool> loadTutorialProgress(String name) async {
    assert(name != null, "Name must not be null");
    bool value = await storageBox.read(name);
    if (value == null) return false;
    return value;
  }

  static Future<int> loadLatestNotificationIDprefix() async {
    int value = await storageBox.read(latestPrefixKey);
    if (value == null) return 1;
    return value;
  }

  static Future<void> saveLatestNotificationIDprefix(int value) async {
    await storageBox.write(latestPrefixKey, value);
  }

  static Future<void> saveObjectForRescheduling(
      NotificationObject object) async {
    String _encodedObject = jsonEncode(object.toJson());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> _encodedObjects =
        prefs.getStringList(reschedulingNotificationsKey);

    _encodedObjects == null
        ? _encodedObjects = [_encodedObject]
        : _encodedObjects.add(_encodedObject);

    await prefs.setStringList(reschedulingNotificationsKey, _encodedObjects);
  }
}
