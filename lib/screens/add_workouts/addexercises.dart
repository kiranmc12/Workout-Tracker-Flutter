import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/components/exercise_tile.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/functions/user_db.dart';

class AddExercise extends StatefulWidget {
  final String workoutName;
  final String id;

  const AddExercise({Key? key, required this.workoutName, required this.id})
      : super(key: key);

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final exerciseNameController = TextEditingController();
  final weightControllers = <TextEditingController>[];
  final repsControllers = <TextEditingController>[];
  final setsControllers = <TextEditingController>[];
  final uid = FirestoreServices.getUserId();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      weightControllers.add(TextEditingController());
      repsControllers.add(TextEditingController());
      setsControllers.add(TextEditingController());
    }
  }

  void createNewExercise() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a new exercise"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: exerciseNameController,
                  decoration: const InputDecoration(labelText: "Exercise Name"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter an Exercise name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < 3; i++)
                  Column(
                    children: [
                      Text("Set ${i + 1}"),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: weightControllers[i],
                        decoration: const InputDecoration(labelText: "Weight"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a weight";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: repsControllers[i],
                        decoration: const InputDecoration(labelText: "Reps"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Reps cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
              ],
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                save();
              }
            },
            child: const Text("save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          )
        ],
      ),
    );
  }

  void editExerciseDialog(BuildContext context, String id, String workoutName,
      String exerciseName, Map<String, dynamic> existingData) {
    exerciseNameController.text = exerciseName;

    for (int i = 0; i < 3; i++) {
      weightControllers[i].text = existingData['weights'][i];
      repsControllers[i].text = existingData['reps'][i];
      setsControllers[i].text = existingData['sets'][i];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Exercise Data"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: exerciseNameController,
                decoration: const InputDecoration(labelText: "Exercise Name"),
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < 3; i++)
                Column(
                  children: [
                    Text("Set ${i + 1}"),
                    TextField(
                      controller: weightControllers[i],
                      decoration: const InputDecoration(labelText: "Weight"),
                    ),
                    TextField(
                      controller: repsControllers[i],
                      decoration: const InputDecoration(labelText: "Reps"),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () => saveEditedData(id, workoutName),
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  void deleteExerciseDialogue(
      String exerciseName, String workoutId, String exerciseId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Exercise"),
              content: Text("Are you sure you want to delete $exerciseName"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Provider.of<WorkoutProvider>(context, listen: false)
                        .deleteExerciseData(uid, workoutId, exerciseId);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Deleted Successfully"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  Future<void> saveEditedData(String id, String workoutName) async {
    final weights =
        weightControllers.map((controller) => controller.text).toList();
    final reps = repsControllers.map((controller) => controller.text).toList();
    final sets = setsControllers.map((controller) => controller.text).toList();

    try {
      final exerciseData = {
        'exerciseName': exerciseNameController.text,
        'weights': weights,
        'reps': reps,
        'sets': sets,
      };

      await Provider.of<WorkoutProvider>(context, listen: false)
          .editExercise(uid, widget.id, id, exerciseData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Saved changes successfully"),
        backgroundColor: Colors.green,
      ));

      Navigator.pop(context);
      clear();
    } catch (e) {
      print("Error saving edited exercise: $e");
    }
  }

  Future<void> save() async {
    final exerciseName = exerciseNameController.text;
    final weights =
        weightControllers.map((controller) => controller.text).toList();
    final reps = repsControllers.map((controller) => controller.text).toList();
    final sets = setsControllers.map((controller) => controller.text).toList();

    try {
      final exerciseData = {
        'exerciseName': exerciseName,
        'weights': weights,
        'reps': reps,
        'sets': sets,
      };

      await Provider.of<WorkoutProvider>(context, listen: false)
          .addExercise(uid, widget.id, exerciseData);
      Navigator.pop(context);

      clear();
    } catch (e) {
      print("Error saving exercise: $e");
    }
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    exerciseNameController.clear();
    for (var controller in weightControllers) {
      controller.clear();
    }
    for (var controller in repsControllers) {
      controller.clear();
    }
    for (var controller in setsControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<WorkoutProvider>(
      builder: (context, value, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
          title: const Text("Your Routine"),
          actions:  const [
            
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () => createNewExercise(),
          child:  Icon(
            Icons.add,
            size: screenWidth * 0.1,
            color: Colors.black,
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('workouts')
              .doc(widget.id)
              .collection('exercises')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No exercises data",
                    style: TextStyle(color: Colors.grey)),
              );
            }

            final exercises = snapshot.data!.docs;

            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index].data();

                final exerciseName = exercise['exerciseName'] ?? '';
                final weights = List<String>.from(exercise['weights'] ?? []);
                final reps = List<String>.from(exercise['reps'] ?? []);
                final sets = List<String>.from(exercise['sets'] ?? []);
                final id = exercises[index].id;

                return ExerciseTile(
                  exerciseName: exerciseName,
                  weight: weights,
                  reps: reps,
                  sets: sets,
                  deleteExerciseCallback: () {
                    deleteExerciseDialogue(exerciseName, widget.id, id);
                  },
                  editExerciseCallback: () {
                    editExerciseDialog(context, id, widget.workoutName,
                        exerciseName, exercise);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
