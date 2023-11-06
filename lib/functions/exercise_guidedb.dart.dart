import 'package:hive/hive.dart';
import 'package:workoutapp/models/workoutguide/workout_guide_model.dart';

class HiveMethods {
  static const String boxName = 'exercise_guide';

  static Future<bool> addWorkoutGuide(WorkoutGuide model) async {
    try {
      final db = await Hive.openBox<WorkoutGuide>(boxName);
      model.id = DateTime.now().day +
          DateTime.now().hour +
          DateTime.now().minute +
          DateTime.now().microsecond;
      await db.put(model.id, model);
      print("data added");
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<List<WorkoutGuide>> retrieveData() async {
    final db = await Hive.openBox<WorkoutGuide>(boxName);
    return db.values.toList();
  }

  static Future<bool> updateWorkoutGuide(WorkoutGuide model) async {
    try {
      final db = await Hive.openBox<WorkoutGuide>(boxName);
      db.put(model.id!, model);
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<void> deleteData(int id) async {
    final db = await Hive.openBox<WorkoutGuide>(boxName);
    db.delete(id);
  }
}
