import 'dart:convert';

import 'package:Marbit/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final String reschedulingNotificationsKey =
      "reschedulingNotifications";
  static final String habitsKey = "habits";
  static final String rewardsKey = "rewards";
  static final String latestPrefixKey = "latestPrefix";

  static Future<void> saveAllHabits(List<Habit> allHabits) async {
    assert(allHabits != null);

    if (allHabits == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> _decodedJsonList =
        allHabits.map((e) => e.toJson()).toList();

    List<String> _encodedJsonList =
        _decodedJsonList.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList(habitsKey, _encodedJsonList);
  }

  static Future<List<Habit>> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _encodedJsonList = prefs.getStringList(habitsKey);

    if (_encodedJsonList == null) return [];

    List<Map<String, dynamic>> _decodedJsonList =
        _encodedJsonList.map((e) => jsonDecode(e)).toList();

    List<Habit> _habits =
        _decodedJsonList.map((e) => Habit.fromJson(e)).toList();

    return _habits;
  }

  static Future<void> saveAllRewards(List<Reward> allRewards) async {
    assert(allRewards != null);

    if (allRewards == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> _decodedJsonList =
        allRewards.map((e) => e.toJson()).toList();

    List<String> _encodedJsonList =
        _decodedJsonList.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList(rewardsKey, _encodedJsonList);
  }

  static Future<List<Reward>> loadRewards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> _encodedJsonList = prefs.getStringList(rewardsKey);

    if (_encodedJsonList == null) return [];

    List<Map<String, dynamic>> _decodedJsonList =
        _encodedJsonList.map((e) => jsonDecode(e)).toList();

    List<Reward> _rewardList =
        _decodedJsonList.map((e) => Reward.fromJson(e)).toList();

    return _rewardList;
  }

  static Future<void> saveTutorialProgress(String name, bool value) async {
    assert(value != null, "Value must not be null");
    assert(name != null, "Name must not be null");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(name, value);
  }

  static Future<bool> loadTutorialProgress(String name) async {
    assert(name != null, "Name must not be null");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(name);

    if (value == null) return false;
    return value;
  }

  static Future<int> loadLatestNotificationIDprefix() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(latestPrefixKey);
    if (value == null) return 1;
    return value;
  }

  static Future<void> saveLatestNotificationIDprefix(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt(latestPrefixKey, value);
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
