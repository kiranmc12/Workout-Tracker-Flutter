import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/functions/user_db.dart';

class FavoriteExerciseScreen extends StatelessWidget {
  final String workoutId;
  final uid = FirestoreServices.getUserId();
  final String workoutName;

  FavoriteExerciseScreen(
      {super.key, required this.workoutId, required this.workoutName});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width >= 600;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: const Text("Favorites"),
      ),
      body: FutureBuilder(
        future: workoutProvider.getFavoriteWorkoutsAndExercises(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No exercises found for this workout.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final exercises = snapshot.data as List<Map<String, dynamic>>;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: isLargeScreen ? 20 : 15, bottom: 0),
                  child: Text(
                    "Workouts in $workoutName",
                    style: TextStyle(color: Colors.amber, fontSize: isLargeScreen ? 24 : 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: isLargeScreen ? 20 : 10,
                    bottom: isLargeScreen ? 60 : 40,
                    left: isLargeScreen ? 60 : 40,
                    right: isLargeScreen ? 60 : 40,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 3,
                    color: const Color.fromARGB(
                      255,
                      43,
                      43,
                      43,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return ListTile(
                          title: Text(
                            exercise['exerciseName'] ?? 'Exercise Name',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
