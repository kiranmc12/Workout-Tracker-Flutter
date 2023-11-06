import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/user_db.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/screens/add_workouts/addexercises.dart';

class AddWorkouts extends StatefulWidget {
  const AddWorkouts({Key? key}) : super(key: key);

  @override
  State<AddWorkouts> createState() => _AddWorkoutsState();
}

class _AddWorkoutsState extends State<AddWorkouts> {
  final newWorkoutNameController = TextEditingController();
  final uid = FirestoreServices.getUserId();

  @override
  void initState() {
    super.initState();
  }

  String getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return 'User not logged in';
    }
  }

  void createWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          MaterialButton(
            onPressed: save,
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

  void deleteConfirmationDialog(String workoutName, context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Workout"),
        content: const Text("Are you sure you want to delete the workout"),
        actions: [
          MaterialButton(
            onPressed: () async {
              await Provider.of<WorkoutProvider>(context, listen: false)
                  .deleteWorkout(uid, id);
              Provider.of<WorkoutProvider>(context, listen: false)
                  .loadWorkouts(uid);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Deleted Successfully"),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("cancel"),
          )
        ],
      ),
    );
  }

  void editPopUp(String id, String currentName) {
    TextEditingController editWorkoutNameController =
        TextEditingController(text: currentName);

    showDialog(
        context: (context),
        builder: (context) => AlertDialog(
              title: const Text("Edit Workout name"),
              content: TextField(
                controller: editWorkoutNameController,
              ),
              actions: [
                MaterialButton(
                  onPressed: () async {
                    final uid = getUserId();

                    String updatedName = editWorkoutNameController.text.trim();
                    if (updatedName.isNotEmpty) {
                      await Provider.of<WorkoutProvider>(context, listen: false)
                          .editWorkoutName(uid, id, updatedName);
                      context.read<WorkoutProvider>().loadWorkouts(uid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Saved Changes",
                            )),
                      );

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Workout name cannot be empty")),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: const Text("cancel"),
                )
              ],
            ));
  }

  Future<void> save() async {
    String newWorkoutName = newWorkoutNameController.text.trim();
    final uid = getUserId();

    if (newWorkoutName.isNotEmpty) {
      try {
        Provider.of<WorkoutProvider>(context, listen: false)
            .addWorkout(newWorkoutName, uid);

        Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts(uid);
        Fluttertoast.showToast(msg: "Workout added successfully");
        Navigator.pop(context);
        clear();
      } catch (e) {
        print("Error adding workout: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workout name cannot be empty")),
      );
    }
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final uid = getUserId();
    Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts(uid);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
            title: const Text("Workouts"),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: createWorkout,
            child: const Icon(
              Icons.add,
              weight: 20,
              color: Colors.black,
            ),
          ),
          body: Column(
            children: [
              Image.asset(
                "assets/bodybuilder2.jpg",
                width: screenWidth,
                height: screenHeight * 0.3,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Add your workout category or workout day",
                  style: TextStyle(color: Colors.white)),
              workoutProvider.workoutList.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Center(
                        child: Text(
                          "No Data",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: workoutProvider.workoutList.length,
                        itemBuilder: (context, index) {
                          final workout = workoutProvider.workoutList[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.01,
                            ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddExercise(
                                    workoutName: workout.name,
                                    id: workout.id,
                                  ),
                                ),
                              );
                            },
                            leading: const CircleAvatar(
                              backgroundColor: Colors.amber,
                              backgroundImage: AssetImage(
                                "assets/dumbell.png",
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            tileColor: const Color.fromARGB(255, 43, 43, 43),
                            contentPadding: const EdgeInsets.all(16),
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            title: Text(workout.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final isFavorite = workout.isFavorite;
          
                                    setState(() {
                                      workout.isFavorite = !isFavorite;
                                    });
          
                                    await Provider.of<WorkoutProvider>(context,
                                            listen: false)
                                        .toggleFavoriteStatus(
                                            uid, workout.id, isFavorite);
                                  },
                                  icon: workout.isFavorite
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.amber,
                                        )
                                      : const Icon(
                                          Icons.favorite_border,
                                          color: Colors.white,
                                        ),
                                ),
                                popUpMenuWorkout(workout.id, workout.name),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget popUpMenuWorkout(String id, String workoutName) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
      ),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            title: Text("Edit"),
            trailing: Icon(Icons.edit),
          ),
        ),
        const PopupMenuItem(
          value: 'share',
          child: ListTile(
            title: Text("Share"),
            trailing: Icon(Icons.share),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            title: Text("Delete"),
            trailing: Icon(Icons.delete),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == "delete") {
          deleteConfirmationDialog(workoutName, context, id);
        }
        if (value == "edit") {
          editPopUp(id, workoutName);
        }
      },
    );
  }
}