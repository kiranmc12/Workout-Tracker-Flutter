import 'package:flutter/material.dart';
import 'package:workoutapp/functions/exercise_guidedb.dart.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:workoutapp/models/workoutguide/workout_guide_model.dart';

class AddExerciseGuide extends StatefulWidget {
  final Function onAdd;
  final WorkoutGuide? workoutToEdit;

  const AddExerciseGuide({Key? key, required this.onAdd, this.workoutToEdit})
      : super(key: key);

  @override
  AddExerciseGuideState createState() => AddExerciseGuideState();
}

class AddExerciseGuideState extends State<AddExerciseGuide> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final muscleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? gifFile;
  bool isEditMode = false;
  bool gifSelected = false;

  @override
  void initState() {
    super.initState();

    if (widget.workoutToEdit != null) {
      isEditMode = true;
      nameController.text = widget.workoutToEdit!.workoutName;
      muscleController.text = widget.workoutToEdit!.muscle;
      descriptionController.text = widget.workoutToEdit!.description;


      if (widget.workoutToEdit!.gifLink == null) {
        gifFile = File(widget.workoutToEdit!.gifpath!);
      }else{
        gifFile = File(widget.workoutToEdit!.gifLink!);
      }
    }
  }

  void clear() {
    nameController.clear();
    muscleController.clear();
    descriptionController.clear();
    setState(() {
      gifFile = null;
      gifSelected = false;
    });
  }

  Future<void> _pickGif() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        gifFile = File(pickedFile.path);
        gifSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: isEditMode
            ? const Text("Edit Exercise Guide")
            : const Text("Add Exercise Guide"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                 GestureDetector(
  onTap: _pickGif,
  child: CircleAvatar(
    backgroundColor: gifSelected ? Colors.transparent : Colors.grey,
    radius: screenWidth * 0.15,
    child: gifFile != null
        ? gifFile!.path.startsWith('assets/')
            ? Image.asset(
                gifFile!.path,
                height: screenHeight * 0.2,
                width: screenWidth * 0.3,
                fit: BoxFit.cover,
              )
            : Image.file(
                gifFile!,
                height: screenHeight * 0.2,
                width: screenWidth * 0.3,
                fit: BoxFit.cover,
              )
        : Icon(
            Icons.add_photo_alternate,
            size: screenWidth * 0.1,
            color: gifSelected ? Colors.white : Colors.black,
          ),
  ),
),

                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an exercise name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: muscleController,
                    decoration: const InputDecoration(
                      labelText: 'Type of Muscle',
                      labelStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the muscle type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (gifSelected) {
                          final gifPath = gifFile!.path;

                          final newWorkoutGuide = WorkoutGuide(
                            id: isEditMode ? widget.workoutToEdit!.id : null,
                            workoutName: nameController.text,
                            gifLink: gifPath,
                            description: descriptionController.text,
                            muscle: muscleController.text,
                          );

                          if (isEditMode) {
                            await HiveMethods.updateWorkoutGuide(
                                newWorkoutGuide);
                          } else {
                            await HiveMethods.addWorkoutGuide(newWorkoutGuide);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isEditMode
                                  ? "Workout updated successfully"
                                  : "Workout added successfully"),
                            ),
                          );

                          widget.onAdd();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please select a GIF before submitting."),
                            ),
                          );
                        }
                      }
                      clear();
                    },
                    child: Text(isEditMode ? 'Update' : 'Create new'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
