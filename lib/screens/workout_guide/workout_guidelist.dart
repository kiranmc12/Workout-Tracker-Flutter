import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:workoutapp/functions/exercise_guidedb.dart.dart';
import 'package:workoutapp/models/workoutguide/workout_guide_model.dart';
import 'package:workoutapp/screens/workout_guide/add_exercise_guide.dart';
import 'package:workoutapp/screens/workout_guide/workout_guide_details.dart';

class WorkoutGuideList extends StatefulWidget {
  const WorkoutGuideList({Key? key}) : super(key: key);

  @override
  WorkoutGuideListState createState() => WorkoutGuideListState();
}

class WorkoutGuideListState extends State<WorkoutGuideList> {
  List<WorkoutGuide> exerciseList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // initilizeExerciseList();
    _refreshExerciseList();
    searchController.addListener(_onSearchTextChanged);
  }

  // void initilizeExerciseList() {
  //   print("initilize");
  List<WorkoutGuide> workouts = [
    WorkoutGuide(
      id: 1,
      workoutName: 'Push-Ups',
      gifpath: 'assets/gifs/pushups.gif',
      description:
          'Push-Ups: Push-ups are a classic bodyweight exercise that works the chest, shoulders, and triceps. Variations like incline and decline push-ups can target different areas of the chest .',
      muscle: 'Chest',
    ),
    WorkoutGuide(
      id: 2,
      workoutName: 'Inclined Bench Press (Dumbbell)',
      gifpath: 'assets/gifs/inclinebenchpress.gif',
      description:
          'A chest exercise using dumbbells, targeting pectoral muscles. Offers a greater range of motion, great for strength and size building.',
      muscle: 'Chest',
    ),
    WorkoutGuide(
      id: 3,
      workoutName: 'Pendlay Row',
      gifpath: 'assets/gifs/pendlay-row.gif',
      description:
          'A compound movement with a barbell, targeting the chest and upper back. Ideal for building a strong, well-rounded upper body.',
      muscle: 'Chest',
    ),
    WorkoutGuide(
      id: 4,
      workoutName: 'Declined Bench Press',
      gifpath: 'assets/gifs/declinedbenchpress.gif',
      description:
          'A chest workout with added weight to increase resistance. Effective for strengthening the chest and upper body.',
      muscle: 'Chest',
    ),
    WorkoutGuide(
      id: 5,
      workoutName: 'Chest Dip (Weighted)',
      gifpath: 'assets/gifs/chestdips.gif',
      description:
          'A chest exercise with added weight, focusing on triceps and chest muscles. Enhances upper body strength and muscle development.',
      muscle: 'Chest',
    ),
    WorkoutGuide(
      id: 6,
      workoutName: 'Cable cross over',
      gifpath: 'assets/gifs/cable-cross-over.gif',
      description:
          'A chest exercise using a wide grip barbell, targeting the chest. Excellent for building chest strength and size.',
      muscle: 'Chest',
    ),
    WorkoutGuide(
      id: 7,
      workoutName: 'Pullover (Dumbbell)',
      gifpath: 'assets/gifs/pullover_dumbbell.gif',
      description:
          'A dumbbell exercise targeting the chest muscles, providing a great stretch. Enhances chest muscle flexibility and strength.',
      muscle: 'Chest',
    ),
    WorkoutGuide(
      id: 8,
      workoutName: 'Incline Push Ups',
      gifpath: 'assets/gifs/pullups.gif',
      description:
          'A variation of push-ups, performed at an incline. Great for chest, shoulders, and triceps, targeting the upper chest area.',
      muscle: 'Chest',
    ),

    // Biceps workouts
    WorkoutGuide(
      id: 9,
      workoutName: 'Barbell Curl',
      gifpath: 'assets/gifs/barbell-curl.gif',
      description:
          'Barbell Curl: A fundamental bicep exercise using a barbell. It targets the biceps, helping to build size and strength in your arm muscles.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 10,
      workoutName: 'Hammer Curl',
      gifpath: 'assets/gifs/dumbbell-hammer-curl.gif',
      description:
          'Hammer Curl: A bicep exercise that targets the brachialis and brachioradialis muscles. It\'s great for overall arm development.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 11,
      workoutName: 'Concentration Curl',
      gifpath: 'assets/gifs/concentration_curl.gif',
      description:
          'Concentration Curl: An isolation exercise that hones in on the biceps. It\'s effective for enhancing bicep peak and definition.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 12,
      workoutName: 'Preacher Curl',
      gifpath: 'assets/gifs/preacher-curl.gif',
      description:
          'Preacher Curl: Performed on a preacher bench, this exercise isolates the biceps and helps to develop their shape and strength.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 13,
      workoutName: 'Zottman Curl',
      gifpath: 'assets/gifs/zottman_curl.gif',
      description:
          'Zottman Curl: A versatile curl that targets both biceps and forearms. It\'s an effective way to build well-rounded arm strength.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 14,
      workoutName: 'Drag Curl',
      gifpath: 'assets/gifs/drag-curl.gif',
      description:
          'Drag Curl: A unique curl exercise that emphasizes the biceps. It\'s great for bicep isolation and targeting muscle development.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 15,
      workoutName: 'Pull-Up',
      gifpath: 'assets/gifs/drag-curl.gif',
      description:
          'Chin-Up: A challenging bodyweight exercise that targets the biceps and back. It\'s excellent for building upper body strength.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 16,
      workoutName: 'Reverse-Grip Barbell Row',
      gifpath: 'assets/gifs/reverse_grip_barbell_row.gif',
      description:
          'Reverse-Grip Barbell Row: A back and bicep exercise that emphasizes the biceps. It\'s great for building upper body strength and muscle definition.',
      muscle: 'Biceps',
    ),
    WorkoutGuide(
      id: 17,
      workoutName: 'Cable Curl',
      gifpath: 'assets/gifs/cable-curl.gif',
      description:
          'Cable Curl: A bicep exercise using a cable machine, offering constant tension for muscle growth. It\'s effective for bicep development.',
      muscle: 'Biceps',
    ),

    // Triceps workouts
    WorkoutGuide(
      id: 18,
      workoutName: 'Bench Press - Close Grip',
      gifpath: 'assets/gifs/close-grip-press.gif',
      description:
          'Close-grip bench presses are a popular movement for overloading and strengthening the triceps. The objective is to have your hands close while gripping the barbell, which targets the triceps for improved strength and growth.',
      muscle: 'Triceps',
    ),
    WorkoutGuide(
      id: 19,
      workoutName: 'Diamond Push Up',
      gifpath: 'assets/gifs/diamond-pushup.gif',
      description:
          'Diamond Push Up is a tricep-dominant bodyweight exercise. By placing your hands close together, it effectively works the triceps and is a challenging variation of the classic push-up.',
      muscle: 'Triceps',
    ),
    WorkoutGuide(
      id: 20,
      workoutName: 'Inclined Skullcrusher',
      gifpath: 'assets/gifs/incline-skullcrusher.gif',
      description:
          'Dumbbell Skullcrusher is a tricep isolation exercise. It involves lowering a dumbbell behind your head, targeting the triceps and aiding in tricep muscle development.',
      muscle: 'Triceps',
    ),

    WorkoutGuide(
      id: 22,
      workoutName: 'Ring Dips',
      gifpath: 'assets/gifs/ring-dip.gif',
      description:
          'Ring Dips are a challenging bodyweight exercise that focuses on the triceps. They require stability and strength, making them a great choice for tricep development.',
      muscle: 'Triceps',
    ),
    WorkoutGuide(
      id: 23,
      workoutName: 'Skullcrusher (Barbell)',
      gifpath: 'assets/gifs/barbellskullcrusher.gif',
      description:
          'Skullcrusher is a tricep exercise using a barbell. It targets the triceps by lowering the barbell towards the forehead, making it an effective tricep strength builder.',
      muscle: 'Triceps',
    ),
    WorkoutGuide(
      id: 24,
      workoutName: 'Triceps Dip (Weighted)',
      gifpath: 'assets/gifs/tricepsdips.gif',
      description:
          'Triceps Dip (Weighted) is performed on a machine with added resistance. It\'s a great choice for developing tricep strength and muscle definition.',
      muscle: 'Triceps',
    ),
    WorkoutGuide(
      id: 25,
      workoutName: 'Triceps Extension (Suspension)',
      gifpath: 'assets/gifs/drag-curl.gif',
      description:
          'Triceps Extension with a suspension band is an effective way to work the triceps. It\'s great for bodyweight tricep training and muscle engagement.',
      muscle: 'Triceps',
    ),
    WorkoutGuide(
      id: 26,
      workoutName: 'Triceps Rope Pushdown',
      gifpath: 'assets/gifs/triceps-rope-pushdown.gif',
      description:
          'Triceps rope pushdowns are an effective isolation exercise you can use to inflate the back of your upper arms. The objective is to use a rope attachment on a pulley system, repeatedly extending your arms against resistance.',
      muscle: 'Triceps',
    ),
  ];

  void _refreshExerciseList() async {
    final box = await Hive.openBox<WorkoutGuide>('exercise_guide');

    // Check if the box is empty
    if (box.isEmpty) {
      // Initialize the box with default workouts

      for(var workout in workouts){
        await box.put(workout.id, workout);

      }
      
    }

    // Retrieve the data from the box
    final updatedList = box.values.toList();

    setState(() {
      exerciseList = updatedList;
    });
  }

  void deleteWorkoutGuideDialogue(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you want to delete"),
              actions: [
                MaterialButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                MaterialButton(
                    child: const Text("Confirm"),
                    onPressed: () async {
                      await HiveMethods.deleteData(id);
                      _refreshExerciseList();
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  // void _refreshExerciseList() async {
  //   final updatedList = await HiveMethods.retrieveData();
  //   setState(() {
  //     exerciseList = updatedList;
  //   });
  // }

  void _filterExerciseList(String query) {
    final filteredList = exerciseList
        .where((workoutGuide) => workoutGuide.workoutName
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    setState(() {
      exerciseList = filteredList;
    });
  }

  void _onSearchTextChanged() {
    final text = searchController.text;
    if (text.isEmpty) {
      _refreshExerciseList();
    } else {
      _filterExerciseList(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: const Text("Exercise Guide"),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddExerciseGuide(
                    onAdd: _refreshExerciseList,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "All exercises",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Search Exercise",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  _onSearchTextChanged();
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 43, 43, 43),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search by Workout Name",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            exerciseList.isEmpty
                ? const Center(
                    child: Text(
                      "No workout data available.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: exerciseList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final workoutGuide = exerciseList[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage("assets/dumbell.png"),
                            backgroundColor: Colors.amber,
                          ),
                          title: Text(
                            workoutGuide.workoutName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            workoutGuide.muscle,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetails(
                                  workout: workoutGuide,
                                ),
                              ),
                            );
                          },
                          trailing: PopupMenuButton<String>(
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
                                value: 'delete',
                                child: ListTile(
                                  title: Text("Delete"),
                                  trailing: Icon(Icons.delete),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == "delete") {
                                deleteWorkoutGuideDialogue(workoutGuide.id!);
                              }
                              if (value == "edit") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddExerciseGuide(
                                        onAdd: _refreshExerciseList,
                                        workoutToEdit: exerciseList[index]),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
