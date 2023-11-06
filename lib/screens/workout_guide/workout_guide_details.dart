import 'package:flutter/material.dart';
import 'package:workoutapp/models/workoutguide/workout_guide_model.dart';
import 'dart:io';

class WorkoutDetails extends StatelessWidget {
  final WorkoutGuide workout;

  const WorkoutDetails({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = workout.gifLink ?? workout.gifpath;

    final isAsset = imageUrl!.startsWith('assets/');

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: const Text("Exercise Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isAsset
                  ? Image.asset(
                      imageUrl,
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imageUrl),
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.workoutName, // Display the workout name
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Muscle: ${workout.muscle}", // Display the muscle type
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Description",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      workout.description, // Display the workout description
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
