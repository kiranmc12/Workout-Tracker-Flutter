import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workoutapp/functions/user_db.dart';
import 'package:workoutapp/screens/heatmap/workout_status_screen.dart';

class MyHeatMap extends StatelessWidget {
  MyHeatMap({
    Key? key,
  }) : super(key: key);

  final uid = FirestoreServices.getUserId();

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final DateTime firstDayOfCurrentMonth = DateTime(currentDate.year, currentDate.month, 1);
    final DateTime lastDayOfPreviousMonth = firstDayOfCurrentMonth.subtract(const Duration(days: 30));
    final DateTime lastDayOfCurrentMonth = currentDate;

    return FutureBuilder<Map<DateTime, int>>(
      future: getWorkoutDataForMonth(uid, lastDayOfPreviousMonth, lastDayOfCurrentMonth),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(
            child: HeatMap(
              datasets: snapshot.data!,
              startDate: lastDayOfPreviousMonth,
              showColorTip: false,
              size: 25,
              endDate: lastDayOfCurrentMonth,
              defaultColor: Colors.grey,
              textColor: Colors.white,
              showText: true,
              scrollable: true,
              colorsets: const {
                1: Colors.green,
              },
              onClick: (value) async {
                List<String> workoutStatusData =
                    await getExerciseNamesForDate(uid, value);
      
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => WorkoutStatusScreen(
                    date: value,
                    workoutStatusData: workoutStatusData,
                  ),
                ));
              },
            ),
          );
        }
      },
    );
  }
}

Future<Map<DateTime, int>> getWorkoutDataForMonth(
    String userId, DateTime startDate, DateTime endDate) async {
  final CollectionReference userWorkoutStatusCollection =
      FirebaseFirestore.instance.collection('users');

  final QuerySnapshot querySnapshot = await userWorkoutStatusCollection
      .doc(userId)
      .collection('workout_status')
      .where(FieldPath.documentId, isGreaterThanOrEqualTo: "${startDate.year}-${startDate.month}-${startDate.day}")
      .where(FieldPath.documentId, isLessThanOrEqualTo: "${endDate.year}-${endDate.month}-${endDate.day}")
      .get();

  final Map<DateTime, int> workoutData = {};

  for (final doc in querySnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final exerciseNames = data.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    if (exerciseNames.isNotEmpty) {
      final dateParts = doc.id.split('-').map(int.parse).toList();
      final date = DateTime(dateParts[0], dateParts[1], dateParts[2]);
      workoutData[date] = 1;
    }
  }

  print(workoutData);
  return workoutData;
}


Future<List<String>> getExerciseNamesForDate(
    String userId, DateTime date) async {
  final CollectionReference userWorkoutStatusCollection =
      FirebaseFirestore.instance.collection('users');

  final String formattedDate = "${date.year}-${date.month}-${date.day}";

  try {
    final DocumentSnapshot statusDocument = await userWorkoutStatusCollection
        .doc(userId)
        .collection('workout_status')
        .doc(formattedDate)
        .get();

    if (statusDocument.exists) {
      final data = statusDocument.data() as Map<String, dynamic>;
      final exerciseNames = data.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key)
          .toList();

      return exerciseNames;
    } else {
      return []; 
    }
  } catch (e) {
    print("Error retrieving exercise names: $e");
    return []; // Return null or handle the error as needed.
  }
}
