import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/cardio_db.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/functions/user_db.dart';
import 'package:workoutapp/models/cardio/cardio_model.dart';
import 'package:workoutapp/screens/cardio/cardio_history.dart';

class CardioScreen extends StatefulWidget {
  const CardioScreen({Key? key}) : super(key: key);

  @override
  CardioScreenState createState() => CardioScreenState();
}

class CardioScreenState extends State<CardioScreen> {
  String _dropDownValue = "Running (6 mph)";
  int? userWeight;
  double caloriesBurnt = 0.0;
  Duration _selectedDuration = const Duration(hours: 0, minutes: 0);
  bool isDuartionPickerVisible = false;

  @override
  void initState() {
    super.initState();
    userWeightget();
  }

  final List<String> _items = [
    "Running (6 mph)",
    "Running (7.5 mph)",
    "Running (8.6 mph)",
    "Jogging",
    "Cycling (12-14 mph)",
    "Cycling (14-16 mph)",
    "Cycling (16-19 mph)",
    "Swimming (slow)",
    "Swimming (moderate)",
    "Swimming (fast)",
    "Walking (2.5 mph)",
    "Walking (3.5 mph)",
    "Walking (4.5 mph)",
    "Elliptical trainer",
    "Jumping rope (slow)",
    "Jumping rope (fast)",
    "Rowing (light)",
    "Rowing (moderate)",
    "Rowing (vigorous)",
    "Aerobics (low impact)",
    "Aerobics (high impact)",
    "Dancing (ballroom)",
    "Dancing (fast, aerobic)",
    "Hiking",
    "Skiing (cross-country)",
    "Skiing (downhill)",
    "Stair climbing",
    "Tennis",
    "Basketball",
    "Soccer",
  ];

  Map<String, double> metValues = {
    "Running (6 mph)": 9.8,
    "Running (7.5 mph)": 11.0,
    "Running (8.6 mph)": 12.8,
    "Jogging": 7.0,
    "Cycling (12-14 mph)": 8.0,
    "Cycling (14-16 mph)": 10.0,
    "Cycling (16-19 mph)": 12.0,
    "Swimming (slow)": 5.0,
    "Swimming (moderate)": 7.0,
    "Swimming (fast)": 9.8,
    "Walking (2.5 mph)": 2.9,
    "Walking (3.5 mph)": 3.9,
    "Walking (4.5 mph)": 5.9,
    "Elliptical trainer": 5.0,
    "Jumping rope (slow)": 8.0,
    "Jumping rope (fast)": 12.0,
    "Rowing (light)": 4.0,
    "Rowing (moderate)": 6.0,
    "Rowing (vigorous)": 8.0,
    "Aerobics (low impact)": 5.0,
    "Aerobics (high impact)": 7.0,
    "Dancing (ballroom)": 3.0,
    "Dancing (fast, aerobic)": 7.0,
    "Hiking": 6.0,
    "Skiing (cross-country)": 7.0,
    "Skiing (downhill)": 5.0,
    "Stair climbing": 8.0,
    "Tennis": 7.0,
    "Basketball": 6.0,
    "Soccer": 7.0,
  };

  void calculateCaloriesBurnt(Duration duration) {
    double durationInMinutes = duration.inMinutes.toDouble();
    double durationInHours = durationInMinutes / 60;
    double metValue = metValues[_dropDownValue] ?? 0.0;

    if (userWeight != null) {
      caloriesBurnt = (durationInHours * metValue * 3.5 * userWeight!) / 200.0;
    }

    setState(() {});
  }

  Future<void> showCustomDurationPickerDialog() async {
    Duration? newDuration = await showDurationPicker(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      context: context,
      initialTime: _selectedDuration,
    );

    if (newDuration != null) {
      setState(() {
        _selectedDuration = newDuration;
      });
    }
  }

  Future<void> userWeightget() async {
    try {
      final uid = FirestoreServices.getUserId();
      if (uid != 'User not logged in') {
        final fetchedWeight =
            await Provider.of<WorkoutProvider>(context, listen: false)
                .getUserWeight(uid);
        setState(() {
          userWeight = fetchedWeight;
        });
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching weight: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: const Text("Cardio"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CardioHistory()));
            },
            icon: const Icon(Icons.history),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Lottie.network(
                  'https://lottie.host/8db7b84e-fb65-48dc-8d9c-c3e704f5b201/w0yyTIiYZW.json'),
              Padding(
                padding: EdgeInsets.all(isLargeScreen ? 30.0 : 20.0),
                child: Text(
                  "Calculate the calorie burnt during your cardio",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLargeScreen ? 24 : 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Text(
                    "Select your Cardio exercise",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: isLargeScreen ? 400 : 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: _dropDownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _dropDownValue = newValue!;
                          });
                        },
                        items: _items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      await showCustomDurationPickerDialog();
                    },
                    child: const Text("Add duration"),
                  ),
                  Text(
                    "Duration: ${_selectedDuration.inHours}h ${_selectedDuration.inMinutes.remainder(60)}m",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 43, 43, 43),
                      ),
                      onPressed: () async {
                         if (_selectedDuration == const Duration(hours: 0, minutes: 0)) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Duaration cannot be 0"),backgroundColor: Colors.red,));
                         }
                        calculateCaloriesBurnt(_selectedDuration);

                        final cardioData = CardioModel(
                            id: null,
                            cardioName: _dropDownValue,
                            durationMillis: _selectedDuration.inMilliseconds,
                            caloriesBurnt: caloriesBurnt,
                            cardioDate: DateTime.now().toIso8601String());

                        await Cardiodb.addCardio(cardioData);
                      },
                      child: const Text(
                        "Calculate Calories",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(
                        left: isLargeScreen ? 150 : 70,
                        right: isLargeScreen ? 80 : 40,
                        top: 20,
                        bottom: 0),
                    child: Row(
                      children: [
                         Text(
                          "Calories Burnt :",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: isLargeScreen ? 24 : 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${caloriesBurnt.toStringAsFixed(2)} kcal",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: isLargeScreen ? 24 : 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (caloriesBurnt > 0)
                Padding(
                  padding:  EdgeInsets.all(isLargeScreen ? 15.0 : 10.0),
                  child: Text(
                    "Congrats! you have burnt ${caloriesBurnt.toStringAsFixed(2)} calories in  ${_selectedDuration.inHours}h ${_selectedDuration.inMinutes.remainder(60)}m  ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isLargeScreen ? 20 : 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
