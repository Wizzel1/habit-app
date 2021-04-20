import 'package:Marbit/models/models.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static final GetStorage storageBox = GetStorage();

  static void saveAllHabits(List<Habit> allHabits) {
    assert(allHabits != null);

    if (allHabits == null) return;
    List _encodedHabits = allHabits.map((e) => e.toJson()).toList();
    if (_encodedHabits == null) return;
    storageBox.write("habits", _encodedHabits);
  }

  static Future<List<Habit>> loadHabits() async {
    List _encodedHabits = await storageBox.read("habits");
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
    storageBox.write("rewards", _encodedRewards);
  }

  static Future<List<Reward>> loadRewards() async {
    List _encodedRewards = await storageBox.read("rewards");
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
}
