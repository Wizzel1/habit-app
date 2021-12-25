// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:Marbit/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String reschedulingNotificationsKey =
      "reschedulingNotifications";
  static const String habitsKey = "habits";
  static const String rewardsKey = "rewards";
  static const String latestPrefixKey = "latestPrefix";

  static Future<void> saveAllHabits(List<Habit> allHabits) async {
    assert(allHabits != null);
    if (allHabits == null) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> _decodedJsonList =
        allHabits.map((e) => e.toJson()).toList();

    final List<String> _encodedJsonList =
        _decodedJsonList.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList(habitsKey, _encodedJsonList);
  }

  static Future<List<Habit>> loadHabits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? _encodedJsonList = prefs.getStringList(habitsKey);

    if (_encodedJsonList == null) return [];

    final List<Map<String, dynamic>?> _decodedJsonList = _encodedJsonList
        .map((e) => jsonDecode(e) as Map<String, dynamic>?)
        .toList();

    final List<Habit> _habits =
        _decodedJsonList.map((e) => Habit.fromJson(e!)).toList();

    return _habits;
  }

  static Future<void> saveAllRewards(List<Reward> allRewards) async {
    assert(allRewards != null);
    if (allRewards == null) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> _decodedJsonList =
        allRewards.map((e) => e.toJson()).toList();

    final List<String> _encodedJsonList =
        _decodedJsonList.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList(rewardsKey, _encodedJsonList);
  }

  static Future<List<Reward>> loadRewards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? _encodedJsonList = prefs.getStringList(rewardsKey);

    if (_encodedJsonList == null) return [];

    final List<Map<String, dynamic>?> _decodedJsonList = _encodedJsonList
        .map((e) => jsonDecode(e) as Map<String, dynamic>?)
        .toList();

    final List<Reward> _rewardList =
        _decodedJsonList.map((e) => Reward.fromJson(e!)).toList();

    return _rewardList;
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveTutorialProgress(String name, bool value) async {
    assert(value != null, "Value must not be null");
    assert(name != null, "Name must not be null");
    if (name == null || value == null) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(name, value);
  }

  static Future<bool> loadTutorialProgress(String name) async {
    assert(name != null, "Name must not be null");
    if (name == null) return false;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? _value = prefs.getBool(name);

    if (_value == null) return false;
    return _value;
  }

  static Future<int> loadLatestNotificationIDprefix() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? _value = prefs.getInt(latestPrefixKey);

    if (_value == null) return 1;

    return _value;
  }

  static Future<void> saveLatestNotificationIDprefix(int value) async {
    assert(value != null, "value must not be null");
    assert(value > 0, "Value must be greater than zero");
    if (value == null || value == 0) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt(latestPrefixKey, value);
  }

  static Future<void> saveObjectForRescheduling(
      NotificationObject object) async {
    assert(object != null, "Object must not be null");
    if (object == null) return;

    final String _encodedObject = jsonEncode(object.toJson());

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? _encodedObjects =
        prefs.getStringList(reschedulingNotificationsKey);

    _encodedObjects == null
        ? _encodedObjects = [_encodedObject]
        : _encodedObjects.add(_encodedObject);

    await prefs.setStringList(reschedulingNotificationsKey, _encodedObjects);
  }
}
