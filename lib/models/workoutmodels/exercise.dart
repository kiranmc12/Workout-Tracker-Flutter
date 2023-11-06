import 'package:workoutapp/models/workoutmodels/exercise_sets.dart';

class Exercise {
  final String exerciseName;
  final List<ExerciseSet> sets;

  Exercise({
    required this.exerciseName,
    required this.sets,
  });

  get isCompleted => null;
}