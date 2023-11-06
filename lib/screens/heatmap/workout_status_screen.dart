import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class WorkoutStatusScreen extends StatelessWidget {
  final DateTime date;
  final List<String> workoutStatusData;

  const WorkoutStatusScreen({
    Key? key,
    required this.date,
    required this.workoutStatusData,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat("dd MMM y").format(date);

    final isLargeScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        title: const Text("Completed Workouts"),
      ),
      body: Column(
        children: [
          workoutStatusData.isEmpty
              ? Lottie.network(
                  'https://lottie.host/ca961fb1-b8e5-49b3-b136-24b1ae40d091/vFO9iDQ1MW.json',
                  width: isLargeScreen ? 300 : 400,
                  height: isLargeScreen ? 300 : 400,
                )
              : Lottie.network(
                  'https://lottie.host/13c236fd-a3c6-47c0-84d3-531edc0294da/AxQ8ljAAzq.json',
                  fit: BoxFit.contain,
                  width: isLargeScreen ? 300 : 400,
                  height: isLargeScreen ? 300 : 400,
                ),
          Text(
            formattedDate,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          workoutStatusData.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      "No workouts done for this date.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: workoutStatusData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          workoutStatusData[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
