import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/functions/user_db.dart';
import 'package:workoutapp/models/workoutmodels/workout_model.dart';
import 'package:workoutapp/screens/favorites/favorite_exercise.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final userId = FirestoreServices.getUserId();
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width >= 600;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: const Text("Favorites"),
      ),
      body: FutureBuilder<List<WorkoutModel>>(
        future: workoutProvider.getFavoriteWorkouts(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No favorite workouts found.',
              style: TextStyle(color: Colors.white),
            ));
          } else {
            final favoriteWorkouts = snapshot.data!;

            return Padding(
              padding: EdgeInsets.all(isLargeScreen ? 20.0 : 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: isLargeScreen ? 20 : 14),
                    child: Text(
                      "Here are your favorite workouts",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.normal,
                        fontSize: isLargeScreen ? 24 : 20,
                      ),
                    ),
                  ),
                  Lottie.network(
                    'https://lottie.host/2bc1a90c-4c78-450a-86a1-060e2e851249/h8RhxCustP.json',
                    height: isLargeScreen ? 200 : 300,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: favoriteWorkouts.length,
                      itemBuilder: (context, index) {
                        final workout = favoriteWorkouts[index];
                        return ListTile(
                          trailing: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          title: Text(
                            workout.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FavoriteExerciseScreen(
                                          workoutName: workout.name,
                                          workoutId: workout.id,
                                        )));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
