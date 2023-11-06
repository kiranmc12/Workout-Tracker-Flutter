import 'package:hive/hive.dart';

part 'workout_guide_model.g.dart'; // This should match your file name

@HiveType(typeId: 0)
class WorkoutGuide extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String workoutName;

  @HiveField(2)
  String? gifpath;

  @HiveField(3)
  String description;

  @HiveField(4)
  String muscle;

   @HiveField(5)
  String? gifLink;

  WorkoutGuide({
    required this.id,
    required this.workoutName,
    this.gifpath,
    required this.description,
    required this.muscle,
    this.gifLink,
  });
}
