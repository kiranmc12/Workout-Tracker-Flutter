import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/functions/user_db.dart';
import 'package:workoutapp/models/workoutmodels/workout_model.dart';
import 'package:workoutapp/screens/cardio/cardio_screen.dart';
import 'package:workoutapp/screens/heatmap/heat_map.dart';
import 'package:workoutapp/screens/workout_guide/workout_guidelist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;
  int? height;
  int? weight;
  final String uid = FirestoreServices.getUserId();
  List<WorkoutModel> recentWorkouts = []; // List to store recent workouts
  String? imgUrl;

  @override
  void initState() {
    super.initState();
    getUsername();
    getWeight();
    getHeight();
    getUserImage();
  }

  Future<void> getHeight() async {
    try {
      if (uid != 'User not logged in') {
        final fetchedHeight =
            await Provider.of<WorkoutProvider>(context, listen: false)
                .getUserHeight(uid);
        if (fetchedHeight != null) {
          setState(() {
            height = fetchedHeight;
          });
        } else {
          print("Height not found in the Firestore");
        }
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Error getting height $e");
    }
  }

  Future<void> getUserImage() async {
    final uid = FirestoreServices.getUserId();
    if (uid != 'User not logged in') {
      final imageUrl =
          await FirestoreServices.getUserImageUrl(uid); // Await here
      if (imageUrl != null) {
        setState(() {
          imgUrl = imageUrl;
        });
      }
    }
  }

  Future<void> getWeight() async {
    try {
      if (uid != 'User not logged in') {
        final fetchedWeight =
            await Provider.of<WorkoutProvider>(context, listen: false)
                .getUserWeight(uid);
        setState(() {
          weight = fetchedWeight;
        });
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Error getting Weight $e");
    }
  }

  Future<void> getUsername() async {
    try {
      if (uid != 'User not logged in') {
        final fetchedUsername = await FirestoreServices.getUsername(uid);
        if (fetchedUsername != null) {
          setState(() {
            username = fetchedUsername;
          });
        } else {
          print('Username not found in Firestore');
        }
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<WorkoutProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
        appBar: AppBar(
          title: const Text(
            "Home",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
          actions: const [],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: imgUrl != null
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(imgUrl!),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage("assets/profile.jpg"),
                          ),
                    title: Text(
                      "Hi $username",
                      style: TextStyle(
                          fontSize: screenHeight * 0.03, color: Colors.amber),
                    ),
                    subtitle: Text(
                      "Good Morning",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.02,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, top: 20),
                    child: Row(
                      children: [
                        Text(
                          "Weight : ${weight ?? 'N/A'} kg",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        Text(
                          "Height : ${height ?? 'N/A'} cm",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  MyHeatMap(),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Text(
                      "Build your body with us",
                      style: TextStyle(
                          color: Colors.white, fontSize: screenHeight * 0.025),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const WorkoutGuideList()));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(39, 38, 39, 1),
                              ),
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Exercise Guide",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight * 0.018,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Image.asset(
                                      "assets/dumbell.png",
                                      height: 40,
                                      width: 40,
                                      color: Colors.amber,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 15), // Add spacing between the containers
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CardioScreen()));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromRGBO(39, 38, 39, 1),
                              ),
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Cardio",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight * 0.018,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Image.asset(
                                      "assets/cardio.png",
                                      height: 40,
                                      width: 40,
                                      color: Colors.amber,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 20, bottom: 0),
                    child: Text(
                      "The magic that you are looking for is in the work that you are avoiding.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w200),
                    ),
                  ),
                  Lottie.network(
                      'https://lottie.host/92edaef5-2aa4-45d8-a055-89016d79e484/AFqPEYsUvC.json',
                      height: 100,
                      width: 400),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
