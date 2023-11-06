import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:workoutapp/models/workoutmodels/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  final List<WorkoutModel> _workoutList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<WorkoutModel> get workoutList => _workoutList;

  Future<void> loadWorkouts(String userId) async {
    try {
      final List<WorkoutModel> loadedWorkoutList =
          await fetchWorkoutsWithModel(userId);
      _workoutList.clear();
      _workoutList.addAll(loadedWorkoutList);
      notifyListeners();
    } catch (e) {
      print("Error loading workouts: $e");
    }
  }

  Future<void> addWorkout(String workoutName, String userId) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDoc = userCollection.doc(userId);

    try {
      final CollectionReference workoutsCollection =
          userDoc.collection('workouts');
      final DocumentReference document = workoutsCollection.doc();
      final newWorkout = {
        'id': document.id,
        'name': workoutName,
        'isFavorite': false,
      };

      await document.set(newWorkout);
      notifyListeners();
    } catch (e) {
      print("Error adding workout: $e");
    }
  }

  Future<void> editWorkoutName(
      String userId, String workoutId, String newName) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutId)
          .update({'name': newName});
      notifyListeners();
    } catch (e) {
      print("Error updating workout name: $e");
    }
  }

  Future<List<WorkoutModel>> getFavoriteWorkouts(String uid) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('isFavorite', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        return WorkoutModel(
            id: uid, name: data['name'] ?? ' ', isFavorite: data['isFavorite']);
      }).toList();
    } catch (e) {
      print("Error getting Favorite Workouts $e");
      return [];
    }
  }

  Future<void> deleteWorkout(String userId, String workoutId) async {
    try {
      final userWorkoutReference = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workouts');

      await userWorkoutReference
          .doc(workoutId)
          .collection('exercises')
          .get()
          .then((querySnapshot) {
        for (var exerciseDoc in querySnapshot.docs) {
          exerciseDoc.reference.delete();
        }
      });

      await userWorkoutReference.doc(workoutId).delete();

      notifyListeners();
      print("Workout with ID '$workoutId' deleted successfully.");
    } catch (e) {
      print("Error deleting workout: $e");
    }
  }

    Future<void> onCheckboxChanged(
        String userId, String exerciseName, bool newValue) async {
      final CollectionReference userWorkoutStatusCollection =
          FirebaseFirestore.instance.collection('users');

      try {
        final DateTime today = DateTime.now();
        final String formattedDate = "${today.year}-${today.month}-${today.day}";
        final exerciseStatus = userWorkoutStatusCollection
            .doc(userId)
            .collection('workout_status')
            .doc(formattedDate);

        if (newValue) {
          await exerciseStatus.set({exerciseName: true}, SetOptions(merge: true));
        } else {
          await exerciseStatus
              .set({exerciseName: false}, SetOptions(merge: true));
        }
      } catch (e) {
        print("Error changing exercise status: $e");
      }
    }

  Future<bool> getExerciseStatus(
      String userId, String exerciseName, DateTime date) async {
    try {
      final CollectionReference userWorkoutStatusCollection =
          FirebaseFirestore.instance.collection('users');

      final String formattedDate = "${date.year}-${date.month}-${date.day}";
      final DocumentSnapshot exerciseStatusSnapshot =
          await userWorkoutStatusCollection
              .doc(userId)
              .collection('workout_status')
              .doc(formattedDate)
              .get();

      if (exerciseStatusSnapshot.exists) {
        final Map<String, dynamic>? data =
            exerciseStatusSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey(exerciseName)) {
          return data[exerciseName] as bool;
        }
      }
    } catch (e) {
      print("Error retrieving exercise status: $e");
    }
    return false;
  }

  Future<void> toggleFavoriteStatus(
      String userId, String workoutId, bool isFavorite) async {
    final DocumentReference workoutRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(workoutId);

    try {
      await workoutRef.update({
        'isFavorite': !isFavorite,
      });
      notifyListeners();
    } catch (e) {
      print("Error toggling favorite status: $e");
    }
  }

  Future<void> addExercise(String userId, String workoutId,
      Map<String, dynamic> exerciseData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutId)
          .collection('exercises')
          .add(exerciseData);
      notifyListeners();
    } catch (e) {
      print("Error adding exercise: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> getFavoriteWorkoutsAndExercises(
      String userId) async {
    try {
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference userDoc = userCollection.doc(userId);

      final QuerySnapshot favoriteWorkouts = await userDoc
          .collection('workouts')
          .where('isFavorite', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> favoriteExercisesData = [];

      for (final workout in favoriteWorkouts.docs) {
        final QuerySnapshot exercises =
            await workout.reference.collection('exercises').get();

        for (final exercise in exercises.docs) {
          final exerciseData = exercise.data() as Map<String, dynamic>;
          favoriteExercisesData.add(exerciseData);
        }
      }

      return favoriteExercisesData;
    } catch (e) {
      print("Error retrieving favorite exercises: $e");
      return null;
    }
  }

  Future<void> EditUsername(String uid, String newUsername) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"username": newUsername});
      notifyListeners();
    } catch (e) {
      print("Error editing username $e");
    }
  }

  Future<void> saveUserHeight(String userId, int height) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'height': height});
      notifyListeners();
    } catch (e) {
      print("Error saving height: $e");
    }
  }

  Future<int> getUserHeight(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userData = userDoc.data() as Map<String, dynamic>;
      final height = userData['height'] as int;
      return height;
    } catch (e) {
      print('Error retrieving user height: $e');
      return 0;
    }
  }

  Future<void> saveUserWeight(String userId, int weight) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'weight': weight});
      notifyListeners();
    } catch (e) {
      print("Error saving weight: $e");
    }
  }

  Future<int> getUserWeight(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userData = userDoc.data() as Map<String, dynamic>;
      final weight = userData['weight'] as int;
      return weight;
    } catch (e) {
      print('Error retrieving user weight: $e');
      return 0;
    }
  }

  Future<void> editExercise(String userId, String workoutId, String exerciseId,
      Map<String, dynamic> updatedExerciseData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutId)
          .collection('exercises')
          .doc(exerciseId)
          .update(updatedExerciseData);
      notifyListeners();
    } catch (e) {
      print("Error editing exercise: $e");
    }
  }

  Future<void> deleteExerciseData(
      String userId, String workoutId, String exerciseId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutId)
          .collection('exercises')
          .doc(exerciseId)
          .delete();
      notifyListeners();
    } catch (e) {
      print("Error deleting exercise: $e");
    }
  }

  Future<List<WorkoutModel>> fetchWorkoutsWithModel(String userId) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .get();

    return querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      return WorkoutModel(
          id: e.id,
           name: data['name'] ?? '',
            isFavorite: data['isFavorite']);
    }).toList();
  }
}
