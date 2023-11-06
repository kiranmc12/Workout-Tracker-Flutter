import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/functions/user_db.dart';

class ExerciseTile extends StatefulWidget {
  final VoidCallback editExerciseCallback;
  final VoidCallback deleteExerciseCallback;
  final String exerciseName;
  final List<String> weight;
  final List<String> reps;
  final List<String> sets;

  const ExerciseTile({
    Key? key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.editExerciseCallback,
    required this.deleteExerciseCallback,
  }) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool ischecked = false;
  final uid = FirestoreServices.getUserId();
  @override
  void initState() {
    super.initState();

    fetchExerciseStatus();
  }

  Future<void> fetchExerciseStatus() async {
    bool status = await Provider.of<WorkoutProvider>(context, listen: false)
        .getExerciseStatus(uid, widget.exerciseName, DateTime.now());
    setState(() {
      ischecked = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 43, 43, 43),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          title: Text(
            widget.exerciseName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Column(
            children: [
              for (int i = 0; i < widget.sets.length; i++)
                Row(
                  children: [
                    Chip(
                      label: Text("Set ${i + 1}"),
                      backgroundColor: Colors.amber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text("${widget.weight[i]} kg"),
                      backgroundColor: Colors.amber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text("${widget.reps[i]} reps"),
                      backgroundColor: Colors.amber,
                    ),
                  ],
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                side: const BorderSide(color: Colors.white, width: 2),
                focusColor: Colors.white,
                checkColor: Colors.white,
                activeColor: Colors.green,
                value: ischecked,
                onChanged: (newBool) {
                  setState(() {
                    ischecked = newBool ?? false;
                    Provider.of<WorkoutProvider>(context, listen: false)
                        .onCheckboxChanged(uid, widget.exerciseName, newBool!);
                  });
                },
              ),
              popUpMenuExercise(widget.exerciseName),
            ],
          ),
        ),
      ),
    );
  }

  Widget popUpMenuExercise(String exerciseName) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
        if (value == "edit") {
          widget.editExerciseCallback();
        }
        if (value == "delete") {
          widget.deleteExerciseCallback();
        }
      },
    );
  }
}
